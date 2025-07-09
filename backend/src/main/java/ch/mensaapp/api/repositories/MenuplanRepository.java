package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Menuplan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MenuplanRepository extends JpaRepository<Menuplan, Long> {
    Optional<Menuplan> findByDatum(LocalDate datum);
    List<Menuplan> findByDatumBetween(LocalDate startDate, LocalDate endDate);
    List<Menuplan> findByDatumGreaterThanEqual(LocalDate datum);
    
    // Get all menu plans ordered by date (today first)
    @Query("SELECT m FROM Menuplan m ORDER BY m.datum ASC")
    List<Menuplan> findAllOrderByDatumAsc();
    
    // Get future menu plans ordered by date (today first)
    @Query("SELECT m FROM Menuplan m WHERE m.datum >= :datum ORDER BY m.datum ASC")
    List<Menuplan> findByDatumGreaterThanEqualOrderByDatumAsc(LocalDate datum);
    
    // Optimized query to get available dates for a specific dish
    @Query("SELECT DISTINCT m.datum FROM Menuplan m JOIN m.gerichte g WHERE g.id = :gerichtId AND m.datum >= :today ORDER BY m.datum ASC")
    List<LocalDate> findMenuplanDatesForGericht(@Param("gerichtId") Long gerichtId, @Param("today") LocalDate today);
}
