package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

@Data
public class GerichtRequest {
    @NotBlank
    private String name;

    @NotBlank
    private String beschreibung;

    @NotNull
    @Positive
    private BigDecimal preis;

    private boolean vegetarisch;

    private boolean vegan;

    private Set<String> zutaten;

    @NotEmpty
    private Set<String> allergene;

    private String bildUrl;
}
