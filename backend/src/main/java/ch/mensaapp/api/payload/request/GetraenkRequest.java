package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class GetraenkRequest {
    @NotBlank
    private String name;

    @NotNull
    @Positive
    private BigDecimal preis;

    @NotNull
    @Min(0)
    private Integer vorrat;

    private String beschreibung;

    private String bildUrl;

    private boolean verfuegbar = true;
}
