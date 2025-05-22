package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.Set;

@Data
public class MenuplanRequest {
    @NotNull
    private LocalDate datum;

    @NotNull
    private Set<Long> gerichtIds;
}
