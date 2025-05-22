package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Getraenk;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class GetraenkResponse {
    private Long id;
    private String name;
    private BigDecimal preis;
    private Integer vorrat;
    private String beschreibung;
    private String bildUrl;
    private boolean verfuegbar;

    public static GetraenkResponse fromEntity(Getraenk getraenk) {
        GetraenkResponse response = new GetraenkResponse();
        response.setId(getraenk.getId());
        response.setName(getraenk.getName());
        response.setPreis(getraenk.getPreis());
        response.setVorrat(getraenk.getVorrat());
        response.setBeschreibung(getraenk.getBeschreibung());
        response.setBildUrl(getraenk.getBildUrl());
        response.setVerfuegbar(getraenk.isVerfuegbar());
        return response;
    }
}
