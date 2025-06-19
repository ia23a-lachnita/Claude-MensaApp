package ch.mensaapp.api.security;

import ch.mensaapp.api.services.BruteForceProtectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationFailureListener implements ApplicationListener<AuthenticationFailureBadCredentialsEvent> {

    @Autowired
    private BruteForceProtectionService bruteForceService;

    @Override
    public void onApplicationEvent(AuthenticationFailureBadCredentialsEvent event) {
        String email = event.getAuthentication().getName();
        bruteForceService.registerFailedAttempt(email);
    }
}
