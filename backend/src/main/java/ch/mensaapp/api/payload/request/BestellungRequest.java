package ch.mensaapp.api.payload.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
public class BestellungRequest {
    @NotNull
    @Future(message = "Das Abholdatum muss in der Zukunft liegen")
    private LocalDate abholDatum;

    @NotNull
    private LocalTime abholZeit;

    @NotEmpty
    private List<@Valid BestellPositionRequest> positionen;

    private String bemerkungen;
}
