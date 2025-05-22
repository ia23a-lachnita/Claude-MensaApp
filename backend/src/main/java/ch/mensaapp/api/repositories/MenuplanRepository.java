package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Menuplan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MenuplanRepository extends JpaRepository<Menuplan, Long> {
    Optional<Menuplan> findByDatum(LocalDate datum);
    List<Menuplan> findByDatumBetween(LocalDate startDate, LocalDate endDate);
    List<Menuplan> findByDatumGreaterThanEqual(LocalDate datum);
}
