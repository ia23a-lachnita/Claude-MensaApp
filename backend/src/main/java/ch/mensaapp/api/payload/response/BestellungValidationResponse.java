package ch.mensaapp.api.payload.response;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class BestellungValidationResponse {
    private boolean erfolgreich;
    private String nachricht;
    private BestellungResponse bestellung; // Only set if successful
    private List<UnavailableProduct> nichtverfuegbareProdukte;
    private LocalDate empfohlenesDatum;
    private List<LocalDate> moeglicheDaten;

    @Data
    public static class UnavailableProduct {
        private Long gerichtId;
        private String gerichtName;
        private LocalDate gewuenschtesAbholdatum;
        private List<LocalDate> verfuegbareDaten;
        
        public static UnavailableProduct create(Long gerichtId, String gerichtName, LocalDate gewuenschtesAbholdatum, List<LocalDate> verfuegbareDaten) {
            UnavailableProduct product = new UnavailableProduct();
            product.setGerichtId(gerichtId);
            product.setGerichtName(gerichtName);
            product.setGewuenschtesAbholdatum(gewuenschtesAbholdatum);
            product.setVerfuegbareDaten(verfuegbareDaten);
            return product;
        }
    }
}