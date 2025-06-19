package ch.mensaapp.api.services;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Optional;

@Service
@Transactional
public class BruteForceProtectionService {

    private static final int MAX_FAILED_ATTEMPTS = 3;
    private static final long LOCK_TIME_DURATION = 10 * 60 * 1000; // 10 Minuten

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    public void registerFailedAttempt(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            int newFailAttempts = user.getFailedAttempt() + 1;
            user.setFailedAttempt(newFailAttempts);

            if (newFailAttempts >= MAX_FAILED_ATTEMPTS) {
                user.setAccountNonLocked(false);
                user.setLockTime(new Date());

                // Info-Mail senden wie in User Story gefordert
                emailService.sendeAccountSperrungEmail(user);
                System.out.println("Account gesperrt für: " + email + " nach " + newFailAttempts + " Fehlversuchen");
            }

            userRepository.save(user);
        }
    }

    public void resetFailedAttempts(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setFailedAttempt(0);
            userRepository.save(user);
        }
    }

    public boolean unlockWhenTimeExpired(User user) {
        if (user.getLockTime() != null) {
            long lockTimeInMillis = user.getLockTime().getTime();
            long currentTimeInMillis = System.currentTimeMillis();

            if (lockTimeInMillis + LOCK_TIME_DURATION < currentTimeInMillis) {
                user.setAccountNonLocked(true);
                user.setLockTime(null);
                user.setFailedAttempt(0);
                userRepository.save(user);
                return true;
            }
        }
        return false;
    }
}
