package ch.mensaapp.api.services;

import ch.mensaapp.api.models.*;
import ch.mensaapp.api.payload.request.BestellPositionRequest;
import ch.mensaapp.api.payload.request.BestellungRequest;
import ch.mensaapp.api.payload.response.BestellungResponse;
import ch.mensaapp.api.repositories.BestellungRepository;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BestellungService {
    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired 
    private GerichtRepository gerichtRepository;

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

        Bestellung bestellung = new Bestellung();
        bestellung.setUser(user);
        bestellung.setAbholDatum(bestellungRequest.getAbholDatum());
        bestellung.setAbholZeit(bestellungRequest.getAbholZeit());
        bestellung.setBestellDatum(LocalDate.now());
        bestellung.setBemerkungen(bestellungRequest.getBemerkungen());
        bestellung.setStatus(BestellStatus.NEU);
        bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);

        List<BestellPosition> positionen = new ArrayList<>();
        BigDecimal gesamtPreis = BigDecimal.ZERO;

        for (BestellPositionRequest positionRequest : bestellungRequest.getPositionen()) {
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
