package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellPosition;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;

import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
    private final DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    private final NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("de", "CH"));

    public void sendeBestellBestaetigung(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Bestätigung Ihrer Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Vielen Dank für Ihre Bestellung!</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            emailContent.append("<p>Wir haben Ihre Bestellung erhalten und werden sie zu Ihrer gewählten Zeit bereitstellen.</p>");
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Bestelldatum:</strong> ").append(bestellung.getBestellDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            
            emailContent.append("<h3>Bestellte Gerichte:</h3>");
            emailContent.append("<table border='1' cellpadding='5' style='border-collapse: collapse;'>");
            emailContent.append("<tr><th>Gericht</th><th>Anzahl</th><th>Einzelpreis</th><th>Gesamtpreis</th></tr>");
            
            for (BestellPosition position : bestellung.getPositionen()) {
                emailContent.append("<tr>");
                emailContent.append("<td>").append(position.getGericht().getName()).append("</td>");
                emailContent.append("<td>").append(position.getAnzahl()).append("</td>");
                emailContent.append("<td>").append(currencyFormatter.format(position.getEinzelPreis())).append("</td>");
                emailContent.append("<td>").append(currencyFormatter.format(position.getEinzelPreis().multiply(new java.math.BigDecimal(position.getAnzahl())))).append("</td>");
                emailContent.append("</tr>");
            }
            
            emailContent.append("</table>");
            emailContent.append("<p><strong>Gesamtbetrag:</strong> ").append(currencyFormatter.format(bestellung.getGesamtPreis())).append("</p>");
            
            emailContent.append("<p>Bitte beachten Sie, dass Ihre Bestellung erst nach Zahlungseingang zubereitet wird.</p>");
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
    
    public void sendeZahlungsBestaetigung(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Zahlungsbestätigung für Ihre Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Zahlungsbestätigung</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            emailContent.append("<p>wir bestätigen den Erhalt Ihrer Zahlung für die folgende Bestellung:</p>");
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Zahlungsreferenz:</strong> ").append(bestellung.getZahlungsReferenz()).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            emailContent.append("<p><strong>Gesamtbetrag:</strong> ").append(currencyFormatter.format(bestellung.getGesamtPreis())).append("</p>");
            
            emailContent.append("<p>Ihre Bestellung wird nun vorbereitet und wird zur angegebenen Zeit zur Abholung bereit sein.</p>");
            emailContent.append("<p>Bitte halten Sie Ihre Bestellnummer bereit, wenn Sie Ihre Mahlzeit abholen.</p>");
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
    
    public void sendeBestellStatusUpdate(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Update zu Ihrer Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Update zu Ihrer Bestellung</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            
            switch (bestellung.getStatus()) {
                case IN_ZUBEREITUNG:
                    emailContent.append("<p>Ihre Bestellung wird nun zubereitet und wird pünktlich zur angegebenen Zeit bereit sein.</p>");
                    break;
                case BEREIT:
                    emailContent.append("<p><strong>Ihre Bestellung ist jetzt abholbereit!</strong></p>");
                    emailContent.append("<p>Sie können Ihre Bestellung jetzt an der Mensa-Ausgabe abholen. Bitte halten Sie Ihre Bestellnummer bereit.</p>");
                    break;
                case ABGEHOLT:
                    emailContent.append("<p>Vielen Dank, dass Sie Ihre Bestellung abgeholt haben. Wir hoffen, es hat Ihnen geschmeckt!</p>");
                    break;
                case STORNIERT:
                    emailContent.append("<p>Ihre Bestellung wurde storniert. Falls Sie Fragen haben, kontaktieren Sie bitte unser Mensa-Team.</p>");
                    break;
                default:
                    emailContent.append("<p>Der Status Ihrer Bestellung hat sich geändert. Aktueller Status: ").append(bestellung.getStatus()).append("</p>");
            }
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
}
