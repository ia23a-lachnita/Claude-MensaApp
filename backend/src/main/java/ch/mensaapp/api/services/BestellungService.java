package ch.mensaapp.api.services;

import ch.mensaapp.api.models.*;
import ch.mensaapp.api.payload.request.BestellPositionRequest;
import ch.mensaapp.api.payload.request.BestellungRequest;
import ch.mensaapp.api.payload.response.BestellungResponse;
import ch.mensaapp.api.payload.response.BestellungValidationResponse;
import ch.mensaapp.api.repositories.BestellungRepository;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class BestellungService {
    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired 
    private GerichtRepository gerichtRepository;

    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtService gerichtService;

    public List<BestellungResponse> getAlleBestellungen() {
        return bestellungRepository.findAll().stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<BestellungResponse> getBestellungenByUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));
        
        return bestellungRepository.findByUser(user).stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<BestellungResponse> getBestellungenByAbholDatum(LocalDate abholDatum) {
        return bestellungRepository.findByAbholDatum(abholDatum).stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public BestellungResponse getBestellungById(Long id) {
        return BestellungResponse.fromEntity(bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden")));
    }

    @Transactional
    public BestellungResponse erstelleBestellung(BestellungRequest bestellungRequest, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        // Validation 1: Check if pickup date is not in the past
        LocalDate abholDatum = bestellungRequest.getAbholDatum();
        if (abholDatum.isBefore(LocalDate.now())) {
            throw new RuntimeException("Das Abholdatum kann nicht in der Vergangenheit liegen");
        }

        // Validation 2: Check if pickup time has not passed for today
        if (abholDatum.equals(LocalDate.now())) {
            LocalTime abholZeit = bestellungRequest.getAbholZeit();
            LocalTime currentTime = LocalTime.now();
            // Allow ordering until 30 minutes before pickup
            if (abholZeit.isBefore(currentTime.plusMinutes(30))) {
                throw new RuntimeException("Bestellungen sind nur bis 30 Minuten vor der Abholzeit möglich");
            }
        }

        // Validation 3: Check if menuplan exists for the pickup date
        Menuplan menuplan = menuplanRepository.findByDatum(abholDatum)
                .orElseThrow(() -> new RuntimeException("Für das gewählte Datum ist kein Menüplan verfügbar"));

        // Validation 4: Validate and filter positions
        if (bestellungRequest.getPositionen() == null || bestellungRequest.getPositionen().isEmpty()) {
            throw new RuntimeException("Bestellung muss mindestens ein Gericht enthalten");
        }

        List<BestellPositionRequest> validPositionen = bestellungRequest.getPositionen().stream()
                .filter(pos -> pos != null && pos.getGerichtId() != null && pos.getAnzahl() != null && pos.getAnzahl() > 0)
                .collect(Collectors.toList());

        if (validPositionen.isEmpty()) {
            throw new RuntimeException("Keine gültigen Gerichte in der Bestellung gefunden. Bitte überprüfen Sie Ihre Auswahl.");
        }

        // Log filtered out items for debugging
        int filteredCount = bestellungRequest.getPositionen().size() - validPositionen.size();
        if (filteredCount > 0) {
            System.out.println("Warnung: " + filteredCount + " ungültige Position(en) aus der Bestellung entfernt");
        }

        Set<Long> verfuegbareGerichtIds = menuplan.getGerichte().stream()
                .map(Gericht::getId)
                .collect(Collectors.toSet());

        for (BestellPositionRequest positionRequest : validPositionen) {
            if (!verfuegbareGerichtIds.contains(positionRequest.getGerichtId())) {
                throw new RuntimeException("Das Gericht mit ID " + positionRequest.getGerichtId() + 
                    " ist am " + abholDatum + " nicht verfügbar");
            }
        }

        Bestellung bestellung = new Bestellung();
        bestellung.setUser(user);
        bestellung.setAbholDatum(abholDatum);
        bestellung.setAbholZeit(bestellungRequest.getAbholZeit());
        bestellung.setBestellDatum(LocalDate.now());
        bestellung.setBemerkungen(bestellungRequest.getBemerkungen());
        bestellung.setStatus(BestellStatus.NEU);
        bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);

        List<BestellPosition> positionen = new ArrayList<>();
        BigDecimal gesamtPreis = BigDecimal.ZERO;

        for (BestellPositionRequest positionRequest : validPositionen) {
            Gericht gericht = gerichtRepository.findById(positionRequest.getGerichtId())
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + positionRequest.getGerichtId()));

            BestellPosition position = new BestellPosition();
            position.setBestellung(bestellung);
            position.setGericht(gericht);
            position.setAnzahl(positionRequest.getAnzahl());
            position.setEinzelPreis(gericht.getPreis());

            positionen.add(position);
            
            // Gesamtpreis berechnen
            BigDecimal positionPreis = gericht.getPreis().multiply(new BigDecimal(positionRequest.getAnzahl()));
            gesamtPreis = gesamtPreis.add(positionPreis);
        }

        bestellung.setPositionen(positionen);
        bestellung.setGesamtPreis(gesamtPreis);

        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }

    @Transactional
    public BestellungValidationResponse erstelleBestellungMitValidation(BestellungRequest bestellungRequest, Long userId) {
        BestellungValidationResponse response = new BestellungValidationResponse();
        
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

            LocalDate abholDatum = bestellungRequest.getAbholDatum();
            
            // Basic validations
            if (abholDatum.isBefore(LocalDate.now())) {
                response.setErfolgreich(false);
                response.setNachricht("Das Abholdatum kann nicht in der Vergangenheit liegen");
                return response;
            }

            if (abholDatum.equals(LocalDate.now())) {
                LocalTime abholZeit = bestellungRequest.getAbholZeit();
                LocalTime currentTime = LocalTime.now();
                if (abholZeit.isBefore(currentTime.plusMinutes(30))) {
                    response.setErfolgreich(false);
                    response.setNachricht("Bestellungen sind nur bis 30 Minuten vor der Abholzeit möglich");
                    return response;
                }
            }

            // Check if menuplan exists
            Menuplan menuplan = menuplanRepository.findByDatum(abholDatum).orElse(null);
            if (menuplan == null) {
                response.setErfolgreich(false);
                response.setNachricht("Für das gewählte Datum ist kein Menüplan verfügbar");
                
                // Suggest alternative dates
                List<LocalDate> verfuegbareDaten = menuplanRepository.findAll().stream()
                        .filter(mp -> !mp.getDatum().isBefore(LocalDate.now()))
                        .map(Menuplan::getDatum)
                        .sorted()
                        .collect(Collectors.toList());
                response.setMoeglicheDaten(verfuegbareDaten);
                if (!verfuegbareDaten.isEmpty()) {
                    response.setEmpfohlenesDatum(verfuegbareDaten.get(0));
                }
                return response;
            }

            // Filter valid positions
            List<BestellPositionRequest> validPositionen = bestellungRequest.getPositionen().stream()
                    .filter(pos -> pos != null && pos.getGerichtId() != null && pos.getAnzahl() != null && pos.getAnzahl() > 0)
                    .collect(Collectors.toList());

            if (validPositionen.isEmpty()) {
                response.setErfolgreich(false);
                response.setNachricht("Keine gültigen Gerichte in der Bestellung gefunden");
                return response;
            }

            // Check dish availability and collect unavailable products
            Set<Long> verfuegbareGerichtIds = menuplan.getGerichte().stream()
                    .map(Gericht::getId)
                    .collect(Collectors.toSet());

            List<BestellungValidationResponse.UnavailableProduct> unavailableProducts = new ArrayList<>();

            for (BestellPositionRequest positionRequest : validPositionen) {
                if (!verfuegbareGerichtIds.contains(positionRequest.getGerichtId())) {
                    Gericht gericht = gerichtRepository.findById(positionRequest.getGerichtId()).orElse(null);
                    if (gericht != null) {
                        List<LocalDate> verfuegbareDaten = gerichtService.getVerfuegbareDatenFuerGericht(positionRequest.getGerichtId());
                        unavailableProducts.add(BestellungValidationResponse.UnavailableProduct.create(
                                gericht.getId(), gericht.getName(), abholDatum, verfuegbareDaten));
                    }
                }
            }

            if (!unavailableProducts.isEmpty()) {
                response.setErfolgreich(false);
                response.setNichtverfuegbareProdukte(unavailableProducts);
                response.setNachricht("Einige Gerichte sind am gewählten Datum nicht verfügbar. Siehe Details unten.");
                
                // Find best alternative date
                Set<LocalDate> allAlternatives = unavailableProducts.stream()
                        .flatMap(p -> p.getVerfuegbareDaten().stream())
                        .collect(Collectors.toSet());
                
                List<LocalDate> sortedAlternatives = allAlternatives.stream().sorted().collect(Collectors.toList());
                response.setMoeglicheDaten(sortedAlternatives);
                if (!sortedAlternatives.isEmpty()) {
                    response.setEmpfohlenesDatum(sortedAlternatives.get(0));
                }
                
                return response;
            }

            // All validations passed, create the order
            BestellungResponse bestellung = erstelleBestellung(bestellungRequest, userId);
            response.setErfolgreich(true);
            response.setBestellung(bestellung);
            response.setNachricht("Bestellung erfolgreich erstellt");

        } catch (Exception e) {
            response.setErfolgreich(false);
            response.setNachricht("Fehler beim Erstellen der Bestellung: " + e.getMessage());
        }

        return response;
    }

    @Transactional
    public BestellungResponse storniereBestellung(Long id, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        // Prüfen, ob die Bestellung bereits in Zubereitung ist
        if (bestellung.getStatus() != BestellStatus.NEU) {
            throw new RuntimeException("Bestellung kann nicht mehr storniert werden");
        }

        bestellung.setStatus(BestellStatus.STORNIERT);
        bestellung.setZahlungsStatus(ZahlungsStatus.STORNIERT);

        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }

    @Transactional
    public BestellungResponse updateBestellungStatus(Long id, BestellStatus status) {
        Bestellung bestellung = bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        bestellung.setStatus(status);
        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }
}
