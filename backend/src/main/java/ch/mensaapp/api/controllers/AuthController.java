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
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
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

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        if (userDetails.isMfaEnabled()) {
            return ResponseEntity.ok(new MfaRequiredResponse(userDetails.getEmail()));
        } else {
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
    }

    @PostMapping("/mfa-verify")
    public ResponseEntity<?> verifyMfaCode(@Valid @RequestBody MfaVerificationRequest verificationRequest) {
        User user = userRepository.findByEmail(verificationRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(verificationRequest.getCode(), user.getMfaSecret())) {
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
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
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
        User user = userRepository.findByEmail(setupRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        String secret = mfaUtils.generateSecret();
        String qrCodeImageUri = mfaUtils.generateQrCodeImageUri(secret, user.getEmail());

        user.setMfaSecret(secret);
        userRepository.save(user);

        return ResponseEntity.ok(new MfaSetupResponse(qrCodeImageUri, secret));
    }

    @PostMapping("/mfa-enable")
    public ResponseEntity<?> enableMfa(@Valid @RequestBody MfaEnableRequest enableRequest) {
        User user = userRepository.findByEmail(enableRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(enableRequest.getCode(), user.getMfaSecret())) {
            user.setMfaEnabled(true);
            userRepository.save(user);
            return ResponseEntity.ok(new MessageResponse("MFA erfolgreich aktiviert"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
        }
    }

    @PostMapping("/mfa-disable")
    public ResponseEntity<?> disableMfa(@Valid @RequestBody MfaDisableRequest disableRequest) {
        User user = userRepository.findByEmail(disableRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(disableRequest.getCode(), user.getMfaSecret())) {
            user.setMfaEnabled(false);
            user.setMfaSecret(null);
            userRepository.save(user);
            return ResponseEntity.ok(new MessageResponse("MFA erfolgreich deaktiviert"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
        }
    }
}
