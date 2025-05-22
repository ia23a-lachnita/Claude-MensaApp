package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class PasswordUpdateRequest {
    @NotBlank
    private String altesPassword;

    @NotBlank
    @Size(min = 8, max = 50)
    private String neuesPassword;
}
