package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Gericht;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

@Data
public class GerichtResponse {
    private Long id;
    private String name;
    private String beschreibung;
    private BigDecimal preis;
    private boolean vegetarisch;
    private boolean vegan;
    private Set<String> zutaten;
    private Set<String> allergene;
    private String bildUrl;

    public static GerichtResponse fromEntity(Gericht gericht) {
        GerichtResponse response = new GerichtResponse();
        response.setId(gericht.getId());
        response.setName(gericht.getName());
        response.setBeschreibung(gericht.getBeschreibung());
        response.setPreis(gericht.getPreis());
        response.setVegetarisch(gericht.isVegetarisch());
        response.setVegan(gericht.isVegan());
        response.setZutaten(gericht.getZutaten());
        response.setAllergene(gericht.getAllergene());
        response.setBildUrl(gericht.getBildUrl());
        return response;
    }
}
