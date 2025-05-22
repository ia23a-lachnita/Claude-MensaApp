package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.models.ZahlungsStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface BestellungRepository extends JpaRepository<Bestellung, Long> {
    List<Bestellung> findByUser(User user);
    List<Bestellung> findByUserAndStatus(User user, BestellStatus status);
    List<Bestellung> findByAbholDatum(LocalDate abholDatum);
    List<Bestellung> findByAbholDatumAndStatus(LocalDate abholDatum, BestellStatus status);
    List<Bestellung> findByZahlungsStatus(ZahlungsStatus zahlungsStatus);
}
