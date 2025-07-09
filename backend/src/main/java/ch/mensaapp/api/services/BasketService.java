package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.request.BasketValidationRequest;
import ch.mensaapp.api.payload.response.BasketValidationResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.GetraenkRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class BasketService {

    @Autowired
    private GerichtRepository gerichtRepository;

    @Autowired
    private GetraenkRepository getraenkRepository;

    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtService gerichtService;

    @Autowired
    private GetraenkService getraenkService;

    public BasketValidationResponse validateBasket(BasketValidationRequest request) {
        BasketValidationResponse response = new BasketValidationResponse();
        List<BasketValidationResponse.BasketItemValidation> itemValidations = new ArrayList<>();

        // Get all available dates for all items
        Set<LocalDate> allMoeglicheDaten = new HashSet<>();
        boolean allItemsValid = true;

        // Validate dishes
        if (request.getItems() != null) {
            for (BasketValidationRequest.BasketItemRequest item : request.getItems()) {
                if (item.getGerichtId() == null) continue; // Skip null items

                BasketValidationResponse.BasketItemValidation validation = new BasketValidationResponse.BasketItemValidation();

                try {
                    Gericht gericht = gerichtRepository.findById(item.getGerichtId())
                            .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden"));

                    validation.setGerichtId(item.getGerichtId());
                    validation.setGerichtName(gericht.getName());
                    validation.setUrspruenglichesDatum(item.getUrspruenglichesDatum());

                    List<LocalDate> verfuegbareDaten = gerichtService.getVerfuegbareDatenFuerGericht(item.getGerichtId());
                    validation.setAlternativeDaten(verfuegbareDaten);
                    allMoeglicheDaten.addAll(verfuegbareDaten);

                    // Check if available on requested date
                    if (request.getGewuenschtesAbholDatum() != null) {
                        boolean verfuegbar = verfuegbareDaten.contains(request.getGewuenschtesAbholDatum());
                        validation.setVerfuegbarAmGewuenschtenDatum(verfuegbar);
                        if (!verfuegbar) {
                            allItemsValid = false;
                        }
                    } else {
                        validation.setVerfuegbarAmGewuenschtenDatum(false);
                    }

                } catch (Exception e) {
                    validation.setVerfuegbarAmGewuenschtenDatum(false);
                    allItemsValid = false;
                }

                itemValidations.add(validation);
            }
        }

        // Validate drinks - drinks are generally always available, but we check if they exist and are in stock
        if (request.getDrinks() != null) {
            for (BasketValidationRequest.BasketDrinkRequest drink : request.getDrinks()) {
                if (drink.getGetraenkId() == null) continue; // Skip null items

                BasketValidationResponse.BasketItemValidation validation = new BasketValidationResponse.BasketItemValidation();

                try {
                    Getraenk getraenk = getraenkRepository.findById(drink.getGetraenkId())
                            .orElseThrow(() -> new RuntimeException("Getränk nicht gefunden"));

                    validation.setGerichtId(drink.getGetraenkId()); // Reuse gerichtId field for drinks
                    validation.setGerichtName(getraenk.getName());
                    validation.setUrspruenglichesDatum(drink.getUrspruenglichesDatum());

                    // Drinks are available on all days (no date restrictions)
                    List<LocalDate> verfuegbareDaten = List.of(LocalDate.now(), LocalDate.now().plusDays(1), LocalDate.now().plusDays(2), LocalDate.now().plusDays(3), LocalDate.now().plusDays(4), LocalDate.now().plusDays(5), LocalDate.now().plusDays(6));
                    validation.setAlternativeDaten(verfuegbareDaten);
                    allMoeglicheDaten.addAll(verfuegbareDaten);

                    // Check if drink is available (in stock and verfuegbar)
                    boolean verfuegbar = getraenk.isVerfuegbar() && getraenk.getVorrat() > 0;
                    validation.setVerfuegbarAmGewuenschtenDatum(verfuegbar);
                    if (!verfuegbar) {
                        allItemsValid = false;
                    }

                } catch (Exception e) {
                    validation.setVerfuegbarAmGewuenschtenDatum(false);
                    allItemsValid = false;
                }

                itemValidations.add(validation);
            }
        }

        response.setItemValidations(itemValidations);
        response.setMoeglicheDaten(allMoeglicheDaten.stream().sorted().collect(Collectors.toList()));

        // Find the best recommended date
        LocalDate empfohlenesDatum = findBestRecommendedDate(request, allMoeglicheDaten, itemValidations);
        response.setEmpfohlenesDatum(empfohlenesDatum);

        // Check for conflicting dates (products only available on different dates)
        Map<LocalDate, List<String>> dateToProducts = analyzeProductDateConflicts(itemValidations);
        boolean hasConflicts = dateToProducts.size() > 1;
        
        response.setHasConflictingDates(hasConflicts);
        if (hasConflicts) {
            List<BasketValidationResponse.DateConflict> conflicts = dateToProducts.entrySet().stream()
                    .map(entry -> BasketValidationResponse.DateConflict.create(entry.getKey(), entry.getValue()))
                    .collect(Collectors.toList());
            response.setDateConflicts(conflicts);
        }

        // Set overall validation result
        if (request.getGewuenschtesAbholDatum() != null) {
            response.setValid(allItemsValid && !hasConflicts);
            if (hasConflicts) {
                response.setMessage("Ihre Produkte sind nur an verschiedenen Tagen verfügbar. Bitte wählen Sie ein Datum oder entfernen Sie Produkte.");
            } else if (allItemsValid) {
                response.setMessage("Alle Gerichte sind am gewünschten Datum verfügbar.");
            } else {
                response.setMessage("Nicht alle Gerichte sind am gewünschten Datum verfügbar. Siehe Alternativen.");
            }
        } else {
            response.setValid(false);
            if (hasConflicts) {
                response.setMessage("Ihre Produkte sind nur an verschiedenen Tagen verfügbar. Bitte wählen Sie Produkte für ein einziges Datum.");
            } else {
                response.setMessage("Bitte wählen Sie ein Abholdatum.");
            }
        }

        return response;
    }

    private LocalDate findBestRecommendedDate(BasketValidationRequest request, Set<LocalDate> allMoeglicheDaten,
            List<BasketValidationResponse.BasketItemValidation> itemValidations) {

        // If all items are valid for the requested date, recommend that
        if (request.getGewuenschtesAbholDatum() != null &&
            itemValidations.stream().allMatch(BasketValidationResponse.BasketItemValidation::isVerfuegbarAmGewuenschtenDatum)) {
            return request.getGewuenschtesAbholDatum();
        }

        // Find date where most items are available
        Map<LocalDate, Long> dateScores = allMoeglicheDaten.stream()
                .collect(Collectors.toMap(
                    date -> date,
                    date -> itemValidations.stream()
                            .mapToLong(item -> item.getAlternativeDaten().contains(date) ? 1L : 0L)
                            .sum()
                ));

        // Return the earliest date with the highest score
        return dateScores.entrySet().stream()
                .filter(entry -> entry.getValue() == Collections.max(dateScores.values()))
                .map(Map.Entry::getKey)
                .min(LocalDate::compareTo)
                .orElse(LocalDate.now().plusDays(1));
    }

    private Map<LocalDate, List<String>> analyzeProductDateConflicts(List<BasketValidationResponse.BasketItemValidation> itemValidations) {
        Map<LocalDate, List<String>> dateToProducts = new HashMap<>();
        
        for (BasketValidationResponse.BasketItemValidation item : itemValidations) {
            // If product is not available on desired date, check where it's only available
            if (!item.isVerfuegbarAmGewuenschtenDatum() && item.getAlternativeDaten() != null) {
                // For simplicity, use the first available date as the "required" date for this product
                if (!item.getAlternativeDaten().isEmpty()) {
                    LocalDate firstAvailableDate = item.getAlternativeDaten().get(0);
                    dateToProducts.computeIfAbsent(firstAvailableDate, k -> new ArrayList<>())
                            .add(item.getGerichtName());
                }
            }
        }
        
        return dateToProducts;
    }
}
