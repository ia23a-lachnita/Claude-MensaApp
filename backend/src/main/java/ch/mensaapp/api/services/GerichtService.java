package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.repositories.GerichtRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GerichtService {
    @Autowired
    private GerichtRepository gerichtRepository;

    public List<Gericht> getAlleGerichte() {
        return gerichtRepository.findAll();
    }

    public Gericht getGerichtById(Long id) {
        return gerichtRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden"));
    }

    @Transactional
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
    public void loescheGericht(Long id) {
        Gericht gericht = getGerichtById(id);
        gerichtRepository.delete(gericht);
    }
}
