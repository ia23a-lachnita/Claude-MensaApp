package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ZahlungRepository extends JpaRepository<Zahlung, Long> {
    Optional<Zahlung> findByBestellung(Bestellung bestellung);
    Optional<Zahlung> findByTransaktionsId(String transaktionsId);
    
    // Find all payments for a specific order
    List<Zahlung> findByBestellungOrderByZeitpunktDesc(Bestellung bestellung);
    
    // Find the most recent successful payment for an order
    @Query("SELECT z FROM Zahlung z WHERE z.bestellung = :bestellung AND z.erfolgreich = true ORDER BY z.zeitpunkt DESC")
    Optional<Zahlung> findLatestSuccessfulPaymentByBestellung(@Param("bestellung") Bestellung bestellung);
    
    // Find the most recent payment attempt for an order
    @Query("SELECT z FROM Zahlung z WHERE z.bestellung = :bestellung ORDER BY z.zeitpunkt DESC")
    Optional<Zahlung> findLatestPaymentByBestellung(@Param("bestellung") Bestellung bestellung);
}
