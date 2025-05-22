package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Zahlung;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ZahlungResponse {
    private Long id;
    private Long bestellungId;
    private BigDecimal betrag;
    private LocalDateTime zeitpunkt;
    private String zahlungsMethode;
    private String transaktionsId;
    private boolean erfolgreich;
    private String fehlerMeldung;

    public static ZahlungResponse fromEntity(Zahlung zahlung) {
        ZahlungResponse response = new ZahlungResponse();
        response.setId(zahlung.getId());
        response.setBestellungId(zahlung.getBestellung().getId());
        response.setBetrag(zahlung.getBetrag());
        response.setZeitpunkt(zahlung.getZeitpunkt());
        response.setZahlungsMethode(zahlung.getZahlungsMethode());
        response.setTransaktionsId(zahlung.getTransaktionsId());
        response.setErfolgreich(zahlung.isErfolgreich());
        response.setFehlerMeldung(zahlung.getFehlerMeldung());
        return response;
    }
}
