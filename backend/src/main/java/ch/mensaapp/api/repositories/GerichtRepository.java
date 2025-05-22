package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Gericht;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GerichtRepository extends JpaRepository<Gericht, Long> {
    List<Gericht> findByVegetarisch(boolean vegetarisch);
    List<Gericht> findByVegan(boolean vegan);
}
