package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface ZahlungRepository extends JpaRepository<Zahlung, Long> {
    Optional<Zahlung> findByBestellung(Bestellung bestellung);
    Optional<Zahlung> findByTransaktionsId(String transaktionsId);
}
