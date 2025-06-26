package ch.mensaapp.api.security;

import ch.mensaapp.api.models.User;
import ch.mensaapp.api.repositories.UserRepository;
import ch.mensaapp.api.services.BruteForceProtectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    UserRepository userRepository;

    @Autowired
    BruteForceProtectionService bruteForceService;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new UsernameNotFoundException("Benutzer mit E-Mail " + email + " nicht gefunden"));

        // Versuch, gesperrte Accounts nach Wartezeit automatisch zu entsperren
        if (!user.isAccountNonLocked() && bruteForceService.unlockWhenTimeExpired(user)) {
            user = userRepository.findByEmail(email).get();
        }

        // Gebe UserDetailsImpl zurück und lass Spring die Sperr-Checks machen
        return UserDetailsImpl.build(user);
    }
}
