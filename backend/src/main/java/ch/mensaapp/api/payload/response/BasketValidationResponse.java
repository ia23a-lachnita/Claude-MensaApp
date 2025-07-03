package ch.mensaapp.api.payload.response;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class BasketValidationResponse {
    private boolean valid;
    private LocalDate empfohlenesDatum; // Recommended pickup date
    private List<LocalDate> moeglicheDaten; // All possible dates for all items
    private List<BasketItemValidation> itemValidations;
    private String message;
    private boolean hasConflictingDates; // True if products are from different unavailable dates
    private List<DateConflict> dateConflicts; // Details about conflicting dates

    @Data
    public static class BasketItemValidation {
        private Long gerichtId;
        private String gerichtName;
        private boolean verfuegbarAmGewuenschtenDatum;
        private List<LocalDate> alternativeDaten;
        private LocalDate urspruenglichesDatum;
    }

    @Data
    public static class DateConflict {
        private LocalDate datum;
        private List<String> gerichtNamen; // Products available only on this date
        
        public static DateConflict create(LocalDate datum, List<String> gerichtNamen) {
            DateConflict conflict = new DateConflict();
            conflict.setDatum(datum);
            conflict.setGerichtNamen(gerichtNamen);
            return conflict;
        }
    }
}