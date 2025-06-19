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
                .orElseThrow(() -> new UsernameNotFoundException("Benutzer mit E-Mail " + email + " nicht gefunden"));

        // Prüfe ob Account entsperrt werden kann
        if (!user.isAccountNonLocked()) {
            if (bruteForceService.unlockWhenTimeExpired(user)) {
                // Account wurde entsperrt, lade User neu
                user = userRepository.findByEmail(email).get();
            } else {
                throw new AccountExpiredException("Account ist gesperrt. Versuchen Sie es später erneut.");
            }
        }

        return UserDetailsImpl.build(user);
    }
}
