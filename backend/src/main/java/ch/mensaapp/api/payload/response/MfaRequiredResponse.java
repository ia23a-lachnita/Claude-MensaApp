package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MfaRequiredResponse {
    private String email;
    private final boolean mfaRequired = true;
}
