package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.request.MenuplanRequest;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class MenuplanService {
    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtRepository gerichtRepository;

    @Cacheable("menuplan")
    public List<MenuplanResponse> getAlleMenuplaene() {
        return menuplanRepository.findAllOrderByDatumAsc().stream()
                .map(MenuplanResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public MenuplanResponse getMenuplanById(Long id) {
        return MenuplanResponse.fromEntity(menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden")));
    }

    @Cacheable(value = "menuplan", key = "#datum")
    public MenuplanResponse getMenuplanByDatum(LocalDate datum) {
        return MenuplanResponse.fromEntity(menuplanRepository.findByDatum(datum)
                .orElseThrow(() -> new RuntimeException("Kein Menuplan für dieses Datum verfügbar")));
    }

    @Cacheable(value = "menuplan", key = "'future'")
    public List<MenuplanResponse> getZukuenftigeMenuplaene() {
        return menuplanRepository.findByDatumGreaterThanEqualOrderByDatumAsc(LocalDate.now()).stream()
                .map(MenuplanResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    @CacheEvict(value = "menuplan", allEntries = true)
    public MenuplanResponse erstelleMenuplan(MenuplanRequest menuplanRequest) {
        if (menuplanRepository.findByDatum(menuplanRequest.getDatum()).isPresent()) {
            throw new RuntimeException("Für dieses Datum existiert bereits ein Menuplan");
        }

        Menuplan menuplan = new Menuplan();
        menuplan.setDatum(menuplanRequest.getDatum());

        Set<Gericht> gerichte = new HashSet<>();
        for (Long gerichtId : menuplanRequest.getGerichtIds()) {
            Gericht gericht = gerichtRepository.findById(gerichtId)
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + gerichtId));
            gerichte.add(gericht);
        }
        menuplan.setGerichte(gerichte);

        return MenuplanResponse.fromEntity(menuplanRepository.save(menuplan));
    }

    @Transactional
    @CacheEvict(value = "menuplan", allEntries = true)
    public MenuplanResponse aktualisiereMenuplan(Long id, MenuplanRequest menuplanRequest) {
        Menuplan menuplan = menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden"));

        // Prüfen, ob für das neue Datum bereits ein Menuplan existiert (ausser es ist das gleiche Datum)
        if (!menuplan.getDatum().equals(menuplanRequest.getDatum()) && 
            menuplanRepository.findByDatum(menuplanRequest.getDatum()).isPresent()) {
            throw new RuntimeException("Für dieses Datum existiert bereits ein Menuplan");
        }

        menuplan.setDatum(menuplanRequest.getDatum());

        Set<Gericht> gerichte = new HashSet<>();
        for (Long gerichtId : menuplanRequest.getGerichtIds()) {
            Gericht gericht = gerichtRepository.findById(gerichtId)
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + gerichtId));
            gerichte.add(gericht);
        }
        menuplan.setGerichte(gerichte);

        return MenuplanResponse.fromEntity(menuplanRepository.save(menuplan));
    }

    @Transactional
    @CacheEvict(value = "menuplan", allEntries = true)
    public void loescheMenuplan(Long id) {
        Menuplan menuplan = menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden"));
        menuplanRepository.delete(menuplan);
    }
}
