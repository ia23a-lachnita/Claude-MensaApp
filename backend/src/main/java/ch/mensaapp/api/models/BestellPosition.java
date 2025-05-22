package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Entity
@Table(name = "bestell_positionen")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BestellPosition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bestellung_id", nullable = false)
    private Bestellung bestellung;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "gericht_id", nullable = false)
    private Gericht gericht;

    @Column(nullable = false)
    private Integer anzahl;

    @Column(nullable = false)
    private BigDecimal einzelPreis;
}
