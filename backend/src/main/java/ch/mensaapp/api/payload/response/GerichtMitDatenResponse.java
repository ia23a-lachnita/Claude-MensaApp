package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Gericht;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class GerichtMitDatenResponse {
    private Gericht gericht;
    private List<LocalDate> verfuegbareDaten;
    private LocalDate urspruenglichesDatum; // Original date when added to basket

    public static GerichtMitDatenResponse fromGericht(Gericht gericht, List<LocalDate> verfuegbareDaten, LocalDate urspruenglichesDatum) {
        GerichtMitDatenResponse response = new GerichtMitDatenResponse();
        response.setGericht(gericht);
        response.setVerfuegbareDaten(verfuegbareDaten);
        response.setUrspruenglichesDatum(urspruenglichesDatum);
        return response;
    }
}