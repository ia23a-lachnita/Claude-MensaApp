package ch.mensaapp.api.payload.request;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class BasketValidationRequest {
    private List<BasketItemRequest> items;
    private List<BasketDrinkRequest> drinks;
    private LocalDate gewuenschtesAbholDatum;

    @Data
    public static class BasketItemRequest {
        private Long gerichtId;
        private Integer anzahl;
        private LocalDate urspruenglichesDatum; // The date when this item was originally added from a menuplan
    }
    
    @Data
    public static class BasketDrinkRequest {
        private Long getraenkId;
        private Integer anzahl;
        private LocalDate urspruenglichesDatum; // The date when this drink was originally added from a menuplan
    }
}