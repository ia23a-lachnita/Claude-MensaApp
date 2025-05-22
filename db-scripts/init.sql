CREATE DATABASE mensa_db;

\c mensa_db;

-- Rollen-Tabelle
INSERT INTO roles (name) VALUES ('ROLE_USER');
INSERT INTO roles (name) VALUES ('ROLE_STAFF');
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');

-- Admin-Benutzer erstellen
INSERT INTO users (vorname, nachname, email, password, mfa_enabled)
VALUES ('Admin', 'User', 'admin@mensaapp.ch', '$2a$10$KXxQN4hUIQEoyh7VhZ6pneGraQDK0UWz0y0Fi8zt5KJdPJd0.1LOi', false);

INSERT INTO user_roles (user_id, role_id)
VALUES (1, 3);

-- Gerichte erstellen
INSERT INTO gerichte (name, beschreibung, preis, vegetarisch, vegan, bild_url)
VALUES ('Spaghetti Bolognese', 'Klassische Spaghetti mit Rindfleisch-Tomatensauce', 10.50, false, false, 'https://example.com/images/spaghetti.jpg');

INSERT INTO gerichte (name, beschreibung, preis, vegetarisch, vegan, bild_url)
VALUES ('Gemüsecurry', 'Würziges Curry mit frischem Gemüse und Reis', 9.80, true, true, 'https://example.com/images/curry.jpg');

INSERT INTO gerichte (name, beschreibung, preis, vegetarisch, vegan, bild_url)
VALUES ('Schnitzel mit Pommes', 'Knuspriges Schweineschnitzel mit Pommes Frites', 12.50, false, false, 'https://example.com/images/schnitzel.jpg');

INSERT INTO gerichte (name, beschreibung, preis, vegetarisch, vegan, bild_url)
VALUES ('Caprese Salat', 'Tomaten mit Mozzarella und Basilikum', 8.50, true, false, 'https://example.com/images/caprese.jpg');

-- Getränke erstellen
INSERT INTO getraenke (name, beschreibung, preis, vorrat, verfuegbar, bild_url)
VALUES ('Mineralwasser', 'Stilles Mineralwasser 0.5l', 2.50, 100, true, 'https://example.com/images/water.jpg');

INSERT INTO getraenke (name, beschreibung, preis, vorrat, verfuegbar, bild_url)
VALUES ('Cola', 'Cola 0.5l', 3.50, 80, true, 'https://example.com/images/cola.jpg');

INSERT INTO getraenke (name, beschreibung, preis, vorrat, verfuegbar, bild_url)
VALUES ('Apfelsaft', 'Naturtrüber Apfelsaft 0.3l', 3.00, 50, true, 'https://example.com/images/apple_juice.jpg');

-- Menupläne erstellen
INSERT INTO menuplan (datum)
VALUES (CURRENT_DATE);

INSERT INTO menuplan (datum)
VALUES (CURRENT_DATE + INTERVAL '1 day');

INSERT INTO menuplan (datum)
VALUES (CURRENT_DATE + INTERVAL '2 day');

-- Gerichte zu Menuplänen hinzufügen
INSERT INTO menuplan_gerichte (menuplan_id, gericht_id)
VALUES (1, 1), (1, 2), (1, 4);

INSERT INTO menuplan_gerichte (menuplan_id, gericht_id)
VALUES (2, 2), (2, 3);

INSERT INTO menuplan_gerichte (menuplan_id, gericht_id)
VALUES (3, 1), (3, 3), (3, 4);

-- Zutaten und Allergene zu Gerichten hinzufügen
INSERT INTO gericht_zutaten (gericht_id, zutat)
VALUES (1, 'Spaghetti'), (1, 'Rindfleisch'), (1, 'Tomaten'), (1, 'Zwiebeln'), (1, 'Knoblauch');

INSERT INTO gericht_allergene (gericht_id, allergen)
VALUES (1, 'Gluten'), (1, 'Sellerie');

INSERT INTO gericht_zutaten (gericht_id, zutat)
VALUES (2, 'Reis'), (2, 'Karotten'), (2, 'Brokkoli'), (2, 'Zucchini'), (2, 'Kokosmilch'), (2, 'Curry');

INSERT INTO gericht_allergene (gericht_id, allergen)
VALUES (2, 'Senf');

INSERT INTO gericht_zutaten (gericht_id, zutat)
VALUES (3, 'Schweinefleisch'), (3, 'Paniermehl'), (3, 'Kartoffeln'), (3, 'Öl');

INSERT INTO gericht_allergene (gericht_id, allergen)
VALUES (3, 'Gluten'), (3, 'Eier');

INSERT INTO gericht_zutaten (gericht_id, zutat)
VALUES (4, 'Tomaten'), (4, 'Mozzarella'), (4, 'Basilikum'), (4, 'Olivenöl');

INSERT INTO gericht_allergene (gericht_id, allergen)
VALUES (4, 'Milch');
