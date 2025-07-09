package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.payload.response.GerichtMitDatenResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class GerichtService {
    @Autowired
    private GerichtRepository gerichtRepository;

    @Autowired
    private MenuplanRepository menuplanRepository;

    @Cacheable("gerichte")
    public List<Gericht> getAlleGerichte() {
        return gerichtRepository.findAll();
    }

    public Gericht getGerichtById(Long id) {
        return gerichtRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden"));
    }

    @Cacheable(value = "gerichte", key = "#datum")
    public List<Gericht> getGerichteFuerDatum(LocalDate datum) {
        return menuplanRepository.findByDatum(datum)
                .map(menuplan -> List.copyOf(menuplan.getGerichte()))
                .orElse(Collections.emptyList());
    }

    @Cacheable(value = "gerichte", key = "'available_dates_' + #gerichtId")
    public List<LocalDate> getVerfuegbareDatenFuerGericht(Long gerichtId) {
        // Verify the dish exists
        getGerichtById(gerichtId);
        
        // Find all menuplans that contain this dish and are not in the past
        // Optimized query instead of loading all menuplans
        return menuplanRepository.findMenuplanDatesForGericht(gerichtId, LocalDate.now());
    }

    public GerichtMitDatenResponse getGerichtMitAlternativen(Long gerichtId, LocalDate urspruenglichesDatum) {
        Gericht gericht = getGerichtById(gerichtId);
        List<LocalDate> verfuegbareDaten = getVerfuegbareDatenFuerGericht(gerichtId);
        
        return GerichtMitDatenResponse.fromGericht(gericht, verfuegbareDaten, urspruenglichesDatum);
    }

    @Transactional
    @CacheEvict(value = {"gerichte", "menuplan"}, allEntries = true)
    public Gericht erstelleGericht(GerichtRequest gerichtRequest) {
        Gericht gericht = new Gericht();
        gericht.setName(gerichtRequest.getName());
        gericht.setBeschreibung(gerichtRequest.getBeschreibung());
        gericht.setPreis(gerichtRequest.getPreis());
        gericht.setVegetarisch(gerichtRequest.isVegetarisch());
        gericht.setVegan(gerichtRequest.isVegan());
        gericht.setZutaten(gerichtRequest.getZutaten());
        gericht.setAllergene(gerichtRequest.getAllergene());
        gericht.setBildUrl(gerichtRequest.getBildUrl());

        return gerichtRepository.save(gericht);
    }

    @Transactional
    @CacheEvict(value = {"gerichte", "menuplan"}, allEntries = true)
    public Gericht aktualisiereGericht(Long id, GerichtRequest gerichtRequest) {
        Gericht gericht = getGerichtById(id);

        gericht.setName(gerichtRequest.getName());
        gericht.setBeschreibung(gerichtRequest.getBeschreibung());
        gericht.setPreis(gerichtRequest.getPreis());
        gericht.setVegetarisch(gerichtRequest.isVegetarisch());
        gericht.setVegan(gerichtRequest.isVegan());
        gericht.setZutaten(gerichtRequest.getZutaten());
        gericht.setAllergene(gerichtRequest.getAllergene());
        gericht.setBildUrl(gerichtRequest.getBildUrl());

        return gerichtRepository.save(gericht);
    }

    @Transactional
    @CacheEvict(value = {"gerichte", "menuplan"}, allEntries = true)
    public void loescheGericht(Long id) {
        Gericht gericht = getGerichtById(id);
        gerichtRepository.delete(gericht);
    }
}
