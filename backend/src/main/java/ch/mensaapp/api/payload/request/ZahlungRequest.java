package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ZahlungRequest {
    @NotBlank
    private String zahlungsMethode;

    @NotNull
    private BigDecimal betrag;

    private String kartenNummer;
    
    private String kartenName;
    
    private String kartenCVV;
    
    private String kartenAblaufMonat;
    
    private String kartenAblaufJahr;
}
