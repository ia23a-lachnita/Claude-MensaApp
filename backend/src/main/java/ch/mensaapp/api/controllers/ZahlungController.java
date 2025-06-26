package ch.mensaapp.api.controllers;

import ch.mensaapp.api.payload.request.ZahlungRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.payload.response.ZahlungResponse;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.ZahlungService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/zahlungen")
public class ZahlungController {
    @Autowired
    private ZahlungService zahlungService;

    @PostMapping("/{bestellungId}")
    public ResponseEntity<?> processZahlung(@PathVariable("bestellungId") Long bestellungId, 
                                           @Valid @RequestBody ZahlungRequest zahlungRequest,
                                           @AuthenticationPrincipal UserDetailsImpl userDetails) {
        ZahlungResponse zahlungResponse = zahlungService.verarbeiteZahlung(bestellungId, zahlungRequest, userDetails.getId());
        return ResponseEntity.ok(zahlungResponse);
    }

    @GetMapping("/{bestellungId}")
    public ResponseEntity<?> getZahlungStatus(@PathVariable("bestellungId") Long bestellungId, 
                                             @AuthenticationPrincipal UserDetailsImpl userDetails) {
        ZahlungResponse zahlungResponse = zahlungService.getZahlungByBestellungId(bestellungId, userDetails.getId());
        return ResponseEntity.ok(zahlungResponse);
    }

    @PostMapping("/webhook")
    public ResponseEntity<MessageResponse> zahlungWebhook(@RequestBody String payload) {
        // Diese Methode würde in einer realen Anwendung von Zahlungsanbietern für Webhooks verwendet
        zahlungService.verarbeiteZahlungsWebhook(payload);
        return ResponseEntity.ok(new MessageResponse("Webhook verarbeitet"));
    }
}
