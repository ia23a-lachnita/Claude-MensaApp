package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "zahlungen")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Zahlung {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bestellung_id", nullable = false)
    private Bestellung bestellung;

    @Column(nullable = false)
    private BigDecimal betrag;

    @Column(nullable = false)
    private LocalDateTime zeitpunkt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ZahlungsMethode zahlungsMethode;

    @Column(nullable = false, length = 100)
    private String transaktionsId;

    @Column(nullable = false)
    private boolean erfolgreich;

    @Column(length = 1000)
    private String fehlerMeldung;
}
