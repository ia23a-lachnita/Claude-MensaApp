package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BestellPositionRequest {
    private Long gerichtId; // Allow null, validate in service

    @Min(1)
    private Integer anzahl; // Allow null, validate in service
}
