package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.models.Menuplan;
import lombok.Data;

import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;

@Data
public class MenuplanResponse {
    private Long id;
    private LocalDate datum;
    private Set<GerichtResponse> gerichte;
    private Set<GetraenkResponse> getraenke; // ADDED: Drinks

    public static MenuplanResponse fromEntity(Menuplan menuplan) {
        MenuplanResponse response = new MenuplanResponse();
        response.setId(menuplan.getId());
        response.setDatum(menuplan.getDatum());
        response.setGerichte(menuplan.getGerichte().stream()
                .map(GerichtResponse::fromEntity)
                .collect(Collectors.toSet()));

        // ADDED: Convert drinks if they exist
        if (menuplan.getGetraenke() != null) {
            response.setGetraenke(menuplan.getGetraenke().stream()
                    .map(GetraenkResponse::fromEntity)
                    .collect(Collectors.toSet()));
        }

        return response;
    }
}
