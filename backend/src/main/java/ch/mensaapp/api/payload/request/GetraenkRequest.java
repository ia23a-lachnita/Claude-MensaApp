package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

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

    @NotBlank
    private String beschreibung;

    private boolean vegetarisch = false;

    private boolean vegan = false;

    @NotEmpty
    private Set<String> allergene;

    private String bildUrl;

    private boolean verfuegbar = true;
}
