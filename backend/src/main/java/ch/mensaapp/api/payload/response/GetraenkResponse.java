package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Getraenk;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

@Data
public class GetraenkResponse {
    private Long id;
    private String name;
    private BigDecimal preis;
    private Integer vorrat;
    private String beschreibung;
    private boolean vegetarisch;
    private boolean vegan;
    private Set<String> allergene;
    private String bildUrl;
    private boolean verfuegbar;

    public static GetraenkResponse fromEntity(Getraenk getraenk) {
        GetraenkResponse response = new GetraenkResponse();
        response.setId(getraenk.getId());
        response.setName(getraenk.getName());
        response.setPreis(getraenk.getPreis());
        response.setVorrat(getraenk.getVorrat());
        response.setBeschreibung(getraenk.getBeschreibung());
        response.setVegetarisch(getraenk.isVegetarisch());
        response.setVegan(getraenk.isVegan());
        response.setAllergene(getraenk.getAllergene());
        response.setBildUrl(getraenk.getBildUrl());
        response.setVerfuegbar(getraenk.isVerfuegbar());
        return response;
    }
}
