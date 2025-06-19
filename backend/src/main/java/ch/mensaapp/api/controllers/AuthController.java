package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.ERole;
import ch.mensaapp.api.models.Role;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.payload.request.*;
import ch.mensaapp.api.payload.response.*;
import ch.mensaapp.api.repositories.RoleRepository;
import ch.mensaapp.api.repositories.UserRepository;
import ch.mensaapp.api.security.JwtUtils;
import ch.mensaapp.api.security.MfaUtils;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.BruteForceProtectionService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private MfaUtils mfaUtils;

    @Autowired
    private BruteForceProtectionService bruteForceService;

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

            if (userDetails.isMfaEnabled()) {
                return ResponseEntity.ok(new MfaRequiredResponse(userDetails.getEmail()));
            } else {
                // reset here
                bruteForceService.resetFailedAttempts(userDetails.getUsername());

                String jwt = jwtUtils.generateJwtToken(authentication);
                List<String> roles = userDetails.getAuthorities().stream()
                        .map(item -> item.getAuthority())
                        .collect(Collectors.toList());

                return ResponseEntity.ok(new JwtResponse(jwt,
                        userDetails.getId(),
                        userDetails.getUsername(),
                        userDetails.getVorname(),
                        userDetails.getNachname(),
                        roles));
            }
        } catch (DisabledException e) {
            return ResponseEntity.status(HttpStatus.LOCKED) // 423 Locked
                    .body(new MessageResponse("Account ist deaktiviert"));
        } catch (AccountExpiredException e) {
            return ResponseEntity.status(HttpStatus.LOCKED) // 423 Locked
                    .body(new MessageResponse("Account ist gesperrt. Bitte versuchen Sie es in 10 Minuten erneut."));
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED) // 401 Unauthorized
                    .body(new MessageResponse("Ungültige E-Mail oder Passwort"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("Ein Fehler ist aufgetreten"));
        }
    }

    @PostMapping("/mfa-verify")
    public ResponseEntity<?> verifyMfaCode(@Valid @RequestBody MfaVerificationRequest verificationRequest) {
        try {
            User user = userRepository.findByEmail(verificationRequest.getEmail())
                    .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

            // Check if account is locked due to failed MFA attempts
            if (!user.isAccountNonLocked()) {
                // Try to unlock if time has expired
                if (!bruteForceService.unlockWhenTimeExpired(user)) {
                    return ResponseEntity.status(HttpStatus.LOCKED) // 423 Locked
                            .body(new MessageResponse("Account ist gesperrt. Bitte versuchen Sie es in 10 Minuten erneut."));
                }
                // If unlocked, reload user to get updated status
                user = userRepository.findByEmail(verificationRequest.getEmail()).get();
            }

            // Verify the MFA code
            if (mfaUtils.verifyCode(verificationRequest.getCode(), user.getMfaSecret())) {
                // MFA verification successful - reset failed attempts and proceed with login
                bruteForceService.resetFailedAttempts(verificationRequest.getEmail());

                Authentication authentication = authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(verificationRequest.getEmail(), verificationRequest.getPassword()));

                SecurityContextHolder.getContext().setAuthentication(authentication);
                String jwt = jwtUtils.generateJwtToken(authentication);
                UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

                List<String> roles = userDetails.getAuthorities().stream()
                        .map(item -> item.getAuthority())
                        .collect(Collectors.toList());

                return ResponseEntity.ok(new JwtResponse(jwt,
                        userDetails.getId(),
                        userDetails.getUsername(),
                        userDetails.getVorname(),
                        userDetails.getNachname(),
                        roles));
            } else {
                // MFA verification failed - register failed attempt
                bruteForceService.registerFailedAttempt(verificationRequest.getEmail());
                return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new MessageResponse("Fehler bei der MFA-Verifizierung: " + e.getMessage()));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Fehler: E-Mail ist bereits in Verwendung!"));
        }

        // Create new user's account
        User user = new User();
        user.setVorname(signUpRequest.getVorname());
        user.setNachname(signUpRequest.getNachname());
        user.setEmail(signUpRequest.getEmail());
        user.setPassword(encoder.encode(signUpRequest.getPassword()));

        Set<Role> roles = new HashSet<>();
        Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Fehler: Rolle nicht gefunden."));
        roles.add(userRole);

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("Benutzer erfolgreich registriert!"));
    }

    @PostMapping("/mfa-setup")
    public ResponseEntity<?> setupMfa(@Valid @RequestBody MfaSetupRequest setupRequest) {
        try {
            User user = userRepository.findByEmail(setupRequest.getEmail())
                    .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

            String secret = mfaUtils.generateSecret();
            String qrCodeImageUri = mfaUtils.generateQrCodeImageUri(secret, user.getEmail());

            user.setMfaSecret(secret);
            userRepository.save(user);

            return ResponseEntity.ok(new MfaSetupResponse(qrCodeImageUri, secret));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new MessageResponse("Fehler beim Einrichten der MFA: " + e.getMessage()));
        }
    }

    @PostMapping("/mfa-enable")
    public ResponseEntity<?> enableMfa(@Valid @RequestBody MfaEnableRequest enableRequest) {
        try {
            User user = userRepository.findByEmail(enableRequest.getEmail())
                    .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

            // Check if account is locked due to failed MFA attempts
            if (!user.isAccountNonLocked()) {
                // Try to unlock if time has expired
                if (!bruteForceService.unlockWhenTimeExpired(user)) {
                    return ResponseEntity.status(HttpStatus.LOCKED) // 423 Locked
                            .body(new MessageResponse("Account ist gesperrt. Bitte versuchen Sie es in 10 Minuten erneut."));
                }
                // If unlocked, reload user to get updated status
                user = userRepository.findByEmail(enableRequest.getEmail()).get();
            }

            if (mfaUtils.verifyCode(enableRequest.getCode(), user.getMfaSecret())) {
                // MFA enable successful - reset failed attempts
                bruteForceService.resetFailedAttempts(enableRequest.getEmail());

                user.setMfaEnabled(true);
                userRepository.save(user);
                return ResponseEntity.ok(new MessageResponse("MFA erfolgreich aktiviert"));
            } else {
                // MFA verification failed - register failed attempt
                bruteForceService.registerFailedAttempt(enableRequest.getEmail());
                return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new MessageResponse("Fehler beim Aktivieren der MFA: " + e.getMessage()));
        }
    }

    @PostMapping("/mfa-disable")
    public ResponseEntity<?> disableMfa(@Valid @RequestBody MfaDisableRequest disableRequest) {
        try {
            User user = userRepository.findByEmail(disableRequest.getEmail())
                    .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

            // Check if account is locked due to failed MFA attempts
            if (!user.isAccountNonLocked()) {
                // Try to unlock if time has expired
                if (!bruteForceService.unlockWhenTimeExpired(user)) {
                    return ResponseEntity.status(HttpStatus.LOCKED) // 423 Locked
                            .body(new MessageResponse("Account ist gesperrt. Bitte versuchen Sie es in 10 Minuten erneut."));
                }
                // If unlocked, reload user to get updated status
                user = userRepository.findByEmail(disableRequest.getEmail()).get();
            }

            if (mfaUtils.verifyCode(disableRequest.getCode(), user.getMfaSecret())) {
                // MFA disable successful - reset failed attempts
                bruteForceService.resetFailedAttempts(disableRequest.getEmail());

                user.setMfaEnabled(false);
                user.setMfaSecret(null);
                userRepository.save(user);
                return ResponseEntity.ok(new MessageResponse("MFA erfolgreich deaktiviert"));
            } else {
                // MFA verification failed - register failed attempt
                bruteForceService.registerFailedAttempt(disableRequest.getEmail());
                return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new MessageResponse("Fehler beim Deaktivieren der MFA: " + e.getMessage()));
        }
    }
}
