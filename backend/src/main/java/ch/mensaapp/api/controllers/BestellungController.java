package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.payload.request.BestellungRequest;
import ch.mensaapp.api.payload.response.BestellungResponse;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.BestellungService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/bestellungen")
public class BestellungController {
    @Autowired
    private BestellungService bestellungService;

    @GetMapping("/meine")
    public ResponseEntity<List<BestellungResponse>> getMyBestellungen(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.getBestellungenByUser(userDetails.getId()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BestellungResponse> getBestellungById(@PathVariable Long id, @AuthenticationPrincipal UserDetailsImpl userDetails) {
        BestellungResponse bestellung = bestellungService.getBestellungById(id);
        
        // Prüfen, ob die Bestellung dem aktuellen Benutzer gehört oder ob der Benutzer Admin/Staff ist
        if (bestellung.getUserId().equals(userDetails.getId()) || 
            userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_STAFF"))) {
            return ResponseEntity.ok(bestellung);
        } else {
            return ResponseEntity.status(403).build();
        }
    }

    @PostMapping
    public ResponseEntity<BestellungResponse> createBestellung(@Valid @RequestBody BestellungRequest bestellungRequest, 
                                                         @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.erstelleBestellung(bestellungRequest, userDetails.getId()));
    }

    @PutMapping("/{id}/stornieren")
    public ResponseEntity<BestellungResponse> storniereBestellung(@PathVariable Long id, @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.storniereBestellung(id, userDetails.getId()));
    }

    @GetMapping("/alle")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<List<BestellungResponse>> getAlleBestellungen() {
        return ResponseEntity.ok(bestellungService.getAlleBestellungen());
    }

    @GetMapping("/datum/{datum}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<List<BestellungResponse>> getBestellungenByDatum(
            @PathVariable("datum") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(bestellungService.getBestellungenByAbholDatum(datum));
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<BestellungResponse> updateBestellungStatus(@PathVariable Long id, @RequestParam BestellStatus status) {
        return ResponseEntity.ok(bestellungService.updateBestellungStatus(id, status));
    }
}
