package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MenuService {
    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtRepository gerichtRepository;

    public MenuplanResponse getMenuplanFuerDatum(LocalDate datum) {
        Menuplan menuplan = menuplanRepository.findByDatum(datum)
                .orElseThrow(() -> new RuntimeException("Kein Menuplan für dieses Datum verfügbar"));
        return MenuplanResponse.fromEntity(menuplan);
    }

    public List<MenuplanResponse> getMenuplanFuerWoche(LocalDate startDatum) {
        LocalDate endDatum = startDatum.plusDays(6);
        List<Menuplan> menuplaene = menuplanRepository.findByDatumBetween(startDatum, endDatum);
        return menuplaene.stream()
                .map(MenuplanResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<Gericht> getAlleGerichte() {
        return gerichtRepository.findAll();
    }

    public List<Gericht> getVegetarischeGerichte() {
        return gerichtRepository.findByVegetarisch(true);
    }

    public List<Gericht> getVeganeGerichte() {
        return gerichtRepository.findByVegan(true);
    }
}
