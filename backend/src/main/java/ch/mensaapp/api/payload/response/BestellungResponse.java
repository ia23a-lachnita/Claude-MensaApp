package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.models.ZahlungsStatus;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class BestellungResponse {
    private Long id;
    private Long userId;
    private String userEmail;
    private String userName;
    private LocalDate abholDatum;
    private LocalTime abholZeit;
    private LocalDate bestellDatum;
    private List<BestellPositionResponse> positionen;
    private BigDecimal gesamtPreis;
    private BestellStatus status;
    private ZahlungsStatus zahlungsStatus;
    private String zahlungsReferenz;
    private String bemerkungen;

    public static BestellungResponse fromEntity(Bestellung bestellung) {
        BestellungResponse response = new BestellungResponse();
        response.setId(bestellung.getId());
        response.setUserId(bestellung.getUser().getId());
        response.setUserEmail(bestellung.getUser().getEmail());
        response.setUserName(bestellung.getUser().getVorname() + " " + bestellung.getUser().getNachname());
        response.setAbholDatum(bestellung.getAbholDatum());
        response.setAbholZeit(bestellung.getAbholZeit());
        response.setBestellDatum(bestellung.getBestellDatum());
        response.setPositionen(bestellung.getPositionen().stream()
                .map(BestellPositionResponse::fromEntity)
                .collect(Collectors.toList()));
        response.setGesamtPreis(bestellung.getGesamtPreis());
        response.setStatus(bestellung.getStatus());
        response.setZahlungsStatus(bestellung.getZahlungsStatus());
        response.setZahlungsReferenz(bestellung.getZahlungsReferenz());
        response.setBemerkungen(bestellung.getBemerkungen());
        return response;
    }
}
