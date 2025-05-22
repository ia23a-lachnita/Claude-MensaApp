package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.GerichtService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

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
    public ResponseEntity<Gericht> getGerichtById(@PathVariable Long id) {
        return ResponseEntity.ok(gerichtService.getGerichtById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Gericht> erstelleGericht(@Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.erstelleGericht(gerichtRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Gericht> aktualisiereGericht(@PathVariable Long id, @Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.aktualisiereGericht(id, gerichtRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MessageResponse> loescheGericht(@PathVariable Long id) {
        gerichtService.loescheGericht(id);
        return ResponseEntity.ok(new MessageResponse("Gericht erfolgreich gelöscht"));
    }
}
