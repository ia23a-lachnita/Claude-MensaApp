package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MfaSetupResponse {
    private String qrCodeUrl;
    private String secret;
}
