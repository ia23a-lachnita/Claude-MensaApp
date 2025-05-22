package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import ch.mensaapp.api.models.ZahlungsStatus;
import ch.mensaapp.api.payload.request.ZahlungRequest;
import ch.mensaapp.api.payload.response.ZahlungResponse;
import ch.mensaapp.api.repositories.BestellungRepository;
import ch.mensaapp.api.repositories.ZahlungRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class ZahlungService {
    @Autowired
    private ZahlungRepository zahlungRepository;

    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public ZahlungResponse verarbeiteZahlung(Long bestellungId, ZahlungRequest zahlungRequest, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(bestellungId)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        // Prüfen, ob die Bestellung bereits bezahlt ist
        if (bestellung.getZahlungsStatus() == ZahlungsStatus.BEZAHLT) {
            throw new RuntimeException("Diese Bestellung wurde bereits bezahlt");
        }

        // Prüfen, ob der Betrag korrekt ist
        if (zahlungRequest.getBetrag().compareTo(bestellung.getGesamtPreis()) != 0) {
            throw new RuntimeException("Der Zahlungsbetrag stimmt nicht mit dem Bestellungsbetrag überein");
        }

        // Zahlung speichern
        Zahlung zahlung = new Zahlung();
        zahlung.setBestellung(bestellung);
        zahlung.setBetrag(zahlungRequest.getBetrag());
        zahlung.setZeitpunkt(LocalDateTime.now());
        zahlung.setZahlungsMethode(zahlungRequest.getZahlungsMethode());
        
        // In einer realen Anwendung würde hier die Zahlungsabwicklung mit einem echten Zahlungsanbieter erfolgen
        // Hier simulieren wir einen erfolgreichen Zahlungsvorgang
        String transaktionsId = UUID.randomUUID().toString();
        zahlung.setTransaktionsId(transaktionsId);
        zahlung.setErfolgreich(true);
        
        // Bestellung aktualisieren
        bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
        bestellung.setZahlungsReferenz(transaktionsId);
        bestellungRepository.save(bestellung);
        
        Zahlung gespeicherteZahlung = zahlungRepository.save(zahlung);
        
        // E-Mail mit Zahlungsbestätigung senden
        emailService.sendeZahlungsBestaetigung(bestellung);
        
        return ZahlungResponse.fromEntity(gespeicherteZahlung);
    }

    public ZahlungResponse getZahlungByBestellungId(Long bestellungId, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(bestellungId)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        Zahlung zahlung = zahlungRepository.findByBestellung(bestellung)
                .orElseThrow(() -> new RuntimeException("Keine Zahlung für diese Bestellung gefunden"));

        return ZahlungResponse.fromEntity(zahlung);
    }

    @Transactional
    public void verarbeiteZahlungsWebhook(String payload) {
        // In einer realen Anwendung würde hier die Verarbeitung von Webhook-Payloads von Zahlungsanbietern erfolgen
        // Hier gibt es nur eine einfache Implementierung
        
        try {
            // Beispiel für einen einfachen Webhook-Payload: "transaction_id:XXXX,status:success"
            String[] parts = payload.split(",");
            String transactionId = parts[0].split(":")[1];
            String status = parts[1].split(":")[1];

            Zahlung zahlung = zahlungRepository.findByTransaktionsId(transactionId)
                    .orElseThrow(() -> new RuntimeException("Keine Zahlung mit dieser Transaktions-ID gefunden"));

            if ("success".equals(status)) {
                if (!zahlung.isErfolgreich()) {
                    zahlung.setErfolgreich(true);
                    
                    Bestellung bestellung = zahlung.getBestellung();
                    bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
                    bestellungRepository.save(bestellung);
                    
                    zahlungRepository.save(zahlung);
                    
                    // E-Mail senden
                    emailService.sendeZahlungsBestaetigung(bestellung);
                }
            } else if ("failed".equals(status)) {
                zahlung.setErfolgreich(false);
                zahlung.setFehlerMeldung("Zahlung fehlgeschlagen laut Webhook");
                
                Bestellung bestellung = zahlung.getBestellung();
                bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);
                bestellungRepository.save(bestellung);
                
                zahlungRepository.save(zahlung);
            }
        } catch (Exception e) {
            throw new RuntimeException("Fehler bei der Verarbeitung des Webhooks: " + e.getMessage());
        }
    }
}
