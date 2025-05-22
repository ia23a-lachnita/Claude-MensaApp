package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class MfaSetupRequest {
    @NotBlank
    @Email
    private String email;
}
