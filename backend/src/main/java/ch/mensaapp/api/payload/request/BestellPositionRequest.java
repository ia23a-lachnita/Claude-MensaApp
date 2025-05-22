package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BestellPositionRequest {
    @NotNull
    private Long gerichtId;

    @NotNull
    @Min(1)
    private Integer anzahl;
}
