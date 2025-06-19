package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "menuplan", uniqueConstraints = {
        @UniqueConstraint(columnNames = "datum")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Menuplan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate datum;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "menuplan_gerichte",
            joinColumns = @JoinColumn(name = "menuplan_id"),
            inverseJoinColumns = @JoinColumn(name = "gericht_id"))
    private Set<Gericht> gerichte = new HashSet<>();

    // ADDED: Drinks relationship
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "menuplan_getraenke",
            joinColumns = @JoinColumn(name = "menuplan_id"),
            inverseJoinColumns = @JoinColumn(name = "getraenk_id"))
    private Set<Getraenk> getraenke = new HashSet<>();
}
