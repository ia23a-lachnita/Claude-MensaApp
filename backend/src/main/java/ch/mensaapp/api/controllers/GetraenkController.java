package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.payload.request.GetraenkRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.GetraenkService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/getraenke")
public class GetraenkController {
    @Autowired
    private GetraenkService getraenkService;

    @GetMapping
    public ResponseEntity<List<Getraenk>> getAlleGetraenke() {
        return ResponseEntity.ok(getraenkService.getAlleGetraenke());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Getraenk> getGetraenkById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(getraenkService.getGetraenkById(id));
    }

    @GetMapping("/verfuegbar")
    public ResponseEntity<List<Getraenk>> getVerfuegbareGetraenke() {
        return ResponseEntity.ok(getraenkService.getVerfuegbareGetraenke());
    }

    @PostMapping
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> erstelleGetraenk(@Valid @RequestBody GetraenkRequest getraenkRequest) {
        return ResponseEntity.ok(getraenkService.erstelleGetraenk(getraenkRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> aktualisiereGetraenk(@PathVariable("id") Long id, @Valid @RequestBody GetraenkRequest getraenkRequest) {
        return ResponseEntity.ok(getraenkService.aktualisiereGetraenk(id, getraenkRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MessageResponse> loescheGetraenk(@PathVariable("id") Long id) {
        getraenkService.loescheGetraenk(id);
        return ResponseEntity.ok(new MessageResponse("Getränk erfolgreich gelöscht"));
    }

    @PutMapping("/{id}/vorrat")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> aktualisiereVorrat(@PathVariable("id") Long id, @RequestParam Integer vorrat) {
        return ResponseEntity.ok(getraenkService.aktualisiereVorrat(id, vorrat));
    }
}
