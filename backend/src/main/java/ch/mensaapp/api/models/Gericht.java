package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "gerichte")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Gericht {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String beschreibung;

    @Column(nullable = false)
    private BigDecimal preis;

    private boolean vegetarisch = false;
    
    private boolean vegan = false;

    @ElementCollection
    @CollectionTable(name = "gericht_zutaten", joinColumns = @JoinColumn(name = "gericht_id"))
    @Column(name = "zutat")
    private Set<String> zutaten = new HashSet<>();

    @ElementCollection
    @CollectionTable(name = "gericht_allergene", joinColumns = @JoinColumn(name = "gericht_id"))
    @Column(name = "allergen")
    private Set<String> allergene = new HashSet<>();

    @Column(nullable = true)
    private String bildUrl;
}
