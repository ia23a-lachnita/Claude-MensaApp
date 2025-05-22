package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.BestellPosition;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class BestellPositionResponse {
    private Long id;
    private Long gerichtId;
    private String gerichtName;
    private Integer anzahl;
    private BigDecimal einzelPreis;
    private BigDecimal gesamtPreis;

    public static BestellPositionResponse fromEntity(BestellPosition position) {
        BestellPositionResponse response = new BestellPositionResponse();
        response.setId(position.getId());
        response.setGerichtId(position.getGericht().getId());
        response.setGerichtName(position.getGericht().getName());
        response.setAnzahl(position.getAnzahl());
        response.setEinzelPreis(position.getEinzelPreis());
        response.setGesamtPreis(position.getEinzelPreis().multiply(BigDecimal.valueOf(position.getAnzahl())));
        return response;
    }
}
