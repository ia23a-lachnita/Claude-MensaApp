package ch.mensaapp.api.payload.request;

import ch.mensaapp.api.models.ZahlungsMethode;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ZahlungRequest {
    @NotNull
    private ZahlungsMethode zahlungsMethode;

    @NotNull
    private BigDecimal betrag;

    // Kreditkarte/Debitkarte Felder
    private String kartenNummer;
    private String kartenName;
    private String kartenCVV;
    private String kartenAblaufMonat;
    private String kartenAblaufJahr;
    
    // Mock Provider Felder
    private Boolean mockPaymentSuccess; // For testing payment success/failure
}
