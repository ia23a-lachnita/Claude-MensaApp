package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.payload.response.GerichtMitDatenResponse;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.GerichtService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/gerichte")
public class GerichtController {
    @Autowired
    private GerichtService gerichtService;

    @GetMapping
    public ResponseEntity<List<Gericht>> getAlleGerichte() {
        return ResponseEntity.ok(gerichtService.getAlleGerichte());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Gericht> getGerichtById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(gerichtService.getGerichtById(id));
    }

    @GetMapping("/verfuegbar/{datum}")
    public ResponseEntity<List<Gericht>> getGerichteFuerDatum(
            @PathVariable("datum") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(gerichtService.getGerichteFuerDatum(datum));
    }

    @GetMapping("/{id}/verfuegbare-daten")
    public ResponseEntity<List<LocalDate>> getVerfuegbareDatenFuerGericht(@PathVariable("id") Long id) {
        return ResponseEntity.ok(gerichtService.getVerfuegbareDatenFuerGericht(id));
    }

    @GetMapping("/{id}/mit-alternativen")
    public ResponseEntity<GerichtMitDatenResponse> getGerichtMitAlternativen(
            @PathVariable("id") Long id,
            @RequestParam(value = "urspruenglichesDatum", required = false) 
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate urspruenglichesDatum) {
        return ResponseEntity.ok(gerichtService.getGerichtMitAlternativen(id, urspruenglichesDatum));
    }

    @PostMapping
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<Gericht> erstelleGericht(@Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.erstelleGericht(gerichtRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<Gericht> aktualisiereGericht(@PathVariable("id") Long id, @Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.aktualisiereGericht(id, gerichtRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<MessageResponse> loescheGericht(@PathVariable("id") Long id) {
        gerichtService.loescheGericht(id);
        return ResponseEntity.ok(new MessageResponse("Gericht erfolgreich gelöscht"));
    }
}
