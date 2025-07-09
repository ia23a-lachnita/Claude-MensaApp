package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import ch.mensaapp.api.models.ZahlungsMethode;
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

        // Zahlungsmethoden-spezifische Validierung
        validatePaymentMethod(zahlungRequest);

        // Zahlung speichern
        Zahlung zahlung = new Zahlung();
        zahlung.setBestellung(bestellung);
        zahlung.setBetrag(zahlungRequest.getBetrag());
        zahlung.setZeitpunkt(LocalDateTime.now());
        zahlung.setZahlungsMethode(zahlungRequest.getZahlungsMethode());
        
        // Zahlungsabwicklung je nach Zahlungsmethode
        String transaktionsId = UUID.randomUUID().toString();
        zahlung.setTransaktionsId(transaktionsId);
        
        boolean paymentSuccess = processPaymentByMethod(zahlungRequest);
        zahlung.setErfolgreich(paymentSuccess);
        
        if (!paymentSuccess) {
            zahlung.setFehlerMeldung("Zahlung fehlgeschlagen");
        }
        
        // Bestellung aktualisieren nur bei erfolgreicher Zahlung
        if (paymentSuccess) {
            bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
            bestellung.setZahlungsReferenz(transaktionsId);
        } else {
            bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);
        }
        bestellungRepository.save(bestellung);
        
        Zahlung gespeicherteZahlung = zahlungRepository.save(zahlung);
        
        // E-Mail mit Zahlungsbestätigung senden nur bei erfolgreicher Zahlung
        if (paymentSuccess) {
            emailService.sendeZahlungsBestaetigung(bestellung);
            System.out.println("Zahlungsbestätigung gesendet für Bestellung ID: " + bestellungId);
        }
        
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

    private void validatePaymentMethod(ZahlungRequest zahlungRequest) {
        ZahlungsMethode methode = zahlungRequest.getZahlungsMethode();
        
        switch (methode) {
            case KREDITKARTE:
            case DEBITKARTE:
                if (zahlungRequest.getKartenNummer() == null || zahlungRequest.getKartenNummer().trim().isEmpty()) {
                    throw new RuntimeException("Kartennummer ist erforderlich für " + methode.getDisplayName());
                }
                if (zahlungRequest.getKartenName() == null || zahlungRequest.getKartenName().trim().isEmpty()) {
                    throw new RuntimeException("Karteninhaber ist erforderlich für " + methode.getDisplayName());
                }
                if (zahlungRequest.getKartenCVV() == null || zahlungRequest.getKartenCVV().trim().isEmpty()) {
                    throw new RuntimeException("CVV ist erforderlich für " + methode.getDisplayName());
                }
                if (zahlungRequest.getKartenAblaufMonat() == null || zahlungRequest.getKartenAblaufJahr() == null) {
                    throw new RuntimeException("Ablaufdatum ist erforderlich für " + methode.getDisplayName());
                }
                break;
            case MOCK_PROVIDER:
                // Mock provider needs no additional validation
                break;
            default:
                throw new RuntimeException("Nicht unterstützte Zahlungsmethode: " + methode);
        }
    }
    
    private boolean processPaymentByMethod(ZahlungRequest zahlungRequest) {
        ZahlungsMethode methode = zahlungRequest.getZahlungsMethode();
        
        switch (methode) {
            case KREDITKARTE:
            case DEBITKARTE:
                // Simuliere Kreditkarten-/Debitkarten-Zahlung
                // In einer realen Anwendung würde hier die Zahlungsabwicklung mit einem echten Zahlungsanbieter erfolgen
                return simulateCardPayment(zahlungRequest);
                
            case MOCK_PROVIDER:
                // Mock provider für Testzwecke
                return simulateMockPayment(zahlungRequest);
                
            default:
                throw new RuntimeException("Nicht unterstützte Zahlungsmethode: " + methode);
        }
    }
    
    private boolean simulateCardPayment(ZahlungRequest zahlungRequest) {
        // Simuliere eine Kreditkartenzahlung
        // In der Realität würde hier eine Verbindung zu einem Zahlungsanbieter hergestellt
        
        // Simuliere einen Fehlschlag bei bestimmten Kartennummern (für Testzwecke)
        String kartenNummer = zahlungRequest.getKartenNummer();
        if (kartenNummer != null && kartenNummer.startsWith("4000")) {
            // Simuliere einen Zahlungsfehlschlag
            return false;
        }
        
        // Ansonsten simuliere eine erfolgreiche Zahlung
        return true;
    }
    
    private boolean simulateMockPayment(ZahlungRequest zahlungRequest) {
        // Mock Provider: Verwende den expliziten Success-Parameter oder simuliere zufällig
        if (zahlungRequest.getMockPaymentSuccess() != null) {
            return zahlungRequest.getMockPaymentSuccess();
        }
        
        // Standardmäßig erfolgreich, außer bei bestimmten Beträgen (für Testzwecke)
        // z.B. Beträge mit .13 am Ende schlagen fehl
        if (zahlungRequest.getBetrag().remainder(java.math.BigDecimal.ONE).compareTo(new java.math.BigDecimal("0.13")) == 0) {
            return false;
        }
        
        return true;
    }
}
