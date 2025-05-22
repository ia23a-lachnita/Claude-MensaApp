package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Getraenk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GetraenkRepository extends JpaRepository<Getraenk, Long> {
    List<Getraenk> findByVerfuegbar(boolean verfuegbar);
}
