package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "bestellungen")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bestellung {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private LocalDate abholDatum;

    @Column(nullable = false)
    private LocalTime abholZeit;

    @Column(nullable = false)
    private LocalDate bestellDatum = LocalDate.now();

    @OneToMany(mappedBy = "bestellung", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BestellPosition> positionen = new ArrayList<>();

    @Column(nullable = false)
    private BigDecimal gesamtPreis;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BestellStatus status = BestellStatus.NEU;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ZahlungsStatus zahlungsStatus = ZahlungsStatus.AUSSTEHEND;

    @Column(length = 255)
    private String zahlungsReferenz;

    @Column(length = 1000)
    private String bemerkungen;
}
