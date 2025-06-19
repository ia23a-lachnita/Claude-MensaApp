package ch.mensaapp.api.security;

import ch.mensaapp.api.services.BruteForceProtectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationSuccessListener
        implements ApplicationListener<AuthenticationSuccessEvent> {

    @Autowired
    private BruteForceProtectionService bruteForceService;

    @Override
    public void onApplicationEvent(AuthenticationSuccessEvent event) {
        Object principal = event.getAuthentication().getPrincipal();
        if (principal instanceof UserDetailsImpl userDetails) {
            // only reset for users who do *not* have MFA enabled
            if (!userDetails.isMfaEnabled()) {
                bruteForceService.resetFailedAttempts(userDetails.getUsername());
            }
        }
    }
}
