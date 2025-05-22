package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Entity
@Table(name = "getraenke")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Getraenk {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private BigDecimal preis;

    @Column(nullable = false)
    private Integer vorrat;

    @Column(length = 1000)
    private String beschreibung;

    @Column(nullable = true)
    private String bildUrl;

    private boolean verfuegbar = true;
}
