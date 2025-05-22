package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.payload.request.GetraenkRequest;
import ch.mensaapp.api.repositories.GetraenkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GetraenkService {
    @Autowired
    private GetraenkRepository getraenkRepository;

    public List<Getraenk> getAlleGetraenke() {
        return getraenkRepository.findAll();
    }

    public Getraenk getGetraenkById(Long id) {
        return getraenkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Getränk nicht gefunden"));
    }

    public List<Getraenk> getVerfuegbareGetraenke() {
        return getraenkRepository.findByVerfuegbar(true);
    }

    @Transactional
    public Getraenk erstelleGetraenk(GetraenkRequest getraenkRequest) {
        Getraenk getraenk = new Getraenk();
        getraenk.setName(getraenkRequest.getName());
        getraenk.setPreis(getraenkRequest.getPreis());
        getraenk.setVorrat(getraenkRequest.getVorrat());
        getraenk.setBeschreibung(getraenkRequest.getBeschreibung());
        getraenk.setBildUrl(getraenkRequest.getBildUrl());
        getraenk.setVerfuegbar(getraenkRequest.isVerfuegbar());

        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public Getraenk aktualisiereGetraenk(Long id, GetraenkRequest getraenkRequest) {
        Getraenk getraenk = getGetraenkById(id);

        getraenk.setName(getraenkRequest.getName());
        getraenk.setPreis(getraenkRequest.getPreis());
        getraenk.setVorrat(getraenkRequest.getVorrat());
        getraenk.setBeschreibung(getraenkRequest.getBeschreibung());
        getraenk.setBildUrl(getraenkRequest.getBildUrl());
        getraenk.setVerfuegbar(getraenkRequest.isVerfuegbar());

        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public Getraenk aktualisiereVorrat(Long id, Integer vorrat) {
        Getraenk getraenk = getGetraenkById(id);
        getraenk.setVorrat(vorrat);
        
        if (vorrat <= 0) {
            getraenk.setVerfuegbar(false);
        }
        
        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public void loescheGetraenk(Long id) {
        Getraenk getraenk = getGetraenkById(id);
        getraenkRepository.delete(getraenk);
    }
}
