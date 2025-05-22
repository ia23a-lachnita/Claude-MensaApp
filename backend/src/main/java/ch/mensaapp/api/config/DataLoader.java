package ch.mensaapp.api.config;

import ch.mensaapp.api.models.*;
import ch.mensaapp.api.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Component
public class DataLoader implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private GerichtRepository gerichtRepository;

    @Autowired
    private GetraenkRepository getraenkRepository;

    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private ZahlungRepository zahlungRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        // Only load data if the database is empty
        if (roleRepository.count() == 0) {
            System.out.println("Initializing database with test data...");

            // Create roles first as they're required for users
            createRoles();

            // Create users (including admin, staff and regular users)
            createUsers();

            // Create dishes
            createGerichte();

            // Create drinks
            createGetraenke();

            // Create menu plans for the next 7 days
            createMenuplaene();

            // Create some sample orders
            createBestellungen();

            System.out.println("Test data initialization complete!");
        } else {
            System.out.println("Database already contains data, skipping initialization.");
        }
    }

    private void createRoles() {
        List<Role> roles = Arrays.asList(
                new Role(ERole.ROLE_USER),
                new Role(ERole.ROLE_STAFF),
                new Role(ERole.ROLE_ADMIN)
        );
        roleRepository.saveAll(roles);
        System.out.println("Created roles: " + roles.size());
    }

    private void createUsers() {
        // Get roles from database
        Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Role USER not found"));
        Role staffRole = roleRepository.findByName(ERole.ROLE_STAFF)
                .orElseThrow(() -> new RuntimeException("Role STAFF not found"));
        Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                .orElseThrow(() -> new RuntimeException("Role ADMIN not found"));

        // Create admin user
        User admin = new User();
        admin.setVorname("Admin");
        admin.setNachname("User");
        admin.setEmail("admin@mensaapp.ch");
        admin.setPassword(passwordEncoder.encode("password"));
        admin.setRoles(new HashSet<>(Collections.singletonList(adminRole)));
        userRepository.save(admin);

        // Create staff user
        User staff = new User();
        staff.setVorname("Staff");
        staff.setNachname("Member");
        staff.setEmail("staff@mensaapp.ch");
        staff.setPassword(passwordEncoder.encode("password"));
        staff.setRoles(new HashSet<>(Collections.singletonList(staffRole)));
        userRepository.save(staff);

        // Create regular users
        User user1 = new User();
        user1.setVorname("Max");
        user1.setNachname("Muster");
        user1.setEmail("max@example.com");
        user1.setPassword(passwordEncoder.encode("password"));
        user1.setRoles(new HashSet<>(Collections.singletonList(userRole)));
        userRepository.save(user1);

        User user2 = new User();
        user2.setVorname("Anna");
        user2.setNachname("Schmidt");
        user2.setEmail("anna@example.com");
        user2.setPassword(passwordEncoder.encode("password"));
        user2.setRoles(new HashSet<>(Collections.singletonList(userRole)));
        userRepository.save(user2);

        System.out.println("Created users: admin, staff, and 2 regular users");
    }

    private void createGerichte() {
        List<Gericht> gerichte = new ArrayList<>();

        // Create a few dishes
        Gericht gericht1 = new Gericht();
        gericht1.setName("Spaghetti Bolognese");
        gericht1.setBeschreibung("Klassische Spaghetti mit hausgemachter Bolognese-Sauce aus bestem Rindfleisch");
        gericht1.setPreis(new BigDecimal("12.50"));
        gericht1.setVegetarisch(false);
        gericht1.setVegan(false);
        gericht1.setZutaten(new HashSet<>(Arrays.asList("Spaghetti", "Rindfleisch", "Tomaten", "Zwiebeln", "Karotten", "Sellerie", "Knoblauch", "Oregano")));
        gericht1.setAllergene(new HashSet<>(Arrays.asList("Gluten", "Sellerie")));
        gericht1.setBildUrl("https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht1);

        Gericht gericht2 = new Gericht();
        gericht2.setName("Gemüse-Curry");
        gericht2.setBeschreibung("Würziges Curry mit frischem Gemüse der Saison, serviert mit duftendem Basmatireis");
        gericht2.setPreis(new BigDecimal("14.00"));
        gericht2.setVegetarisch(true);
        gericht2.setVegan(true);
        gericht2.setZutaten(new HashSet<>(Arrays.asList("Basmatireis", "Karotten", "Zucchini", "Paprika", "Kichererbsen", "Kokosmilch", "Currygewürz")));
        gericht2.setAllergene(new HashSet<>(Arrays.asList("Senf")));
        gericht2.setBildUrl("https://images.unsplash.com/photo-1585937421612-70a008356c36?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht2);

        Gericht gericht3 = new Gericht();
        gericht3.setName("Wiener Schnitzel");
        gericht3.setBeschreibung("Traditionelles Kalbsschnitzel in knuspriger Panade, serviert mit Pommes frites und Preiselbeeren");
        gericht3.setPreis(new BigDecimal("18.50"));
        gericht3.setVegetarisch(false);
        gericht3.setVegan(false);
        gericht3.setZutaten(new HashSet<>(Arrays.asList("Kalbfleisch", "Paniermehl", "Eier", "Kartoffeln", "Preiselbeeren")));
        gericht3.setAllergene(new HashSet<>(Arrays.asList("Gluten", "Eier")));
        gericht3.setBildUrl("https://images.unsplash.com/photo-1599921841143-819065a55cc6?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht3);

        Gericht gericht4 = new Gericht();
        gericht4.setName("Caprese Salat");
        gericht4.setBeschreibung("Frischer Salat mit Tomaten, Mozzarella und Basilikum, serviert mit Balsamico-Reduktion");
        gericht4.setPreis(new BigDecimal("10.00"));
        gericht4.setVegetarisch(true);
        gericht4.setVegan(false);
        gericht4.setZutaten(new HashSet<>(Arrays.asList("Tomaten", "Mozzarella", "Basilikum", "Balsamico", "Olivenöl")));
        gericht4.setAllergene(new HashSet<>(Arrays.asList("Milch")));
        gericht4.setBildUrl("https://images.unsplash.com/photo-1546793665-c74683f339c1?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht4);

        Gericht gericht5 = new Gericht();
        gericht5.setName("Quinoa-Bowl");
        gericht5.setBeschreibung("Proteinreiche Bowl mit Quinoa, Avocado, Edamame und knackigem Gemüse");
        gericht5.setPreis(new BigDecimal("15.00"));
        gericht5.setVegetarisch(true);
        gericht5.setVegan(true);
        gericht5.setZutaten(new HashSet<>(Arrays.asList("Quinoa", "Avocado", "Edamame", "Gurke", "Karotten", "Spinat", "Sesam")));
        gericht5.setAllergene(new HashSet<>(Arrays.asList("Sesam", "Soja")));
        gericht5.setBildUrl("https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht5);

        Gericht gericht6 = new Gericht();
        gericht6.setName("Käse-Spätzle");
        gericht6.setBeschreibung("Hausgemachte Spätzle mit würzigem Bergkäse überbacken und knusprigen Röstzwiebeln");
        gericht6.setPreis(new BigDecimal("13.50"));
        gericht6.setVegetarisch(true);
        gericht6.setVegan(false);
        gericht6.setZutaten(new HashSet<>(Arrays.asList("Mehl", "Eier", "Käse", "Zwiebeln", "Muskatnuss")));
        gericht6.setAllergene(new HashSet<>(Arrays.asList("Gluten", "Eier", "Milch")));
        gericht6.setBildUrl("https://images.unsplash.com/photo-1541529086526-db283c563270?auto=format&fit=crop&w=500&q=80");
        gerichte.add(gericht6);

        gerichtRepository.saveAll(gerichte);
        System.out.println("Created dishes: " + gerichte.size());
    }

    private void createGetraenke() {
        List<Getraenk> getraenke = new ArrayList<>();

        Getraenk getraenk1 = new Getraenk();
        getraenk1.setName("Mineralwasser");
        getraenk1.setBeschreibung("Stilles Mineralwasser 0.5l");
        getraenk1.setPreis(new BigDecimal("2.50"));
        getraenk1.setVorrat(100);
        getraenk1.setVerfuegbar(true);
        getraenk1.setBildUrl("https://images.unsplash.com/photo-1564419320461-6870880221ad?auto=format&fit=crop&w=500&q=80");
        getraenke.add(getraenk1);

        Getraenk getraenk2 = new Getraenk();
        getraenk2.setName("Cola");
        getraenk2.setBeschreibung("Cola 0.5l");
        getraenk2.setPreis(new BigDecimal("3.50"));
        getraenk2.setVorrat(80);
        getraenk2.setVerfuegbar(true);
        getraenk2.setBildUrl("https://images.unsplash.com/photo-1581636625402-29b2a704ef13?auto=format&fit=crop&w=500&q=80");
        getraenke.add(getraenk2);

        Getraenk getraenk3 = new Getraenk();
        getraenk3.setName("Apfelsaft");
        getraenk3.setBeschreibung("Naturtrüber Apfelsaft 0.3l");
        getraenk3.setPreis(new BigDecimal("3.00"));
        getraenk3.setVorrat(50);
        getraenk3.setVerfuegbar(true);
        getraenk3.setBildUrl("https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=500&q=80");
        getraenke.add(getraenk3);

        Getraenk getraenk4 = new Getraenk();
        getraenk4.setName("Eistee Zitrone");
        getraenk4.setBeschreibung("Erfrischender Eistee mit Zitrone 0.5l");
        getraenk4.setPreis(new BigDecimal("3.20"));
        getraenk4.setVorrat(60);
        getraenk4.setVerfuegbar(true);
        getraenk4.setBildUrl("https://images.unsplash.com/photo-1499638673689-79a0b5115d87?auto=format&fit=crop&w=500&q=80");
        getraenke.add(getraenk4);

        Getraenk getraenk5 = new Getraenk();
        getraenk5.setName("Orangensaft");
        getraenk5.setBeschreibung("Frisch gepresster Orangensaft 0.3l");
        getraenk5.setPreis(new BigDecimal("4.50"));
        getraenk5.setVorrat(30);
        getraenk5.setVerfuegbar(true);
        getraenk5.setBildUrl("https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=500&q=80");
        getraenke.add(getraenk5);

        getraenkRepository.saveAll(getraenke);
        System.out.println("Created drinks: " + getraenke.size());
    }

    private void createMenuplaene() {
        // Get all dishes to randomly assign them to menu plans
        List<Gericht> alleGerichte = gerichtRepository.findAll();
        if (alleGerichte.isEmpty()) {
            System.out.println("No dishes available to create menu plans");
            return;
        }

        List<Menuplan> menuplaene = new ArrayList<>();

        // Create menu plans for the next 7 days
        LocalDate today = LocalDate.now();
        for (int i = 0; i < 7; i++) {
            LocalDate menuDate = today.plusDays(i);
            Menuplan menuplan = new Menuplan();
            menuplan.setDatum(menuDate);

            // Randomly select 3-5 dishes for each day
            Set<Gericht> tagesGerichte = new HashSet<>();
            int numberOfDishes = 3 + new Random().nextInt(3); // 3 to 5 dishes

            for (int j = 0; j < numberOfDishes && j < alleGerichte.size(); j++) {
                // Pick a random dish that hasn't been added yet
                Gericht randomGericht;
                do {
                    randomGericht = alleGerichte.get(new Random().nextInt(alleGerichte.size()));
                } while (tagesGerichte.contains(randomGericht));

                tagesGerichte.add(randomGericht);
            }

            menuplan.setGerichte(tagesGerichte);
            menuplaene.add(menuplan);
        }

        menuplanRepository.saveAll(menuplaene);
        System.out.println("Created menu plans for the next 7 days: " + menuplaene.size());
    }

    private void createBestellungen() {
        // Get users and menu plans
        List<User> users = userRepository.findAll();
        List<Menuplan> menuplaene = menuplanRepository.findAll();

        if (users.isEmpty() || menuplaene.isEmpty()) {
            System.out.println("No users or menu plans available to create orders");
            return;
        }

        // Create a few sample orders
        List<Bestellung> bestellungen = new ArrayList<>();

        // For simplicity, create orders for regular users (indices 2 and 3 assuming admin is at 0 and staff at 1)
        for (int i = 2; i < users.size(); i++) {
            User user = users.get(i);

            // Create 1-3 orders per user
            int orderCount = 1 + new Random().nextInt(3);

            for (int j = 0; j < orderCount; j++) {
                // Pick a random menu plan from today onwards
                LocalDate today = LocalDate.now();
                List<Menuplan> futureMenus = menuplaene.stream()
                        .filter(m -> !m.getDatum().isBefore(today))
                        .toList();

                if (futureMenus.isEmpty()) continue;

                Menuplan randomMenu = futureMenus.get(new Random().nextInt(futureMenus.size()));
                List<Gericht> availableDishes = new ArrayList<>(randomMenu.getGerichte());

                if (availableDishes.isEmpty()) continue;

                // Create the order
                Bestellung bestellung = new Bestellung();
                bestellung.setUser(user);
                bestellung.setAbholDatum(randomMenu.getDatum());
                bestellung.setAbholZeit(LocalTime.of(12, 0).plusMinutes(new Random().nextInt(120))); // Random time between 12:00 and 14:00
                bestellung.setBestellDatum(LocalDate.now());
                bestellung.setBemerkungen("Test-Bestellung erstellt durch DataLoader");

                // Add 1-3 random dishes to the order
                List<BestellPosition> positionen = new ArrayList<>();
                BigDecimal gesamtPreis = BigDecimal.ZERO;

                int dishCount = 1 + new Random().nextInt(3);
                for (int k = 0; k < dishCount && k < availableDishes.size(); k++) {
                    Gericht gericht = availableDishes.get(k);
                    int anzahl = 1 + new Random().nextInt(2); // 1 or 2 items per dish

                    BestellPosition position = new BestellPosition();
                    position.setBestellung(bestellung);
                    position.setGericht(gericht);
                    position.setAnzahl(anzahl);
                    position.setEinzelPreis(gericht.getPreis());

                    positionen.add(position);
                    gesamtPreis = gesamtPreis.add(gericht.getPreis().multiply(new BigDecimal(anzahl)));
                }

                bestellung.setPositionen(positionen);
                bestellung.setGesamtPreis(gesamtPreis);

                // Randomly set some orders as paid
                boolean isPaid = new Random().nextBoolean();
                if (isPaid) {
                    bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
                    bestellung.setZahlungsReferenz(UUID.randomUUID().toString());

                    // For paid orders, randomly set status
                    int statusRandom = new Random().nextInt(4);
                    switch (statusRandom) {
                        case 0:
                            bestellung.setStatus(BestellStatus.NEU);
                            break;
                        case 1:
                            bestellung.setStatus(BestellStatus.IN_ZUBEREITUNG);
                            break;
                        case 2:
                            bestellung.setStatus(BestellStatus.BEREIT);
                            break;
                        case 3:
                            bestellung.setStatus(BestellStatus.ABGEHOLT);
                            break;
                    }

                    // Create payment record for paid orders
                    Zahlung zahlung = new Zahlung();
                    zahlung.setBestellung(bestellung);
                    zahlung.setBetrag(gesamtPreis);
                    zahlung.setZeitpunkt(LocalDateTime.now().minusHours(new Random().nextInt(24)));
                    zahlung.setZahlungsMethode(new Random().nextBoolean() ? "KREDITKARTE" : "BANKUEBERWEISUNG");
                    zahlung.setTransaktionsId(bestellung.getZahlungsReferenz());
                    zahlung.setErfolgreich(true);

                    zahlungRepository.save(zahlung);
                } else {
                    bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);
                    bestellung.setStatus(BestellStatus.NEU);
                }

                bestellungen.add(bestellung);
            }
        }

        // Save all orders
        bestellungRepository.saveAll(bestellungen);
        System.out.println("Created sample orders: " + bestellungen.size());
    }
}