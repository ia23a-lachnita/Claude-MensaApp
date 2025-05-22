package ch.mensaapp.api.services;

import ch.mensaapp.api.models.ERole;
import ch.mensaapp.api.models.Role;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.payload.request.PasswordUpdateRequest;
import ch.mensaapp.api.payload.request.ProfileUpdateRequest;
import ch.mensaapp.api.payload.response.UserResponse;
import ch.mensaapp.api.repositories.RoleRepository;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(UserResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public UserResponse getUserById(Long id) {
        return UserResponse.fromEntity(userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden")));
    }

    @Transactional
    public UserResponse updateUserProfile(Long id, ProfileUpdateRequest profileRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        // Prüfen, ob die E-Mail bereits von einem anderen Benutzer verwendet wird
        if (!user.getEmail().equals(profileRequest.getEmail()) && 
            userRepository.existsByEmail(profileRequest.getEmail())) {
            throw new RuntimeException("E-Mail wird bereits verwendet");
        }

        user.setVorname(profileRequest.getVorname());
        user.setNachname(profileRequest.getNachname());
        user.setEmail(profileRequest.getEmail());

        return UserResponse.fromEntity(userRepository.save(user));
    }

    @Transactional
    public void updatePassword(Long id, PasswordUpdateRequest passwordRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        // Prüfen, ob das alte Passwort korrekt ist
        if (!encoder.matches(passwordRequest.getAltesPassword(), user.getPassword())) {
            throw new RuntimeException("Altes Passwort ist nicht korrekt");
        }

        user.setPassword(encoder.encode(passwordRequest.getNeuesPassword()));
        userRepository.save(user);
    }

    @Transactional
    public UserResponse updateUserRoles(Long id, List<String> roleNames) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        Set<Role> roles = new HashSet<>();
        for (String roleName : roleNames) {
            ERole eRole;
            try {
                eRole = ERole.valueOf("ROLE_" + roleName.toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Rolle nicht gefunden: " + roleName);
            }

            Role role = roleRepository.findByName(eRole)
                    .orElseThrow(() -> new RuntimeException("Rolle nicht gefunden: " + eRole));
            roles.add(role);
        }

        user.setRoles(roles);
        return UserResponse.fromEntity(userRepository.save(user));
    }
}
