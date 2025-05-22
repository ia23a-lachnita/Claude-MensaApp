#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Verwendung: $0 <projekt_verzeichnis>"
    exit 1
fi

PROJEKT_DIR=$1
BACKEND_DIR="$PROJEKT_DIR/backend"
FRONTEND_DIR="$PROJEKT_DIR/frontend"
DB_SCRIPTS_DIR="$PROJEKT_DIR/db-scripts"

echo "Starte die Erstellung der Mensa-App im Verzeichnis: $PROJEKT_DIR"

# Verzeichnisse erstellen
mkdir -p "$BACKEND_DIR"
mkdir -p "$FRONTEND_DIR"
mkdir -p "$DB_SCRIPTS_DIR"

# Spring Boot Backend erstellen
echo "Erstelle Spring Boot Backend..."

# Spring Boot Projekt erstellen
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/config"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/exceptions"
mkdir -p "$BACKEND_DIR/src/main/resources"

# pom.xml erstellen
cat > "$BACKEND_DIR/pom.xml" << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    <groupId>ch.mensaapp</groupId>
    <artifactId>mensa-api</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>mensa-api</name>
    <description>Mensa App API</description>

    <properties>
        <java.version>17</java.version>
        <jjwt.version>0.11.5</jjwt.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-mail</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>${jjwt.version}</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>${jjwt.version}</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>${jjwt.version}</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOL

# application.properties erstellen
cat > "$BACKEND_DIR/src/main/resources/application.properties" << 'EOL'
# Server Konfiguration
server.port=8080
spring.application.name=mensa-api

# Datenbank Konfiguration
spring.datasource.url=jdbc:postgresql://localhost:5432/mensa_db
spring.datasource.username=postgres
spring.datasource.password=postgres
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.show-sql=true

# JWT Konfiguration
app.jwt.secret=6cb7a91c95fda90ab7e9bdd656a69ebba23bdcbdd8c7ec7eb70fd7a30d60e186
app.jwt.expiration=86400000

# Mail Konfiguration
spring.mail.host=smtp.example.com
spring.mail.port=587
spring.mail.username=noreply@mensaapp.ch
spring.mail.password=password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

# Logging
logging.level.org.springframework.security=DEBUG
logging.level.ch.mensaapp=DEBUG
EOL

# Main Application Klasse erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/MensaApiApplication.java" << 'EOL'
package ch.mensaapp.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class MensaApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(MensaApiApplication.class, args);
    }
}
EOL

# Models erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/User.java" << 'EOL'
package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users", uniqueConstraints = {
        @UniqueConstraint(columnNames = "email")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String vorname;

    @Column(nullable = false)
    private String nachname;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private String mfaSecret;
    
    private boolean mfaEnabled = false;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "user_roles", 
               joinColumns = @JoinColumn(name = "user_id"),
               inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles = new HashSet<>();
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Role.java" << 'EOL'
package ch.mensaapp.api.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "roles")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private ERole name;

    public Role(ERole name) {
        this.name = name;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/ERole.java" << 'EOL'
package ch.mensaapp.api.models;

public enum ERole {
    ROLE_USER,
    ROLE_STAFF,
    ROLE_ADMIN
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Gericht.java" << 'EOL'
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
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Menuplan.java" << 'EOL'
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
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Bestellung.java" << 'EOL'
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
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/BestellPosition.java" << 'EOL'
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
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/BestellStatus.java" << 'EOL'
package ch.mensaapp.api.models;

public enum BestellStatus {
    NEU,
    IN_ZUBEREITUNG,
    BEREIT,
    ABGEHOLT,
    STORNIERT
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/ZahlungsStatus.java" << 'EOL'
package ch.mensaapp.api.models;

public enum ZahlungsStatus {
    AUSSTEHEND,
    BEZAHLT,
    STORNIERT
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Getraenk.java" << 'EOL'
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
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/models/Zahlung.java" << 'EOL'
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

    @Column(nullable = false, length = 100)
    private String zahlungsMethode;

    @Column(nullable = false, length = 100)
    private String transaktionsId;

    @Column(nullable = false)
    private boolean erfolgreich;

    @Column(length = 1000)
    private String fehlerMeldung;
}
EOL

# Repositories erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/UserRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    Boolean existsByEmail(String email);
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/RoleRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.ERole;
import ch.mensaapp.api.models.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(ERole name);
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/GerichtRepository.java" << 'EOL'
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
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/MenuplanRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Menuplan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface MenuplanRepository extends JpaRepository<Menuplan, Long> {
    Optional<Menuplan> findByDatum(LocalDate datum);
    List<Menuplan> findByDatumBetween(LocalDate startDate, LocalDate endDate);
    List<Menuplan> findByDatumGreaterThanEqual(LocalDate datum);
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/BestellungRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.models.ZahlungsStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface BestellungRepository extends JpaRepository<Bestellung, Long> {
    List<Bestellung> findByUser(User user);
    List<Bestellung> findByUserAndStatus(User user, BestellStatus status);
    List<Bestellung> findByAbholDatum(LocalDate abholDatum);
    List<Bestellung> findByAbholDatumAndStatus(LocalDate abholDatum, BestellStatus status);
    List<Bestellung> findByZahlungsStatus(ZahlungsStatus zahlungsStatus);
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/GetraenkRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Getraenk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GetraenkRepository extends JpaRepository<Getraenk, Long> {
    List<Getraenk> findByVerfuegbar(boolean verfuegbar);
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/repositories/ZahlungRepository.java" << 'EOL'
package ch.mensaapp.api.repositories;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface ZahlungRepository extends JpaRepository<Zahlung, Long> {
    Optional<Zahlung> findByBestellung(Bestellung bestellung);
    Optional<Zahlung> findByTransaktionsId(String transaktionsId);
}
EOL

# Security Config erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/WebSecurityConfig.java" << 'EOL'
package ch.mensaapp.api.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableMethodSecurity
public class WebSecurityConfig {
    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private AuthEntryPointJwt unauthorizedHandler;

    @Bean
    public AuthTokenFilter authenticationJwtTokenFilter() {
        return new AuthTokenFilter();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .exceptionHandling(exception -> exception.authenticationEntryPoint(unauthorizedHandler))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> 
                auth.requestMatchers("/api/auth/**").permitAll()
                    .requestMatchers("/api/menu/**").permitAll()
                    .requestMatchers("/api/public/**").permitAll()
                    .anyRequest().authenticated()
            );

        http.authenticationProvider(authenticationProvider());
        http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
    
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/AuthEntryPointJwt.java" << 'EOL'
package ch.mensaapp.api.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
public class AuthEntryPointJwt implements AuthenticationEntryPoint {

    private static final Logger logger = LoggerFactory.getLogger(AuthEntryPointJwt.class);

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
            throws IOException, ServletException {
        logger.error("Unbefugter Zugriff: {}", authException.getMessage());

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        final Map<String, Object> body = new HashMap<>();
        body.put("status", HttpServletResponse.SC_UNAUTHORIZED);
        body.put("error", "Unbefugt");
        body.put("message", authException.getMessage());
        body.put("path", request.getServletPath());

        final ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getOutputStream(), body);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/AuthTokenFilter.java" << 'EOL'
package ch.mensaapp.api.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class AuthTokenFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    private static final Logger logger = LoggerFactory.getLogger(AuthTokenFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        try {
            String jwt = parseJwt(request);
            if (jwt != null && jwtUtils.validateJwtToken(jwt)) {
                String username = jwtUtils.getUserNameFromJwtToken(jwt);

                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, null,
                        userDetails.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception e) {
            logger.error("Authentifizierung des Benutzers nicht möglich: {}", e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }

        return null;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/JwtUtils.java" << 'EOL'
package ch.mensaapp.api.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtUtils {
    private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);

    @Value("${app.jwt.secret}")
    private String jwtSecret;

    @Value("${app.jwt.expiration}")
    private int jwtExpirationMs;

    public String generateJwtToken(Authentication authentication) {
        UserDetailsImpl userPrincipal = (UserDetailsImpl) authentication.getPrincipal();

        return Jwts.builder()
                .setSubject((userPrincipal.getUsername()))
                .setIssuedAt(new Date())
                .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
                .signWith(key(), SignatureAlgorithm.HS256)
                .compact();
    }

    private Key key() {
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecret));
    }

    public String getUserNameFromJwtToken(String token) {
        return Jwts.parserBuilder().setSigningKey(key()).build()
                .parseClaimsJws(token).getBody().getSubject();
    }

    public boolean validateJwtToken(String authToken) {
        try {
            Jwts.parserBuilder().setSigningKey(key()).build().parseClaimsJws(authToken);
            return true;
        } catch (MalformedJwtException e) {
            logger.error("Ungültiges JWT Token: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            logger.error("JWT Token ist abgelaufen: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            logger.error("JWT Token wird nicht unterstützt: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.error("JWT Claims String ist leer: {}", e.getMessage());
        }

        return false;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/UserDetailsImpl.java" << 'EOL'
package ch.mensaapp.api.security;

import ch.mensaapp.api.models.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class UserDetailsImpl implements UserDetails {
    private static final long serialVersionUID = 1L;

    private final Long id;
    private final String email;
    @JsonIgnore
    private final String password;
    private final String vorname;
    private final String nachname;
    private final boolean mfaEnabled;
    private final String mfaSecret;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserDetailsImpl(Long id, String email, String password, String vorname, String nachname, 
                          boolean mfaEnabled, String mfaSecret, 
                          Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.vorname = vorname;
        this.nachname = nachname;
        this.mfaEnabled = mfaEnabled;
        this.mfaSecret = mfaSecret;
        this.authorities = authorities;
    }

    public static UserDetailsImpl build(User user) {
        List<GrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority(role.getName().name()))
                .collect(Collectors.toList());

        return new UserDetailsImpl(
                user.getId(),
                user.getEmail(),
                user.getPassword(),
                user.getVorname(),
                user.getNachname(),
                user.isMfaEnabled(),
                user.getMfaSecret(),
                authorities);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getVorname() {
        return vorname;
    }

    public String getNachname() {
        return nachname;
    }

    public boolean isMfaEnabled() {
        return mfaEnabled;
    }

    public String getMfaSecret() {
        return mfaSecret;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        UserDetailsImpl user = (UserDetailsImpl) o;
        return Objects.equals(id, user.id);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/UserDetailsServiceImpl.java" << 'EOL'
package ch.mensaapp.api.security;

import ch.mensaapp.api.models.User;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    UserRepository userRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Benutzer mit E-Mail " + email + " nicht gefunden"));

        return UserDetailsImpl.build(user);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/security/MfaUtils.java" << 'EOL'
package ch.mensaapp.api.security;

import dev.samstevens.totp.code.*;
import dev.samstevens.totp.exceptions.QrGenerationException;
import dev.samstevens.totp.qr.QrData;
import dev.samstevens.totp.qr.QrGenerator;
import dev.samstevens.totp.qr.ZxingPngQrGenerator;
import dev.samstevens.totp.secret.DefaultSecretGenerator;
import dev.samstevens.totp.secret.SecretGenerator;
import dev.samstevens.totp.time.SystemTimeProvider;
import dev.samstevens.totp.time.TimeProvider;
import org.springframework.stereotype.Component;
import static dev.samstevens.totp.util.Utils.getDataUriForImage;

@Component
public class MfaUtils {
    private final SecretGenerator secretGenerator = new DefaultSecretGenerator();
    private final QrGenerator qrGenerator = new ZxingPngQrGenerator();
    private final TimeProvider timeProvider = new SystemTimeProvider();
    private final CodeGenerator codeGenerator = new DefaultCodeGenerator();
    private final CodeVerifier codeVerifier = new DefaultCodeVerifier(codeGenerator, timeProvider);

    public String generateSecret() {
        return secretGenerator.generate();
    }

    public String generateQrCodeImageUri(String secret, String email) {
        QrData data = new QrData.Builder()
                .issuer("Mensa App")
                .label(email)
                .secret(secret)
                .algorithm(HashingAlgorithm.SHA1)
                .digits(6)
                .period(30)
                .build();

        try {
            byte[] imageData = qrGenerator.generate(data);
            return getDataUriForImage(imageData, qrGenerator.getImageMimeType());
        } catch (QrGenerationException e) {
            throw new RuntimeException("Fehler bei der QR-Code-Generierung", e);
        }
    }

    public boolean verifyCode(String code, String secret) {
        return codeVerifier.isValidCode(secret, code);
    }
}
EOL

# Hinzufügen der Abhängigkeit für TOTP im pom.xml
sed -i "/dependencies/a \
        <dependency>\n \
            <groupId>dev.samstevens.totp</groupId>\n \
            <artifactId>totp</artifactId>\n \
            <version>1.7.1</version>\n \
        </dependency>" "$BACKEND_DIR/pom.xml"

# Controller erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/AuthController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.ERole;
import ch.mensaapp.api.models.Role;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.payload.request.*;
import ch.mensaapp.api.payload.response.*;
import ch.mensaapp.api.repositories.RoleRepository;
import ch.mensaapp.api.repositories.UserRepository;
import ch.mensaapp.api.security.JwtUtils;
import ch.mensaapp.api.security.MfaUtils;
import ch.mensaapp.api.security.UserDetailsImpl;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private MfaUtils mfaUtils;

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        if (userDetails.isMfaEnabled()) {
            return ResponseEntity.ok(new MfaRequiredResponse(userDetails.getEmail()));
        } else {
            String jwt = jwtUtils.generateJwtToken(authentication);
            List<String> roles = userDetails.getAuthorities().stream()
                    .map(item -> item.getAuthority())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(new JwtResponse(jwt,
                    userDetails.getId(),
                    userDetails.getUsername(),
                    userDetails.getVorname(),
                    userDetails.getNachname(),
                    roles));
        }
    }

    @PostMapping("/mfa-verify")
    public ResponseEntity<?> verifyMfaCode(@Valid @RequestBody MfaVerificationRequest verificationRequest) {
        User user = userRepository.findByEmail(verificationRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(verificationRequest.getCode(), user.getMfaSecret())) {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(verificationRequest.getEmail(), verificationRequest.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = jwtUtils.generateJwtToken(authentication);
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            
            List<String> roles = userDetails.getAuthorities().stream()
                    .map(item -> item.getAuthority())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(new JwtResponse(jwt,
                    userDetails.getId(),
                    userDetails.getUsername(),
                    userDetails.getVorname(),
                    userDetails.getNachname(),
                    roles));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Fehler: E-Mail ist bereits in Verwendung!"));
        }

        // Create new user's account
        User user = new User();
        user.setVorname(signUpRequest.getVorname());
        user.setNachname(signUpRequest.getNachname());
        user.setEmail(signUpRequest.getEmail());
        user.setPassword(encoder.encode(signUpRequest.getPassword()));

        Set<Role> roles = new HashSet<>();
        Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Fehler: Rolle nicht gefunden."));
        roles.add(userRole);
        
        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("Benutzer erfolgreich registriert!"));
    }

    @PostMapping("/mfa-setup")
    public ResponseEntity<?> setupMfa(@Valid @RequestBody MfaSetupRequest setupRequest) {
        User user = userRepository.findByEmail(setupRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        String secret = mfaUtils.generateSecret();
        String qrCodeImageUri = mfaUtils.generateQrCodeImageUri(secret, user.getEmail());

        user.setMfaSecret(secret);
        userRepository.save(user);

        return ResponseEntity.ok(new MfaSetupResponse(qrCodeImageUri, secret));
    }

    @PostMapping("/mfa-enable")
    public ResponseEntity<?> enableMfa(@Valid @RequestBody MfaEnableRequest enableRequest) {
        User user = userRepository.findByEmail(enableRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(enableRequest.getCode(), user.getMfaSecret())) {
            user.setMfaEnabled(true);
            userRepository.save(user);
            return ResponseEntity.ok(new MessageResponse("MFA erfolgreich aktiviert"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
        }
    }

    @PostMapping("/mfa-disable")
    public ResponseEntity<?> disableMfa(@Valid @RequestBody MfaDisableRequest disableRequest) {
        User user = userRepository.findByEmail(disableRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        if (mfaUtils.verifyCode(disableRequest.getCode(), user.getMfaSecret())) {
            user.setMfaEnabled(false);
            user.setMfaSecret(null);
            userRepository.save(user);
            return ResponseEntity.ok(new MessageResponse("MFA erfolgreich deaktiviert"));
        } else {
            return ResponseEntity.badRequest().body(new MessageResponse("Ungültiger MFA-Code"));
        }
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/MenuController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.services.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/menu")
public class MenuController {
    @Autowired
    private MenuService menuService;

    @GetMapping("/heute")
    public ResponseEntity<MenuplanResponse> getHeutigesMenu() {
        return ResponseEntity.ok(menuService.getMenuplanFuerDatum(LocalDate.now()));
    }

    @GetMapping("/datum/{datum}")
    public ResponseEntity<MenuplanResponse> getMenuFuerDatum(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(menuService.getMenuplanFuerDatum(datum));
    }

    @GetMapping("/woche")
    public ResponseEntity<List<MenuplanResponse>> getMenuFuerWoche(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDatum) {
        if (startDatum == null) {
            startDatum = LocalDate.now();
        }
        return ResponseEntity.ok(menuService.getMenuplanFuerWoche(startDatum));
    }

    @GetMapping("/gerichte")
    public ResponseEntity<List<Gericht>> getAlleGerichte() {
        return ResponseEntity.ok(menuService.getAlleGerichte());
    }

    @GetMapping("/gerichte/vegetarisch")
    public ResponseEntity<List<Gericht>> getVegetarischeGerichte() {
        return ResponseEntity.ok(menuService.getVegetarischeGerichte());
    }

    @GetMapping("/gerichte/vegan")
    public ResponseEntity<List<Gericht>> getVeganeGerichte() {
        return ResponseEntity.ok(menuService.getVeganeGerichte());
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/GerichtController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.GerichtService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/gerichte")
public class GerichtController {
    @Autowired
    private GerichtService gerichtService;

    @GetMapping
    public ResponseEntity<List<Gericht>> getAlleGerichte() {
        return ResponseEntity.ok(gerichtService.getAlleGerichte());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Gericht> getGerichtById(@PathVariable Long id) {
        return ResponseEntity.ok(gerichtService.getGerichtById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Gericht> erstelleGericht(@Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.erstelleGericht(gerichtRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Gericht> aktualisiereGericht(@PathVariable Long id, @Valid @RequestBody GerichtRequest gerichtRequest) {
        return ResponseEntity.ok(gerichtService.aktualisiereGericht(id, gerichtRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MessageResponse> loescheGericht(@PathVariable Long id) {
        gerichtService.loescheGericht(id);
        return ResponseEntity.ok(new MessageResponse("Gericht erfolgreich gelöscht"));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/MenuplanController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.request.MenuplanRequest;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.MenuplanService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/menuplan")
public class MenuplanController {
    @Autowired
    private MenuplanService menuplanService;

    @GetMapping
    public ResponseEntity<List<MenuplanResponse>> getAlleMenuplaene() {
        return ResponseEntity.ok(menuplanService.getAlleMenuplaene());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MenuplanResponse> getMenuplanById(@PathVariable Long id) {
        return ResponseEntity.ok(menuplanService.getMenuplanById(id));
    }

    @GetMapping("/datum/{datum}")
    public ResponseEntity<MenuplanResponse> getMenuplanByDatum(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(menuplanService.getMenuplanByDatum(datum));
    }

    @PostMapping
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MenuplanResponse> erstelleMenuplan(@Valid @RequestBody MenuplanRequest menuplanRequest) {
        return ResponseEntity.ok(menuplanService.erstelleMenuplan(menuplanRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MenuplanResponse> aktualisiereMenuplan(@PathVariable Long id, @Valid @RequestBody MenuplanRequest menuplanRequest) {
        return ResponseEntity.ok(menuplanService.aktualisiereMenuplan(id, menuplanRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MessageResponse> loescheMenuplan(@PathVariable Long id) {
        menuplanService.loescheMenuplan(id);
        return ResponseEntity.ok(new MessageResponse("Menuplan erfolgreich gelöscht"));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/BestellungController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.payload.request.BestellungRequest;
import ch.mensaapp.api.payload.response.BestellungResponse;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.BestellungService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/bestellungen")
public class BestellungController {
    @Autowired
    private BestellungService bestellungService;

    @GetMapping("/meine")
    public ResponseEntity<List<BestellungResponse>> getMyBestellungen(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.getBestellungenByUser(userDetails.getId()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BestellungResponse> getBestellungById(@PathVariable Long id, @AuthenticationPrincipal UserDetailsImpl userDetails) {
        BestellungResponse bestellung = bestellungService.getBestellungById(id);
        
        // Prüfen, ob die Bestellung dem aktuellen Benutzer gehört oder ob der Benutzer Admin/Staff ist
        if (bestellung.getUserId().equals(userDetails.getId()) || 
            userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_STAFF"))) {
            return ResponseEntity.ok(bestellung);
        } else {
            return ResponseEntity.status(403).build();
        }
    }

    @PostMapping
    public ResponseEntity<BestellungResponse> createBestellung(@Valid @RequestBody BestellungRequest bestellungRequest, 
                                                         @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.erstelleBestellung(bestellungRequest, userDetails.getId()));
    }

    @PutMapping("/{id}/stornieren")
    public ResponseEntity<BestellungResponse> storniereBestellung(@PathVariable Long id, @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(bestellungService.storniereBestellung(id, userDetails.getId()));
    }

    @GetMapping("/alle")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<List<BestellungResponse>> getAlleBestellungen() {
        return ResponseEntity.ok(bestellungService.getAlleBestellungen());
    }

    @GetMapping("/datum/{datum}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<List<BestellungResponse>> getBestellungenByDatum(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(bestellungService.getBestellungenByAbholDatum(datum));
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<BestellungResponse> updateBestellungStatus(@PathVariable Long id, @RequestParam BestellStatus status) {
        return ResponseEntity.ok(bestellungService.updateBestellungStatus(id, status));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/ZahlungController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.payload.request.ZahlungRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.payload.response.ZahlungResponse;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.ZahlungService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/zahlungen")
public class ZahlungController {
    @Autowired
    private ZahlungService zahlungService;

    @PostMapping("/{bestellungId}")
    public ResponseEntity<?> processZahlung(@PathVariable Long bestellungId, 
                                           @Valid @RequestBody ZahlungRequest zahlungRequest,
                                           @AuthenticationPrincipal UserDetailsImpl userDetails) {
        ZahlungResponse zahlungResponse = zahlungService.verarbeiteZahlung(bestellungId, zahlungRequest, userDetails.getId());
        return ResponseEntity.ok(zahlungResponse);
    }

    @GetMapping("/{bestellungId}")
    public ResponseEntity<?> getZahlungStatus(@PathVariable Long bestellungId, 
                                             @AuthenticationPrincipal UserDetailsImpl userDetails) {
        ZahlungResponse zahlungResponse = zahlungService.getZahlungByBestellungId(bestellungId, userDetails.getId());
        return ResponseEntity.ok(zahlungResponse);
    }

    @PostMapping("/webhook")
    public ResponseEntity<MessageResponse> zahlungWebhook(@RequestBody String payload) {
        // Diese Methode würde in einer realen Anwendung von Zahlungsanbietern für Webhooks verwendet
        zahlungService.verarbeiteZahlungsWebhook(payload);
        return ResponseEntity.ok(new MessageResponse("Webhook verarbeitet"));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/GetraenkController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.payload.request.GetraenkRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.services.GetraenkService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/getraenke")
public class GetraenkController {
    @Autowired
    private GetraenkService getraenkService;

    @GetMapping
    public ResponseEntity<List<Getraenk>> getAlleGetraenke() {
        return ResponseEntity.ok(getraenkService.getAlleGetraenke());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Getraenk> getGetraenkById(@PathVariable Long id) {
        return ResponseEntity.ok(getraenkService.getGetraenkById(id));
    }

    @GetMapping("/verfuegbar")
    public ResponseEntity<List<Getraenk>> getVerfuegbareGetraenke() {
        return ResponseEntity.ok(getraenkService.getVerfuegbareGetraenke());
    }

    @PostMapping
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> erstelleGetraenk(@Valid @RequestBody GetraenkRequest getraenkRequest) {
        return ResponseEntity.ok(getraenkService.erstelleGetraenk(getraenkRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> aktualisiereGetraenk(@PathVariable Long id, @Valid @RequestBody GetraenkRequest getraenkRequest) {
        return ResponseEntity.ok(getraenkService.aktualisiereGetraenk(id, getraenkRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<MessageResponse> loescheGetraenk(@PathVariable Long id) {
        getraenkService.loescheGetraenk(id);
        return ResponseEntity.ok(new MessageResponse("Getränk erfolgreich gelöscht"));
    }

    @PutMapping("/{id}/vorrat")
    @PreAuthorize("hasRole('STAFF') or hasRole('ADMIN')")
    public ResponseEntity<Getraenk> aktualisiereVorrat(@PathVariable Long id, @RequestParam Integer vorrat) {
        return ResponseEntity.ok(getraenkService.aktualisiereVorrat(id, vorrat));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/controllers/UserController.java" << 'EOL'
package ch.mensaapp.api.controllers;

import ch.mensaapp.api.models.User;
import ch.mensaapp.api.payload.request.PasswordUpdateRequest;
import ch.mensaapp.api.payload.request.ProfileUpdateRequest;
import ch.mensaapp.api.payload.response.MessageResponse;
import ch.mensaapp.api.payload.response.UserResponse;
import ch.mensaapp.api.security.UserDetailsImpl;
import ch.mensaapp.api.services.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(userService.getUserById(userDetails.getId()));
    }

    @PutMapping("/me")
    public ResponseEntity<UserResponse> updateUserProfile(
            @Valid @RequestBody ProfileUpdateRequest profileRequest,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        return ResponseEntity.ok(userService.updateUserProfile(userDetails.getId(), profileRequest));
    }

    @PutMapping("/me/password")
    public ResponseEntity<MessageResponse> updatePassword(
            @Valid @RequestBody PasswordUpdateRequest passwordRequest,
            @AuthenticationPrincipal UserDetailsImpl userDetails) {
        userService.updatePassword(userDetails.getId(), passwordRequest);
        return ResponseEntity.ok(new MessageResponse("Passwort erfolgreich aktualisiert"));
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    @PutMapping("/{id}/roles")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponse> updateUserRoles(@PathVariable Long id, @RequestBody List<String> roles) {
        return ResponseEntity.ok(userService.updateUserRoles(id, roles));
    }
}
EOL

# Payload-Klassen erstellen
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request"
mkdir -p "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response"

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/LoginRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String password;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/SignupRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class SignupRequest {
    @NotBlank
    @Size(min = 2, max = 50)
    private String vorname;

    @NotBlank
    @Size(min = 2, max = 50)
    private String nachname;

    @NotBlank
    @Size(max = 50)
    @Email
    private String email;

    @NotBlank
    @Size(min = 8, max = 50)
    private String password;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/MfaSetupRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class MfaSetupRequest {
    @NotBlank
    @Email
    private String email;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/MfaEnableRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MfaEnableRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Size(min = 6, max = 6)
    private String code;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/MfaDisableRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MfaDisableRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Size(min = 6, max = 6)
    private String code;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/MfaVerificationRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MfaVerificationRequest {
    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String password;

    @NotBlank
    @Size(min = 6, max = 6)
    private String code;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/GerichtRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

@Data
public class GerichtRequest {
    @NotBlank
    private String name;

    private String beschreibung;

    @NotNull
    @Positive
    private BigDecimal preis;

    private boolean vegetarisch;

    private boolean vegan;

    private Set<String> zutaten;

    private Set<String> allergene;

    private String bildUrl;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/MenuplanRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.Set;

@Data
public class MenuplanRequest {
    @NotNull
    private LocalDate datum;

    @NotNull
    private Set<Long> gerichtIds;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/BestellungRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
public class BestellungRequest {
    @NotNull
    @Future(message = "Das Abholdatum muss in der Zukunft liegen")
    private LocalDate abholDatum;

    @NotNull
    private LocalTime abholZeit;

    @NotEmpty
    private List<@Valid BestellPositionRequest> positionen;

    private String bemerkungen;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/BestellPositionRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BestellPositionRequest {
    @NotNull
    private Long gerichtId;

    @NotNull
    @Min(1)
    private Integer anzahl;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/GetraenkRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class GetraenkRequest {
    @NotBlank
    private String name;

    @NotNull
    @Positive
    private BigDecimal preis;

    @NotNull
    @Min(0)
    private Integer vorrat;

    private String beschreibung;

    private String bildUrl;

    private boolean verfuegbar = true;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/ZahlungRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ZahlungRequest {
    @NotBlank
    private String zahlungsMethode;

    @NotNull
    private BigDecimal betrag;

    private String kartenNummer;
    
    private String kartenName;
    
    private String kartenCVV;
    
    private String kartenAblaufMonat;
    
    private String kartenAblaufJahr;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/ProfileUpdateRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ProfileUpdateRequest {
    @NotBlank
    @Size(min = 2, max = 50)
    private String vorname;

    @NotBlank
    @Size(min = 2, max = 50)
    private String nachname;

    @NotBlank
    @Size(max = 50)
    @Email
    private String email;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/request/PasswordUpdateRequest.java" << 'EOL'
package ch.mensaapp.api.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class PasswordUpdateRequest {
    @NotBlank
    private String altesPassword;

    @NotBlank
    @Size(min = 8, max = 50)
    private String neuesPassword;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/JwtResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class JwtResponse {
    private String token;
    private Long id;
    private String email;
    private String vorname;
    private String nachname;
    private List<String> roles;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/MessageResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MessageResponse {
    private String message;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/MfaRequiredResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MfaRequiredResponse {
    private String email;
    private final boolean mfaRequired = true;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/MfaSetupResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class MfaSetupResponse {
    private String qrCodeUrl;
    private String secret;
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/GerichtResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Gericht;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Set;

@Data
public class GerichtResponse {
    private Long id;
    private String name;
    private String beschreibung;
    private BigDecimal preis;
    private boolean vegetarisch;
    private boolean vegan;
    private Set<String> zutaten;
    private Set<String> allergene;
    private String bildUrl;

    public static GerichtResponse fromEntity(Gericht gericht) {
        GerichtResponse response = new GerichtResponse();
        response.setId(gericht.getId());
        response.setName(gericht.getName());
        response.setBeschreibung(gericht.getBeschreibung());
        response.setPreis(gericht.getPreis());
        response.setVegetarisch(gericht.isVegetarisch());
        response.setVegan(gericht.isVegan());
        response.setZutaten(gericht.getZutaten());
        response.setAllergene(gericht.getAllergene());
        response.setBildUrl(gericht.getBildUrl());
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/MenuplanResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import lombok.Data;

import java.time.LocalDate;
import java.util.Set;
import java.util.stream.Collectors;

@Data
public class MenuplanResponse {
    private Long id;
    private LocalDate datum;
    private Set<GerichtResponse> gerichte;

    public static MenuplanResponse fromEntity(Menuplan menuplan) {
        MenuplanResponse response = new MenuplanResponse();
        response.setId(menuplan.getId());
        response.setDatum(menuplan.getDatum());
        response.setGerichte(menuplan.getGerichte().stream()
                .map(GerichtResponse::fromEntity)
                .collect(Collectors.toSet()));
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/BestellPositionResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.BestellPosition;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class BestellPositionResponse {
    private Long id;
    private Long gerichtId;
    private String gerichtName;
    private Integer anzahl;
    private BigDecimal einzelPreis;
    private BigDecimal gesamtPreis;

    public static BestellPositionResponse fromEntity(BestellPosition position) {
        BestellPositionResponse response = new BestellPositionResponse();
        response.setId(position.getId());
        response.setGerichtId(position.getGericht().getId());
        response.setGerichtName(position.getGericht().getName());
        response.setAnzahl(position.getAnzahl());
        response.setEinzelPreis(position.getEinzelPreis());
        response.setGesamtPreis(position.getEinzelPreis().multiply(BigDecimal.valueOf(position.getAnzahl())));
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/BestellungResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellStatus;
import ch.mensaapp.api.models.ZahlungsStatus;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
public class BestellungResponse {
    private Long id;
    private Long userId;
    private String userEmail;
    private String userName;
    private LocalDate abholDatum;
    private LocalTime abholZeit;
    private LocalDate bestellDatum;
    private List<BestellPositionResponse> positionen;
    private BigDecimal gesamtPreis;
    private BestellStatus status;
    private ZahlungsStatus zahlungsStatus;
    private String zahlungsReferenz;
    private String bemerkungen;

    public static BestellungResponse fromEntity(Bestellung bestellung) {
        BestellungResponse response = new BestellungResponse();
        response.setId(bestellung.getId());
        response.setUserId(bestellung.getUser().getId());
        response.setUserEmail(bestellung.getUser().getEmail());
        response.setUserName(bestellung.getUser().getVorname() + " " + bestellung.getUser().getNachname());
        response.setAbholDatum(bestellung.getAbholDatum());
        response.setAbholZeit(bestellung.getAbholZeit());
        response.setBestellDatum(bestellung.getBestellDatum());
        response.setPositionen(bestellung.getPositionen().stream()
                .map(BestellPositionResponse::fromEntity)
                .collect(Collectors.toList()));
        response.setGesamtPreis(bestellung.getGesamtPreis());
        response.setStatus(bestellung.getStatus());
        response.setZahlungsStatus(bestellung.getZahlungsStatus());
        response.setZahlungsReferenz(bestellung.getZahlungsReferenz());
        response.setBemerkungen(bestellung.getBemerkungen());
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/GetraenkResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Getraenk;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class GetraenkResponse {
    private Long id;
    private String name;
    private BigDecimal preis;
    private Integer vorrat;
    private String beschreibung;
    private String bildUrl;
    private boolean verfuegbar;

    public static GetraenkResponse fromEntity(Getraenk getraenk) {
        GetraenkResponse response = new GetraenkResponse();
        response.setId(getraenk.getId());
        response.setName(getraenk.getName());
        response.setPreis(getraenk.getPreis());
        response.setVorrat(getraenk.getVorrat());
        response.setBeschreibung(getraenk.getBeschreibung());
        response.setBildUrl(getraenk.getBildUrl());
        response.setVerfuegbar(getraenk.isVerfuegbar());
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/UserResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.User;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

@Data
public class UserResponse {
    private Long id;
    private String vorname;
    private String nachname;
    private String email;
    private boolean mfaEnabled;
    private List<String> roles;

    public static UserResponse fromEntity(User user) {
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setVorname(user.getVorname());
        response.setNachname(user.getNachname());
        response.setEmail(user.getEmail());
        response.setMfaEnabled(user.isMfaEnabled());
        response.setRoles(user.getRoles().stream()
                .map(role -> role.getName().name())
                .collect(Collectors.toList()));
        return response;
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/payload/response/ZahlungResponse.java" << 'EOL'
package ch.mensaapp.api.payload.response;

import ch.mensaapp.api.models.Zahlung;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ZahlungResponse {
    private Long id;
    private Long bestellungId;
    private BigDecimal betrag;
    private LocalDateTime zeitpunkt;
    private String zahlungsMethode;
    private String transaktionsId;
    private boolean erfolgreich;
    private String fehlerMeldung;

    public static ZahlungResponse fromEntity(Zahlung zahlung) {
        ZahlungResponse response = new ZahlungResponse();
        response.setId(zahlung.getId());
        response.setBestellungId(zahlung.getBestellung().getId());
        response.setBetrag(zahlung.getBetrag());
        response.setZeitpunkt(zahlung.getZeitpunkt());
        response.setZahlungsMethode(zahlung.getZahlungsMethode());
        response.setTransaktionsId(zahlung.getTransaktionsId());
        response.setErfolgreich(zahlung.isErfolgreich());
        response.setFehlerMeldung(zahlung.getFehlerMeldung());
        return response;
    }
}
EOL

# Service-Klassen erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/MenuService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MenuService {
    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtRepository gerichtRepository;

    public MenuplanResponse getMenuplanFuerDatum(LocalDate datum) {
        Menuplan menuplan = menuplanRepository.findByDatum(datum)
                .orElseThrow(() -> new RuntimeException("Kein Menuplan für dieses Datum verfügbar"));
        return MenuplanResponse.fromEntity(menuplan);
    }

    public List<MenuplanResponse> getMenuplanFuerWoche(LocalDate startDatum) {
        LocalDate endDatum = startDatum.plusDays(6);
        List<Menuplan> menuplaene = menuplanRepository.findByDatumBetween(startDatum, endDatum);
        return menuplaene.stream()
                .map(MenuplanResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<Gericht> getAlleGerichte() {
        return gerichtRepository.findAll();
    }

    public List<Gericht> getVegetarischeGerichte() {
        return gerichtRepository.findByVegetarisch(true);
    }

    public List<Gericht> getVeganeGerichte() {
        return gerichtRepository.findByVegan(true);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/GerichtService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.payload.request.GerichtRequest;
import ch.mensaapp.api.repositories.GerichtRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GerichtService {
    @Autowired
    private GerichtRepository gerichtRepository;

    public List<Gericht> getAlleGerichte() {
        return gerichtRepository.findAll();
    }

    public Gericht getGerichtById(Long id) {
        return gerichtRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden"));
    }

    @Transactional
    public Gericht erstelleGericht(GerichtRequest gerichtRequest) {
        Gericht gericht = new Gericht();
        gericht.setName(gerichtRequest.getName());
        gericht.setBeschreibung(gerichtRequest.getBeschreibung());
        gericht.setPreis(gerichtRequest.getPreis());
        gericht.setVegetarisch(gerichtRequest.isVegetarisch());
        gericht.setVegan(gerichtRequest.isVegan());
        gericht.setZutaten(gerichtRequest.getZutaten());
        gericht.setAllergene(gerichtRequest.getAllergene());
        gericht.setBildUrl(gerichtRequest.getBildUrl());

        return gerichtRepository.save(gericht);
    }

    @Transactional
    public Gericht aktualisiereGericht(Long id, GerichtRequest gerichtRequest) {
        Gericht gericht = getGerichtById(id);

        gericht.setName(gerichtRequest.getName());
        gericht.setBeschreibung(gerichtRequest.getBeschreibung());
        gericht.setPreis(gerichtRequest.getPreis());
        gericht.setVegetarisch(gerichtRequest.isVegetarisch());
        gericht.setVegan(gerichtRequest.isVegan());
        gericht.setZutaten(gerichtRequest.getZutaten());
        gericht.setAllergene(gerichtRequest.getAllergene());
        gericht.setBildUrl(gerichtRequest.getBildUrl());

        return gerichtRepository.save(gericht);
    }

    @Transactional
    public void loescheGericht(Long id) {
        Gericht gericht = getGerichtById(id);
        gerichtRepository.delete(gericht);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/MenuplanService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Gericht;
import ch.mensaapp.api.models.Menuplan;
import ch.mensaapp.api.payload.request.MenuplanRequest;
import ch.mensaapp.api.payload.response.MenuplanResponse;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.MenuplanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class MenuplanService {
    @Autowired
    private MenuplanRepository menuplanRepository;

    @Autowired
    private GerichtRepository gerichtRepository;

    public List<MenuplanResponse> getAlleMenuplaene() {
        return menuplanRepository.findAll().stream()
                .map(MenuplanResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public MenuplanResponse getMenuplanById(Long id) {
        return MenuplanResponse.fromEntity(menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden")));
    }

    public MenuplanResponse getMenuplanByDatum(LocalDate datum) {
        return MenuplanResponse.fromEntity(menuplanRepository.findByDatum(datum)
                .orElseThrow(() -> new RuntimeException("Kein Menuplan für dieses Datum verfügbar")));
    }

    @Transactional
    public MenuplanResponse erstelleMenuplan(MenuplanRequest menuplanRequest) {
        if (menuplanRepository.findByDatum(menuplanRequest.getDatum()).isPresent()) {
            throw new RuntimeException("Für dieses Datum existiert bereits ein Menuplan");
        }

        Menuplan menuplan = new Menuplan();
        menuplan.setDatum(menuplanRequest.getDatum());

        Set<Gericht> gerichte = new HashSet<>();
        for (Long gerichtId : menuplanRequest.getGerichtIds()) {
            Gericht gericht = gerichtRepository.findById(gerichtId)
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + gerichtId));
            gerichte.add(gericht);
        }
        menuplan.setGerichte(gerichte);

        return MenuplanResponse.fromEntity(menuplanRepository.save(menuplan));
    }

    @Transactional
    public MenuplanResponse aktualisiereMenuplan(Long id, MenuplanRequest menuplanRequest) {
        Menuplan menuplan = menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden"));

        // Prüfen, ob für das neue Datum bereits ein Menuplan existiert (ausser es ist das gleiche Datum)
        if (!menuplan.getDatum().equals(menuplanRequest.getDatum()) && 
            menuplanRepository.findByDatum(menuplanRequest.getDatum()).isPresent()) {
            throw new RuntimeException("Für dieses Datum existiert bereits ein Menuplan");
        }

        menuplan.setDatum(menuplanRequest.getDatum());

        Set<Gericht> gerichte = new HashSet<>();
        for (Long gerichtId : menuplanRequest.getGerichtIds()) {
            Gericht gericht = gerichtRepository.findById(gerichtId)
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + gerichtId));
            gerichte.add(gericht);
        }
        menuplan.setGerichte(gerichte);

        return MenuplanResponse.fromEntity(menuplanRepository.save(menuplan));
    }

    @Transactional
    public void loescheMenuplan(Long id) {
        Menuplan menuplan = menuplanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menuplan nicht gefunden"));
        menuplanRepository.delete(menuplan);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/BestellungService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.*;
import ch.mensaapp.api.payload.request.BestellPositionRequest;
import ch.mensaapp.api.payload.request.BestellungRequest;
import ch.mensaapp.api.payload.response.BestellungResponse;
import ch.mensaapp.api.repositories.BestellungRepository;
import ch.mensaapp.api.repositories.GerichtRepository;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BestellungService {
    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired 
    private GerichtRepository gerichtRepository;

    public List<BestellungResponse> getAlleBestellungen() {
        return bestellungRepository.findAll().stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<BestellungResponse> getBestellungenByUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));
        
        return bestellungRepository.findByUser(user).stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<BestellungResponse> getBestellungenByAbholDatum(LocalDate abholDatum) {
        return bestellungRepository.findByAbholDatum(abholDatum).stream()
                .map(BestellungResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public BestellungResponse getBestellungById(Long id) {
        return BestellungResponse.fromEntity(bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden")));
    }

    @Transactional
    public BestellungResponse erstelleBestellung(BestellungRequest bestellungRequest, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        Bestellung bestellung = new Bestellung();
        bestellung.setUser(user);
        bestellung.setAbholDatum(bestellungRequest.getAbholDatum());
        bestellung.setAbholZeit(bestellungRequest.getAbholZeit());
        bestellung.setBestellDatum(LocalDate.now());
        bestellung.setBemerkungen(bestellungRequest.getBemerkungen());
        bestellung.setStatus(BestellStatus.NEU);
        bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);

        List<BestellPosition> positionen = new ArrayList<>();
        BigDecimal gesamtPreis = BigDecimal.ZERO;

        for (BestellPositionRequest positionRequest : bestellungRequest.getPositionen()) {
            Gericht gericht = gerichtRepository.findById(positionRequest.getGerichtId())
                    .orElseThrow(() -> new RuntimeException("Gericht nicht gefunden: " + positionRequest.getGerichtId()));

            BestellPosition position = new BestellPosition();
            position.setBestellung(bestellung);
            position.setGericht(gericht);
            position.setAnzahl(positionRequest.getAnzahl());
            position.setEinzelPreis(gericht.getPreis());

            positionen.add(position);
            
            // Gesamtpreis berechnen
            BigDecimal positionPreis = gericht.getPreis().multiply(new BigDecimal(positionRequest.getAnzahl()));
            gesamtPreis = gesamtPreis.add(positionPreis);
        }

        bestellung.setPositionen(positionen);
        bestellung.setGesamtPreis(gesamtPreis);

        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }

    @Transactional
    public BestellungResponse storniereBestellung(Long id, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        // Prüfen, ob die Bestellung bereits in Zubereitung ist
        if (bestellung.getStatus() != BestellStatus.NEU) {
            throw new RuntimeException("Bestellung kann nicht mehr storniert werden");
        }

        bestellung.setStatus(BestellStatus.STORNIERT);
        bestellung.setZahlungsStatus(ZahlungsStatus.STORNIERT);

        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }

    @Transactional
    public BestellungResponse updateBestellungStatus(Long id, BestellStatus status) {
        Bestellung bestellung = bestellungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        bestellung.setStatus(status);
        return BestellungResponse.fromEntity(bestellungRepository.save(bestellung));
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/GetraenkService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Getraenk;
import ch.mensaapp.api.payload.request.GetraenkRequest;
import ch.mensaapp.api.repositories.GetraenkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GetraenkService {
    @Autowired
    private GetraenkRepository getraenkRepository;

    public List<Getraenk> getAlleGetraenke() {
        return getraenkRepository.findAll();
    }

    public Getraenk getGetraenkById(Long id) {
        return getraenkRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Getränk nicht gefunden"));
    }

    public List<Getraenk> getVerfuegbareGetraenke() {
        return getraenkRepository.findByVerfuegbar(true);
    }

    @Transactional
    public Getraenk erstelleGetraenk(GetraenkRequest getraenkRequest) {
        Getraenk getraenk = new Getraenk();
        getraenk.setName(getraenkRequest.getName());
        getraenk.setPreis(getraenkRequest.getPreis());
        getraenk.setVorrat(getraenkRequest.getVorrat());
        getraenk.setBeschreibung(getraenkRequest.getBeschreibung());
        getraenk.setBildUrl(getraenkRequest.getBildUrl());
        getraenk.setVerfuegbar(getraenkRequest.isVerfuegbar());

        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public Getraenk aktualisiereGetraenk(Long id, GetraenkRequest getraenkRequest) {
        Getraenk getraenk = getGetraenkById(id);

        getraenk.setName(getraenkRequest.getName());
        getraenk.setPreis(getraenkRequest.getPreis());
        getraenk.setVorrat(getraenkRequest.getVorrat());
        getraenk.setBeschreibung(getraenkRequest.getBeschreibung());
        getraenk.setBildUrl(getraenkRequest.getBildUrl());
        getraenk.setVerfuegbar(getraenkRequest.isVerfuegbar());

        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public Getraenk aktualisiereVorrat(Long id, Integer vorrat) {
        Getraenk getraenk = getGetraenkById(id);
        getraenk.setVorrat(vorrat);
        
        if (vorrat <= 0) {
            getraenk.setVerfuegbar(false);
        }
        
        return getraenkRepository.save(getraenk);
    }

    @Transactional
    public void loescheGetraenk(Long id) {
        Getraenk getraenk = getGetraenkById(id);
        getraenkRepository.delete(getraenk);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/ZahlungService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.Zahlung;
import ch.mensaapp.api.models.ZahlungsStatus;
import ch.mensaapp.api.payload.request.ZahlungRequest;
import ch.mensaapp.api.payload.response.ZahlungResponse;
import ch.mensaapp.api.repositories.BestellungRepository;
import ch.mensaapp.api.repositories.ZahlungRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class ZahlungService {
    @Autowired
    private ZahlungRepository zahlungRepository;

    @Autowired
    private BestellungRepository bestellungRepository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public ZahlungResponse verarbeiteZahlung(Long bestellungId, ZahlungRequest zahlungRequest, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(bestellungId)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        // Prüfen, ob die Bestellung bereits bezahlt ist
        if (bestellung.getZahlungsStatus() == ZahlungsStatus.BEZAHLT) {
            throw new RuntimeException("Diese Bestellung wurde bereits bezahlt");
        }

        // Prüfen, ob der Betrag korrekt ist
        if (zahlungRequest.getBetrag().compareTo(bestellung.getGesamtPreis()) != 0) {
            throw new RuntimeException("Der Zahlungsbetrag stimmt nicht mit dem Bestellungsbetrag überein");
        }

        // Zahlung speichern
        Zahlung zahlung = new Zahlung();
        zahlung.setBestellung(bestellung);
        zahlung.setBetrag(zahlungRequest.getBetrag());
        zahlung.setZeitpunkt(LocalDateTime.now());
        zahlung.setZahlungsMethode(zahlungRequest.getZahlungsMethode());
        
        // In einer realen Anwendung würde hier die Zahlungsabwicklung mit einem echten Zahlungsanbieter erfolgen
        // Hier simulieren wir einen erfolgreichen Zahlungsvorgang
        String transaktionsId = UUID.randomUUID().toString();
        zahlung.setTransaktionsId(transaktionsId);
        zahlung.setErfolgreich(true);
        
        // Bestellung aktualisieren
        bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
        bestellung.setZahlungsReferenz(transaktionsId);
        bestellungRepository.save(bestellung);
        
        Zahlung gespeicherteZahlung = zahlungRepository.save(zahlung);
        
        // E-Mail mit Zahlungsbestätigung senden
        emailService.sendeZahlungsBestaetigung(bestellung);
        
        return ZahlungResponse.fromEntity(gespeicherteZahlung);
    }

    public ZahlungResponse getZahlungByBestellungId(Long bestellungId, Long userId) {
        Bestellung bestellung = bestellungRepository.findById(bestellungId)
                .orElseThrow(() -> new RuntimeException("Bestellung nicht gefunden"));

        // Prüfen, ob die Bestellung dem Benutzer gehört
        if (!bestellung.getUser().getId().equals(userId)) {
            throw new RuntimeException("Keine Berechtigung für diese Bestellung");
        }

        Zahlung zahlung = zahlungRepository.findByBestellung(bestellung)
                .orElseThrow(() -> new RuntimeException("Keine Zahlung für diese Bestellung gefunden"));

        return ZahlungResponse.fromEntity(zahlung);
    }

    @Transactional
    public void verarbeiteZahlungsWebhook(String payload) {
        // In einer realen Anwendung würde hier die Verarbeitung von Webhook-Payloads von Zahlungsanbietern erfolgen
        // Hier gibt es nur eine einfache Implementierung
        
        try {
            // Beispiel für einen einfachen Webhook-Payload: "transaction_id:XXXX,status:success"
            String[] parts = payload.split(",");
            String transactionId = parts[0].split(":")[1];
            String status = parts[1].split(":")[1];

            Zahlung zahlung = zahlungRepository.findByTransaktionsId(transactionId)
                    .orElseThrow(() -> new RuntimeException("Keine Zahlung mit dieser Transaktions-ID gefunden"));

            if ("success".equals(status)) {
                if (!zahlung.isErfolgreich()) {
                    zahlung.setErfolgreich(true);
                    
                    Bestellung bestellung = zahlung.getBestellung();
                    bestellung.setZahlungsStatus(ZahlungsStatus.BEZAHLT);
                    bestellungRepository.save(bestellung);
                    
                    zahlungRepository.save(zahlung);
                    
                    // E-Mail senden
                    emailService.sendeZahlungsBestaetigung(bestellung);
                }
            } else if ("failed".equals(status)) {
                zahlung.setErfolgreich(false);
                zahlung.setFehlerMeldung("Zahlung fehlgeschlagen laut Webhook");
                
                Bestellung bestellung = zahlung.getBestellung();
                bestellung.setZahlungsStatus(ZahlungsStatus.AUSSTEHEND);
                bestellungRepository.save(bestellung);
                
                zahlungRepository.save(zahlung);
            }
        } catch (Exception e) {
            throw new RuntimeException("Fehler bei der Verarbeitung des Webhooks: " + e.getMessage());
        }
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/EmailService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.Bestellung;
import ch.mensaapp.api.models.BestellPosition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;

import javax.mail.internet.MimeMessage;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private TemplateEngine templateEngine;
    
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
    private final DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    private final NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("de", "CH"));

    public void sendeBestellBestaetigung(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Bestätigung Ihrer Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Vielen Dank für Ihre Bestellung!</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            emailContent.append("<p>Wir haben Ihre Bestellung erhalten und werden sie zu Ihrer gewählten Zeit bereitstellen.</p>");
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Bestelldatum:</strong> ").append(bestellung.getBestellDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            
            emailContent.append("<h3>Bestellte Gerichte:</h3>");
            emailContent.append("<table border='1' cellpadding='5' style='border-collapse: collapse;'>");
            emailContent.append("<tr><th>Gericht</th><th>Anzahl</th><th>Einzelpreis</th><th>Gesamtpreis</th></tr>");
            
            for (BestellPosition position : bestellung.getPositionen()) {
                emailContent.append("<tr>");
                emailContent.append("<td>").append(position.getGericht().getName()).append("</td>");
                emailContent.append("<td>").append(position.getAnzahl()).append("</td>");
                emailContent.append("<td>").append(currencyFormatter.format(position.getEinzelPreis())).append("</td>");
                emailContent.append("<td>").append(currencyFormatter.format(position.getEinzelPreis().multiply(new java.math.BigDecimal(position.getAnzahl())))).append("</td>");
                emailContent.append("</tr>");
            }
            
            emailContent.append("</table>");
            emailContent.append("<p><strong>Gesamtbetrag:</strong> ").append(currencyFormatter.format(bestellung.getGesamtPreis())).append("</p>");
            
            emailContent.append("<p>Bitte beachten Sie, dass Ihre Bestellung erst nach Zahlungseingang zubereitet wird.</p>");
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
    
    public void sendeZahlungsBestaetigung(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Zahlungsbestätigung für Ihre Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Zahlungsbestätigung</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            emailContent.append("<p>wir bestätigen den Erhalt Ihrer Zahlung für die folgende Bestellung:</p>");
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Zahlungsreferenz:</strong> ").append(bestellung.getZahlungsReferenz()).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            emailContent.append("<p><strong>Gesamtbetrag:</strong> ").append(currencyFormatter.format(bestellung.getGesamtPreis())).append("</p>");
            
            emailContent.append("<p>Ihre Bestellung wird nun vorbereitet und wird zur angegebenen Zeit zur Abholung bereit sein.</p>");
            emailContent.append("<p>Bitte halten Sie Ihre Bestellnummer bereit, wenn Sie Ihre Mahlzeit abholen.</p>");
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
    
    public void sendeBestellStatusUpdate(Bestellung bestellung) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setTo(bestellung.getUser().getEmail());
            helper.setSubject("Update zu Ihrer Mensa-Bestellung #" + bestellung.getId());
            
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body>");
            emailContent.append("<h1>Update zu Ihrer Bestellung</h1>");
            emailContent.append("<p>Sehr geehrte(r) ").append(bestellung.getUser().getVorname()).append(" ").append(bestellung.getUser().getNachname()).append(",</p>");
            
            switch (bestellung.getStatus()) {
                case IN_ZUBEREITUNG:
                    emailContent.append("<p>Ihre Bestellung wird nun zubereitet und wird pünktlich zur angegebenen Zeit bereit sein.</p>");
                    break;
                case BEREIT:
                    emailContent.append("<p><strong>Ihre Bestellung ist jetzt abholbereit!</strong></p>");
                    emailContent.append("<p>Sie können Ihre Bestellung jetzt an der Mensa-Ausgabe abholen. Bitte halten Sie Ihre Bestellnummer bereit.</p>");
                    break;
                case ABGEHOLT:
                    emailContent.append("<p>Vielen Dank, dass Sie Ihre Bestellung abgeholt haben. Wir hoffen, es hat Ihnen geschmeckt!</p>");
                    break;
                case STORNIERT:
                    emailContent.append("<p>Ihre Bestellung wurde storniert. Falls Sie Fragen haben, kontaktieren Sie bitte unser Mensa-Team.</p>");
                    break;
                default:
                    emailContent.append("<p>Der Status Ihrer Bestellung hat sich geändert. Aktueller Status: ").append(bestellung.getStatus()).append("</p>");
            }
            
            emailContent.append("<h2>Bestelldetails:</h2>");
            emailContent.append("<p><strong>Bestellnummer:</strong> ").append(bestellung.getId()).append("</p>");
            emailContent.append("<p><strong>Abholdatum:</strong> ").append(bestellung.getAbholDatum().format(dateFormatter)).append("</p>");
            emailContent.append("<p><strong>Abholzeit:</strong> ").append(bestellung.getAbholZeit().format(timeFormatter)).append(" Uhr</p>");
            
            emailContent.append("<p>Mit freundlichen Grüssen,<br>Ihr Mensa-Team</p>");
            emailContent.append("</body></html>");
            
            helper.setText(emailContent.toString(), true);
            
            mailSender.send(message);
        } catch (Exception e) {
            // Log error but don't interrupt the process
            e.printStackTrace();
        }
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/services/UserService.java" << 'EOL'
package ch.mensaapp.api.services;

import ch.mensaapp.api.models.ERole;
import ch.mensaapp.api.models.Role;
import ch.mensaapp.api.models.User;
import ch.mensaapp.api.payload.request.PasswordUpdateRequest;
import ch.mensaapp.api.payload.request.ProfileUpdateRequest;
import ch.mensaapp.api.payload.response.UserResponse;
import ch.mensaapp.api.repositories.RoleRepository;
import ch.mensaapp.api.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(UserResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public UserResponse getUserById(Long id) {
        return UserResponse.fromEntity(userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden")));
    }

    @Transactional
    public UserResponse updateUserProfile(Long id, ProfileUpdateRequest profileRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        // Prüfen, ob die E-Mail bereits von einem anderen Benutzer verwendet wird
        if (!user.getEmail().equals(profileRequest.getEmail()) && 
            userRepository.existsByEmail(profileRequest.getEmail())) {
            throw new RuntimeException("E-Mail wird bereits verwendet");
        }

        user.setVorname(profileRequest.getVorname());
        user.setNachname(profileRequest.getNachname());
        user.setEmail(profileRequest.getEmail());

        return UserResponse.fromEntity(userRepository.save(user));
    }

    @Transactional
    public void updatePassword(Long id, PasswordUpdateRequest passwordRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        // Prüfen, ob das alte Passwort korrekt ist
        if (!encoder.matches(passwordRequest.getAltesPassword(), user.getPassword())) {
            throw new RuntimeException("Altes Passwort ist nicht korrekt");
        }

        user.setPassword(encoder.encode(passwordRequest.getNeuesPassword()));
        userRepository.save(user);
    }

    @Transactional
    public UserResponse updateUserRoles(Long id, List<String> roleNames) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benutzer nicht gefunden"));

        Set<Role> roles = new HashSet<>();
        for (String roleName : roleNames) {
            ERole eRole;
            try {
                eRole = ERole.valueOf("ROLE_" + roleName.toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Rolle nicht gefunden: " + roleName);
            }

            Role role = roleRepository.findByName(eRole)
                    .orElseThrow(() -> new RuntimeException("Rolle nicht gefunden: " + eRole));
            roles.add(role);
        }

        user.setRoles(roles);
        return UserResponse.fromEntity(userRepository.save(user));
    }
}
EOL

# Exception-Handler erstellen
cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/exceptions/GlobalExceptionHandler.java" << 'EOL'
package ch.mensaapp.api.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(RuntimeException ex) {
        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                ex.getMessage()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception ex) {
        ErrorResponse errorResponse = new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Ein Fehler ist aufgetreten: " + ex.getMessage()
        );
        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
EOL

cat > "$BACKEND_DIR/src/main/java/ch/mensaapp/api/exceptions/ErrorResponse.java" << 'EOL'
package ch.mensaapp.api.exceptions;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ErrorResponse {
    private int status;
    private String message;
}
EOL

# DB-Scripts erstellen
cat > "$DB_SCRIPTS_DIR/init.sql" << 'EOL'
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
EOL

# React Frontend erstellen
echo "Erstelle React Frontend..."

# package.json erstellen
cat > "$FRONTEND_DIR/package.json" << 'EOL'
{
  "name": "mensa-app-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0",
    "@mui/icons-material": "^5.14.18",
    "@mui/lab": "^5.0.0-alpha.153",
    "@mui/material": "^5.14.18",
    "@mui/x-date-pickers": "^6.18.1",
    "@reduxjs/toolkit": "^1.9.7",
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "axios": "^1.6.2",
    "date-fns": "^2.30.0",
    "formik": "^2.4.5",
    "jwt-decode": "^4.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^8.1.3",
    "react-router-dom": "^6.19.0",
    "react-scripts": "5.0.1",
    "react-toastify": "^9.1.3",
    "redux-persist": "^6.0.0",
    "web-vitals": "^2.1.4",
    "yup": "^1.3.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOL

# Grundstruktur erstellen
mkdir -p "$FRONTEND_DIR/public"
mkdir -p "$FRONTEND_DIR/src/components"
mkdir -p "$FRONTEND_DIR/src/pages"
mkdir -p "$FRONTEND_DIR/src/services"
mkdir -p "$FRONTEND_DIR/src/store"
mkdir -p "$FRONTEND_DIR/src/assets"
mkdir -p "$FRONTEND_DIR/src/utils"
mkdir -p "$FRONTEND_DIR/src/hooks"

# Public-Dateien
cat > "$FRONTEND_DIR/public/index.html" << 'EOL'
<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="Mensa App - Bestellen Sie Ihr Essen in der Mensa"
    />
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <link
      rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
    />
    <title>Mensa App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOL

cat > "$FRONTEND_DIR/public/manifest.json" << 'EOL'
{
  "short_name": "Mensa App",
  "name": "Mensa App - Bestellen Sie Ihr Essen in der Mensa",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    },
    {
      "src": "logo192.png",
      "type": "image/png",
      "sizes": "192x192"
    },
    {
      "src": "logo512.png",
      "type": "image/png",
      "sizes": "512x512"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOL

# Src-Dateien
cat > "$FRONTEND_DIR/src/index.js" << 'EOL'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/integration/react';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { store, persistor } from './store';
import App from './App';
import CssBaseline from '@mui/material/CssBaseline';
import { ThemeProvider } from '@mui/material/styles';
import theme from './theme';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <BrowserRouter>
          <ThemeProvider theme={theme}>
            <CssBaseline />
            <App />
            <ToastContainer position="bottom-right" />
          </ThemeProvider>
        </BrowserRouter>
      </PersistGate>
    </Provider>
  </React.StrictMode>
);
EOL

cat > "$FRONTEND_DIR/src/App.js" << 'EOL'
import React, { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { checkTokenExpiration } from './store/auth/authActions';

// Layouts
import MainLayout from './layouts/MainLayout';
import AdminLayout from './layouts/AdminLayout';

// Pages
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import Menu from './pages/Menu';
import MenuDetails from './pages/MenuDetails';
import Checkout from './pages/Checkout';
import Payment from './pages/Payment';
import OrderConfirmation from './pages/OrderConfirmation';
import Profile from './pages/Profile';
import OrderHistory from './pages/OrderHistory';
import OrderDetail from './pages/OrderDetail';
import AdminDashboard from './pages/admin/Dashboard';
import AdminOrders from './pages/admin/Orders';
import AdminMenus from './pages/admin/Menus';
import AdminMenuEdit from './pages/admin/MenuEdit';
import AdminDishes from './pages/admin/Dishes';
import AdminDishEdit from './pages/admin/DishEdit';
import AdminDrinks from './pages/admin/Drinks';
import AdminDrinkEdit from './pages/admin/DrinkEdit';
import AdminUsers from './pages/admin/Users';
import NotFound from './pages/NotFound';

// Protected Route Component
const ProtectedRoute = ({ children, allowedRoles }) => {
  const { isLoggedIn, user } = useSelector(state => state.auth);
  const dispatch = useDispatch();

  useEffect(() => {
    if (isLoggedIn) {
      dispatch(checkTokenExpiration());
    }
  }, [dispatch, isLoggedIn]);

  if (!isLoggedIn) {
    return <Navigate to="/login" />;
  }

  if (allowedRoles && (!user.roles || !allowedRoles.some(role => user.roles.includes(role)))) {
    return <Navigate to="/" />;
  }

  return children;
};

const App = () => {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/" element={<MainLayout />}>
        <Route index element={<Home />} />
        <Route path="login" element={<Login />} />
        <Route path="register" element={<Register />} />
        <Route path="menu" element={<Menu />} />
        <Route path="menu/:date" element={<MenuDetails />} />
        
        {/* Protected User Routes */}
        <Route path="checkout" element={
          <ProtectedRoute>
            <Checkout />
          </ProtectedRoute>
        } />
        <Route path="payment/:orderId" element={
          <ProtectedRoute>
            <Payment />
          </ProtectedRoute>
        } />
        <Route path="order-confirmation/:orderId" element={
          <ProtectedRoute>
            <OrderConfirmation />
          </ProtectedRoute>
        } />
        <Route path="profile" element={
          <ProtectedRoute>
            <Profile />
          </ProtectedRoute>
        } />
        <Route path="orders" element={
          <ProtectedRoute>
            <OrderHistory />
          </ProtectedRoute>
        } />
        <Route path="orders/:id" element={
          <ProtectedRoute>
            <OrderDetail />
          </ProtectedRoute>
        } />
      </Route>

      {/* Admin Routes */}
      <Route path="/admin" element={
        <ProtectedRoute allowedRoles={['ROLE_ADMIN', 'ROLE_STAFF']}>
          <AdminLayout />
        </ProtectedRoute>
      }>
        <Route index element={<AdminDashboard />} />
        <Route path="orders" element={<AdminOrders />} />
        <Route path="menus" element={<AdminMenus />} />
        <Route path="menus/new" element={<AdminMenuEdit />} />
        <Route path="menus/:id" element={<AdminMenuEdit />} />
        <Route path="dishes" element={<AdminDishes />} />
        <Route path="dishes/new" element={<AdminDishEdit />} />
        <Route path="dishes/:id" element={<AdminDishEdit />} />
        <Route path="drinks" element={<AdminDrinks />} />
        <Route path="drinks/new" element={<AdminDrinkEdit />} />
        <Route path="drinks/:id" element={<AdminDrinkEdit />} />
        <Route path="users" element={
          <ProtectedRoute allowedRoles={['ROLE_ADMIN']}>
            <AdminUsers />
          </ProtectedRoute>
        } />
      </Route>
      
      {/* Not Found */}
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

export default App;
EOL

cat > "$FRONTEND_DIR/src/theme.js" << 'EOL'
import { createTheme } from '@mui/material/styles';

const theme = createTheme({
  palette: {
    primary: {
      main: '#007a49', // Grün für ein frisches Mensa-Feeling
      light: '#4aab77',
      dark: '#004b20',
      contrastText: '#ffffff',
    },
    secondary: {
      main: '#ff6b35', // Orange als Akzentfarbe
      light: '#ff9c68',
      dark: '#c53800',
      contrastText: '#ffffff',
    },
    background: {
      default: '#f9f9f9',
      paper: '#ffffff',
    },
    text: {
      primary: '#333333',
      secondary: '#666666',
    },
    error: {
      main: '#d32f2f',
    },
    warning: {
      main: '#ffa000',
    },
    info: {
      main: '#1976d2',
    },
    success: {
      main: '#2e7d32',
    },
  },
  typography: {
    fontFamily: [
      'Roboto',
      'Helvetica',
      'Arial',
      'sans-serif',
    ].join(','),
    h1: {
      fontSize: '2.5rem',
      fontWeight: 500,
    },
    h2: {
      fontSize: '2rem',
      fontWeight: 500,
    },
    h3: {
      fontSize: '1.75rem',
      fontWeight: 500,
    },
    h4: {
      fontSize: '1.5rem',
      fontWeight: 500,
    },
    h5: {
      fontSize: '1.25rem',
      fontWeight: 500,
    },
    h6: {
      fontSize: '1rem',
      fontWeight: 500,
    },
    button: {
      textTransform: 'none',
    },
  },
  shape: {
    borderRadius: 8,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 8,
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 12,
          boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          borderRadius: 12,
        },
      },
    },
  },
});

export default theme;
EOL

# Services erstellen
cat > "$FRONTEND_DIR/src/services/api.js" << 'EOL'
import axios from 'axios';
import { store } from '../store';
import { logout } from '../store/auth/authSlice';

const API_URL = 'http://localhost:8080/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor für Anfragen
api.interceptors.request.use(
  (config) => {
    const { auth } = store.getState();
    if (auth.token) {
      config.headers.Authorization = `Bearer ${auth.token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor für Antworten
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;
    
    // Bei 401 Unauthorized automatisch abmelden
    if (response && response.status === 401) {
      store.dispatch(logout());
    }
    
    return Promise.reject(error);
  }
);

// Auth Services
export const authService = {
  login: (email, password) => api.post('/auth/signin', { email, password }),
  register: (userData) => api.post('/auth/signup', userData),
  verifyMfa: (email, password, code) => api.post('/auth/mfa-verify', { email, password, code }),
  setupMfa: (email) => api.post('/auth/mfa-setup', { email }),
  enableMfa: (email, code) => api.post('/auth/mfa-enable', { email, code }),
  disableMfa: (email, code) => api.post('/auth/mfa-disable', { email, code }),
};

// User Services
export const userService = {
  getCurrentUser: () => api.get('/users/me'),
  updateProfile: (userData) => api.put('/users/me', userData),
  updatePassword: (passwordData) => api.put('/users/me/password', passwordData),
  getAllUsers: () => api.get('/users'),
  getUserById: (id) => api.get(`/users/${id}`),
  updateUserRoles: (id, roles) => api.put(`/users/${id}/roles`, roles),
};

// Menu Services
export const menuService = {
  getMenuToday: () => api.get('/menu/heute'),
  getMenuByDate: (date) => api.get(`/menu/datum/${date}`),
  getMenuForWeek: (startDate) => api.get('/menu/woche', { params: { startDatum: startDate } }),
  getAllDishes: () => api.get('/menu/gerichte'),
  getVegetarianDishes: () => api.get('/menu/gerichte/vegetarisch'),
  getVeganDishes: () => api.get('/menu/gerichte/vegan'),
};

// Menuplan Admin Services
export const menuplanService = {
  getAllMenuplans: () => api.get('/menuplan'),
  getMenuplanById: (id) => api.get(`/menuplan/${id}`),
  getMenuplanByDate: (date) => api.get(`/menuplan/datum/${date}`),
  createMenuplan: (menuplanData) => api.post('/menuplan', menuplanData),
  updateMenuplan: (id, menuplanData) => api.put(`/menuplan/${id}`, menuplanData),
  deleteMenuplan: (id) => api.delete(`/menuplan/${id}`),
};

// Gericht Services
export const gerichtService = {
  getAllGerichte: () => api.get('/gerichte'),
  getGerichtById: (id) => api.get(`/gerichte/${id}`),
  createGericht: (gerichtData) => api.post('/gerichte', gerichtData),
  updateGericht: (id, gerichtData) => api.put(`/gerichte/${id}`, gerichtData),
  deleteGericht: (id) => api.delete(`/gerichte/${id}`),
};

// Bestellung Services
export const bestellungService = {
  getMyBestellungen: () => api.get('/bestellungen/meine'),
  getBestellungById: (id) => api.get(`/bestellungen/${id}`),
  createBestellung: (bestellungData) => api.post('/bestellungen', bestellungData),
  storniereBestellung: (id) => api.put(`/bestellungen/${id}/stornieren`),
  getAllBestellungen: () => api.get('/bestellungen/alle'),
  getBestellungenByDatum: (date) => api.get(`/bestellungen/datum/${date}`),
  updateBestellungStatus: (id, status) => api.put(`/bestellungen/${id}/status`, null, { params: { status } }),
};

// Getränk Services
export const getraenkService = {
  getAllGetraenke: () => api.get('/getraenke'),
  getGetraenkById: (id) => api.get(`/getraenke/${id}`),
  getVerfuegbareGetraenke: () => api.get('/getraenke/verfuegbar'),
  createGetraenk: (getraenkData) => api.post('/getraenke', getraenkData),
  updateGetraenk: (id, getraenkData) => api.put(`/getraenke/${id}`, getraenkData),
  updateVorrat: (id, vorrat) => api.put(`/getraenke/${id}/vorrat`, null, { params: { vorrat } }),
  deleteGetraenk: (id) => api.delete(`/getraenke/${id}`),
};

// Zahlung Services
export const zahlungService = {
  processZahlung: (bestellungId, zahlungData) => api.post(`/zahlungen/${bestellungId}`, zahlungData),
  getZahlungStatus: (bestellungId) => api.get(`/zahlungen/${bestellungId}`),
};

export default api;
EOL

# Redux-Store erstellen
cat > "$FRONTEND_DIR/src/store/index.js" << 'EOL'
import { configureStore, combineReducers } from '@reduxjs/toolkit';
import {
  persistStore,
  persistReducer,
  FLUSH,
  REHYDRATE,
  PAUSE,
  PERSIST,
  PURGE,
  REGISTER,
} from 'redux-persist';
import storage from 'redux-persist/lib/storage';

import authReducer from './auth/authSlice';
import cartReducer from './cart/cartSlice';
import menuReducer from './menu/menuSlice';

const persistConfig = {
  key: 'root',
  version: 1,
  storage,
  whitelist: ['auth', 'cart'], // nur auth und cart werden persistiert
};

const rootReducer = combineReducers({
  auth: authReducer,
  cart: cartReducer,
  menu: menuReducer,
});

const persistedReducer = persistReducer(persistConfig, rootReducer);

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
});

export const persistor = persistStore(store);
EOL

# Auth Slice
mkdir -p "$FRONTEND_DIR/src/store/auth"
cat > "$FRONTEND_DIR/src/store/auth/authSlice.js" << 'EOL'
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  isLoggedIn: false,
  user: null,
  token: null,
  error: null,
  loading: false,
  mfaRequired: false,
  mfaEmail: null,
  mfaPassword: null,
};

export const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    loginStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    loginSuccess: (state, action) => {
      state.isLoggedIn = true;
      state.user = {
        id: action.payload.id,
        email: action.payload.email,
        vorname: action.payload.vorname,
        nachname: action.payload.nachname,
        roles: action.payload.roles,
      };
      state.token = action.payload.token;
      state.loading = false;
      state.error = null;
      state.mfaRequired = false;
      state.mfaEmail = null;
      state.mfaPassword = null;
    },
    loginError: (state, action) => {
      state.isLoggedIn = false;
      state.user = null;
      state.token = null;
      state.loading = false;
      state.error = action.payload;
      state.mfaRequired = false;
    },
    logout: (state) => {
      state.isLoggedIn = false;
      state.user = null;
      state.token = null;
      state.error = null;
      state.loading = false;
      state.mfaRequired = false;
      state.mfaEmail = null;
      state.mfaPassword = null;
    },
    registerStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    registerSuccess: (state) => {
      state.loading = false;
      state.error = null;
    },
    registerError: (state, action) => {
      state.loading = false;
      state.error = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
    requireMfa: (state, action) => {
      state.mfaRequired = true;
      state.mfaEmail = action.payload.email;
      state.mfaPassword = action.payload.password;
      state.loading = false;
    },
    updateUser: (state, action) => {
      state.user = {
        ...state.user,
        ...action.payload,
      };
    },
  },
});

export const {
  loginStart,
  loginSuccess,
  loginError,
  logout,
  registerStart,
  registerSuccess,
  registerError,
  clearError,
  requireMfa,
  updateUser,
} = authSlice.actions;

export default authSlice.reducer;
EOL

cat > "$FRONTEND_DIR/src/store/auth/authActions.js" << 'EOL'
import { toast } from 'react-toastify';
import { jwtDecode } from 'jwt-decode';
import { authService, userService } from '../../services/api';
import {
  loginStart,
  loginSuccess,
  loginError,
  logout,
  registerStart,
  registerSuccess,
  registerError,
  requireMfa,
  updateUser,
} from './authSlice';

// Login Action
export const login = (email, password) => async (dispatch) => {
  dispatch(loginStart());
  try {
    const response = await authService.login(email, password);
    if (response.data.mfaRequired) {
      dispatch(requireMfa({ email, password }));
    } else {
      dispatch(loginSuccess(response.data));
      toast.success('Erfolgreich angemeldet!');
    }
  } catch (error) {
    const message = error.response?.data?.message || 'Anmeldung fehlgeschlagen';
    dispatch(loginError(message));
    toast.error(message);
  }
};

// Verify MFA Code Action
export const verifyMfa = (email, password, code) => async (dispatch) => {
  dispatch(loginStart());
  try {
    const response = await authService.verifyMfa(email, password, code);
    dispatch(loginSuccess(response.data));
    toast.success('Erfolgreich angemeldet!');
  } catch (error) {
    const message = error.response?.data?.message || 'MFA-Verifizierung fehlgeschlagen';
    dispatch(loginError(message));
    toast.error(message);
  }
};

// Register Action
export const register = (userData) => async (dispatch) => {
  dispatch(registerStart());
  try {
    const response = await authService.register(userData);
    dispatch(registerSuccess());
    toast.success(response.data.message || 'Registrierung erfolgreich. Bitte melden Sie sich an.');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Registrierung fehlgeschlagen';
    dispatch(registerError(message));
    toast.error(message);
    return false;
  }
};

// Logout Action
export const logoutUser = () => (dispatch) => {
  dispatch(logout());
  toast.info('Sie wurden abgemeldet');
};

// Check Token Expiration
export const checkTokenExpiration = () => (dispatch, getState) => {
  const { token } = getState().auth;
  if (token) {
    try {
      const decodedToken = jwtDecode(token);
      const currentTime = Date.now() / 1000;
      
      if (decodedToken.exp < currentTime) {
        dispatch(logout());
        toast.info('Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.');
      }
    } catch (error) {
      dispatch(logout());
    }
  }
};

// Update Profile
export const updateProfile = (userData) => async (dispatch) => {
  try {
    const response = await userService.updateProfile(userData);
    dispatch(updateUser(response.data));
    toast.success('Profil erfolgreich aktualisiert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Profils';
    toast.error(message);
    return false;
  }
};

// Update Password
export const updatePassword = (passwordData) => async (dispatch) => {
  try {
    await userService.updatePassword(passwordData);
    toast.success('Passwort erfolgreich aktualisiert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Passworts';
    toast.error(message);
    return false;
  }
};

// Setup MFA
export const setupMfa = (email) => async () => {
  try {
    const response = await authService.setupMfa({ email });
    return response.data;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Einrichten der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    throw error;
  }
};

// Enable MFA
export const enableMfa = (email, code) => async (dispatch) => {
  try {
    await authService.enableMfa({ email, code });
    dispatch(updateUser({ mfaEnabled: true }));
    toast.success('Zwei-Faktor-Authentifizierung erfolgreich aktiviert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Aktivieren der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    return false;
  }
};

// Disable MFA
export const disableMfa = (email, code) => async (dispatch) => {
  try {
    await authService.disableMfa({ email, code });
    dispatch(updateUser({ mfaEnabled: false }));
    toast.success('Zwei-Faktor-Authentifizierung erfolgreich deaktiviert');
    return true;
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Deaktivieren der Zwei-Faktor-Authentifizierung';
    toast.error(message);
    return false;
  }
};
EOL

# Cart Slice
mkdir -p "$FRONTEND_DIR/src/store/cart"
cat > "$FRONTEND_DIR/src/store/cart/cartSlice.js" << 'EOL'
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  items: [],
  abholDatum: null,
  abholZeit: null,
  bemerkungen: '',
};

export const cartSlice = createSlice({
  name: 'cart',
  initialState,
  reducers: {
    addToCart: (state, action) => {
      const { gericht, anzahl } = action.payload;
      const existingItemIndex = state.items.findIndex(item => item.gericht.id === gericht.id);
      
      if (existingItemIndex !== -1) {
        // Wenn das Gericht bereits im Warenkorb ist, erhöhe die Anzahl
        state.items[existingItemIndex].anzahl += anzahl;
      } else {
        // Füge ein neues Gericht hinzu
        state.items.push({ gericht, anzahl });
      }
    },
    removeFromCart: (state, action) => {
      const gerichtId = action.payload;
      state.items = state.items.filter(item => item.gericht.id !== gerichtId);
    },
    updateCartItemQuantity: (state, action) => {
      const { gerichtId, anzahl } = action.payload;
      const existingItem = state.items.find(item => item.gericht.id === gerichtId);
      
      if (existingItem) {
        existingItem.anzahl = anzahl;
      }
    },
    setAbholDatum: (state, action) => {
      state.abholDatum = action.payload;
    },
    setAbholZeit: (state, action) => {
      state.abholZeit = action.payload;
    },
    setBemerkungen: (state, action) => {
      state.bemerkungen = action.payload;
    },
    clearCart: (state) => {
      state.items = [];
      state.abholDatum = null;
      state.abholZeit = null;
      state.bemerkungen = '';
    },
  },
});

export const {
  addToCart,
  removeFromCart,
  updateCartItemQuantity,
  setAbholDatum,
  setAbholZeit,
  setBemerkungen,
  clearCart,
} = cartSlice.actions;

// Selektoren
export const selectCartItems = (state) => state.cart.items;
export const selectCartItemsCount = (state) => state.cart.items.reduce((count, item) => count + item.anzahl, 0);
export const selectCartTotal = (state) => state.cart.items.reduce(
  (total, item) => total + (item.gericht.preis * item.anzahl), 0
);
export const selectAbholDatum = (state) => state.cart.abholDatum;
export const selectAbholZeit = (state) => state.cart.abholZeit;
export const selectBemerkungen = (state) => state.cart.bemerkungen;

export default cartSlice.reducer;
EOL

# Menu Slice
mkdir -p "$FRONTEND_DIR/src/store/menu"
cat > "$FRONTEND_DIR/src/store/menu/menuSlice.js" << 'EOL'
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  menuplan: null,
  weeklyMenus: [],
  dishes: [],
  selectedDate: null,
  loading: false,
  error: null,
};

export const menuSlice = createSlice({
  name: 'menu',
  initialState,
  reducers: {
    fetchMenuStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    fetchMenuSuccess: (state, action) => {
      state.menuplan = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchWeeklyMenusSuccess: (state, action) => {
      state.weeklyMenus = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchDishesSuccess: (state, action) => {
      state.dishes = action.payload;
      state.loading = false;
      state.error = null;
    },
    fetchMenuError: (state, action) => {
      state.loading = false;
      state.error = action.payload;
    },
    setSelectedDate: (state, action) => {
      state.selectedDate = action.payload;
    },
    clearMenus: (state) => {
      state.menuplan = null;
      state.weeklyMenus = [];
      state.dishes = [];
      state.selectedDate = null;
    },
  },
});

export const {
  fetchMenuStart,
  fetchMenuSuccess,
  fetchWeeklyMenusSuccess,
  fetchDishesSuccess,
  fetchMenuError,
  setSelectedDate,
  clearMenus,
} = menuSlice.actions;

export default menuSlice.reducer;
EOL

cat > "$FRONTEND_DIR/src/store/menu/menuActions.js" << 'EOL'
import { toast } from 'react-toastify';
import { menuService } from '../../services/api';
import {
  fetchMenuStart,
  fetchMenuSuccess,
  fetchWeeklyMenusSuccess,
  fetchDishesSuccess,
  fetchMenuError,
  setSelectedDate,
} from './menuSlice';

// Fetch Today's Menu
export const fetchTodayMenu = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuToday();
    dispatch(fetchMenuSuccess(response.data));
    dispatch(setSelectedDate(response.data.datum));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden des Menüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Menu by Date
export const fetchMenuByDate = (date) => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuByDate(date);
    dispatch(fetchMenuSuccess(response.data));
    dispatch(setSelectedDate(date));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden des Menüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Weekly Menu
export const fetchWeeklyMenu = (startDate) => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getMenuForWeek(startDate);
    dispatch(fetchWeeklyMenusSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der Wochenmenüs';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch All Dishes
export const fetchAllDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getAllDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Vegetarian Dishes
export const fetchVegetarianDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getVegetarianDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der vegetarischen Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};

// Fetch Vegan Dishes
export const fetchVeganDishes = () => async (dispatch) => {
  dispatch(fetchMenuStart());
  try {
    const response = await menuService.getVeganDishes();
    dispatch(fetchDishesSuccess(response.data));
  } catch (error) {
    const message = error.response?.data?.message || 'Fehler beim Laden der veganen Gerichte';
    dispatch(fetchMenuError(message));
    toast.error(message);
  }
};
EOL

# Komponenten erstellen
mkdir -p "$FRONTEND_DIR/src/components/layout"
mkdir -p "$FRONTEND_DIR/src/components/menu"
mkdir -p "$FRONTEND_DIR/src/components/auth"
mkdir -p "$FRONTEND_DIR/src/components/cart"
mkdir -p "$FRONTEND_DIR/src/components/orders"
mkdir -p "$FRONTEND_DIR/src/components/admin"
mkdir -p "$FRONTEND_DIR/src/components/common"

# Layout Komponenten
cat > "$FRONTEND_DIR/src/layouts/MainLayout.js" << 'EOL'
import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { useSelector } from 'react-redux';
import {
  AppBar,
  Box,
  Toolbar,
  IconButton,
  Typography,
  Container,
  Avatar,
  Button,
  Menu,
  MenuItem,
  Badge,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Divider,
} from '@mui/material';
import {
  Menu as MenuIcon,
  AccountCircle,
  ShoppingCart,
  Restaurant,
  Home,
  ListAlt,
  Person,
  Login,
  Logout,
  AdminPanelSettings,
} from '@mui/icons-material';
import { Link as RouterLink, useNavigate } from 'react-router-dom';
import { selectCartItemsCount } from '../store/cart/cartSlice';
import { logoutUser } from '../store/auth/authActions';
import { useDispatch } from 'react-redux';

const MainLayout = () => {
  const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
  const user = useSelector(state => state.auth.user);
  const cartItemsCount = useSelector(selectCartItemsCount);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [anchorEl, setAnchorEl] = useState(null);
  const [drawerOpen, setDrawerOpen] = useState(false);

  // Check if user has admin or staff role
  const isAdminOrStaff = user && user.roles && 
    (user.roles.includes('ROLE_ADMIN') || user.roles.includes('ROLE_STAFF'));

  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleDrawerToggle = () => {
    setDrawerOpen(!drawerOpen);
  };

  const handleLogout = () => {
    dispatch(logoutUser());
    handleMenuClose();
    navigate('/');
  };

  const handleCartClick = () => {
    if (isLoggedIn) {
      navigate('/checkout');
    } else {
      navigate('/login', { state: { from: '/checkout' } });
    }
  };

  const navItems = [
    { text: 'Startseite', icon: <Home />, path: '/' },
    { text: 'Menüplan', icon: <Restaurant />, path: '/menu' },
  ];

  const authItems = isLoggedIn
    ? [
        { text: 'Meine Bestellungen', icon: <ListAlt />, path: '/orders' },
        { text: 'Mein Profil', icon: <Person />, path: '/profile' },
        ...(isAdminOrStaff ? [{ text: 'Admin-Bereich', icon: <AdminPanelSettings />, path: '/admin' }] : []),
      ]
    : [
        { text: 'Anmelden', icon: <Login />, path: '/login' },
        { text: 'Registrieren', icon: <AccountCircle />, path: '/register' },
      ];

  const drawer = (
    <Box sx={{ width: 250 }} role="presentation" onClick={handleDrawerToggle}>
      <List>
        {navItems.map((item) => (
          <ListItem button key={item.text} component={RouterLink} to={item.path}>
            <ListItemIcon>{item.icon}</ListItemIcon>
            <ListItemText primary={item.text} />
          </ListItem>
        ))}
      </List>
      <Divider />
      <List>
        {authItems.map((item) => (
          <ListItem button key={item.text} component={RouterLink} to={item.path}>
            <ListItemIcon>{item.icon}</ListItemIcon>
            <ListItemText primary={item.text} />
          </ListItem>
        ))}
        {isLoggedIn && (
          <ListItem button onClick={handleLogout}>
            <ListItemIcon><Logout /></ListItemIcon>
            <ListItemText primary="Abmelden" />
          </ListItem>
        )}
      </List>
    </Box>
  );

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      <AppBar position="static">
        <Toolbar>
          <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="menu"
            sx={{ mr: 2 }}
            onClick={handleDrawerToggle}
          >
            <MenuIcon />
          </IconButton>
          <Typography
            variant="h6"
            component={RouterLink}
            to="/"
            sx={{ 
              flexGrow: 1, 
              textDecoration: 'none', 
              color: 'inherit',
              display: { xs: 'none', sm: 'block' } 
            }}
          >
            Mensa App
          </Typography>
          
          <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
            {navItems.map((item) => (
              <Button
                key={item.text}
                component={RouterLink}
                to={item.path}
                sx={{ color: 'white', mx: 1 }}
              >
                {item.text}
              </Button>
            ))}
          </Box>
          
          <IconButton
            size="large"
            color="inherit"
            onClick={handleCartClick}
            sx={{ ml: 1 }}
          >
            <Badge badgeContent={cartItemsCount} color="error">
              <ShoppingCart />
            </Badge>
          </IconButton>
          
          {isLoggedIn ? (
            <>
              <IconButton
                size="large"
                edge="end"
                aria-label="account of current user"
                aria-haspopup="true"
                onClick={handleProfileMenuOpen}
                color="inherit"
                sx={{ ml: 1 }}
              >
                <Avatar sx={{ width: 32, height: 32, bgcolor: 'secondary.main' }}>
                  {user.vorname ? user.vorname[0] : 'U'}
                </Avatar>
              </IconButton>
              <Menu
                anchorEl={anchorEl}
                anchorOrigin={{
                  vertical: 'bottom',
                  horizontal: 'right',
                }}
                keepMounted
                transformOrigin={{
                  vertical: 'top',
                  horizontal: 'right',
                }}
                open={Boolean(anchorEl)}
                onClose={handleMenuClose}
              >
                <MenuItem component={RouterLink} to="/profile" onClick={handleMenuClose}>
                  Mein Profil
                </MenuItem>
                <MenuItem component={RouterLink} to="/orders" onClick={handleMenuClose}>
                  Meine Bestellungen
                </MenuItem>
                {isAdminOrStaff && (
                  <MenuItem component={RouterLink} to="/admin" onClick={handleMenuClose}>
                    Admin-Bereich
                  </MenuItem>
                )}
                <MenuItem onClick={handleLogout}>Abmelden</MenuItem>
              </Menu>
            </>
          ) : (
            <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
              <Button
                component={RouterLink}
                to="/login"
                color="inherit"
                sx={{ ml: 1 }}
              >
                Anmelden
              </Button>
              <Button
                component={RouterLink}
                to="/register"
                color="inherit"
                variant="outlined"
                sx={{ ml: 1 }}
              >
                Registrieren
              </Button>
            </Box>
          )}
        </Toolbar>
      </AppBar>
      
      <Drawer
        anchor="left"
        open={drawerOpen}
        onClose={handleDrawerToggle}
      >
        {drawer}
      </Drawer>
      
      <Container component="main" sx={{ mt: 4, mb: 4, flexGrow: 1 }}>
        <Outlet />
      </Container>
      
      <Box
        component="footer"
        sx={{
          py: 3,
          px: 2,
          mt: 'auto',
          backgroundColor: (theme) => theme.palette.grey[200],
        }}
      >
        <Container maxWidth="lg">
          <Typography variant="body2" color="text.secondary" align="center">
            © {new Date().getFullYear()} Mensa App. Alle Rechte vorbehalten.
          </Typography>
        </Container>
      </Box>
    </Box>
  );
};

export default MainLayout;
EOL

cat > "$FRONTEND_DIR/src/layouts/AdminLayout.js" << 'EOL'
import React, { useState } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import {
  AppBar,
  Box,
  CssBaseline,
  Divider,
  Drawer,
  IconButton,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
  Typography,
  Avatar,
  Menu,
  MenuItem,
} from '@mui/material';
import {
  Menu as MenuIcon,
  Restaurant as RestaurantIcon,
  Dashboard as DashboardIcon,
  People as PeopleIcon,
  LocalDining as LocalDiningIcon,
  Receipt as ReceiptIcon,
  LocalBar as LocalBarIcon,
  ExitToApp as ExitToAppIcon,
} from '@mui/icons-material';
import { Link as RouterLink } from 'react-router-dom';
import { logoutUser } from '../store/auth/authActions';

const drawerWidth = 240;

const AdminLayout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const user = useSelector(state => state.auth.user);
  const isAdmin = user && user.roles && user.roles.includes('ROLE_ADMIN');
  
  const [mobileOpen, setMobileOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = () => {
    dispatch(logoutUser());
    navigate('/');
  };

  const handleBackToMain = () => {
    navigate('/');
  };

  const adminMenuItems = [
    { text: 'Dashboard', icon: <DashboardIcon />, path: '/admin' },
    { text: 'Bestellungen', icon: <ReceiptIcon />, path: '/admin/orders' },
    { text: 'Menüpläne', icon: <RestaurantIcon />, path: '/admin/menus' },
    { text: 'Gerichte', icon: <LocalDiningIcon />, path: '/admin/dishes' },
    { text: 'Getränke', icon: <LocalBarIcon />, path: '/admin/drinks' },
  ];

  // Nur für Admin: Benutzerverwaltung
  if (isAdmin) {
    adminMenuItems.push(
      { text: 'Benutzer', icon: <PeopleIcon />, path: '/admin/users' }
    );
  }

  const drawer = (
    <div>
      <Toolbar>
        <Typography variant="h6" noWrap component="div">
          Admin-Bereich
        </Typography>
      </Toolbar>
      <Divider />
      <List>
        {adminMenuItems.map((item) => (
          <ListItem key={item.text} disablePadding>
            <ListItemButton component={RouterLink} to={item.path}>
              <ListItemIcon>
                {item.icon}
              </ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
      <Divider />
      <List>
        <ListItem disablePadding>
          <ListItemButton onClick={handleBackToMain}>
            <ListItemIcon>
              <ExitToAppIcon />
            </ListItemIcon>
            <ListItemText primary="Zurück zur App" />
          </ListItemButton>
        </ListItem>
      </List>
    </div>
  );

  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
        }}
      >
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: 'none' } }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap component="div" sx={{ flexGrow: 1 }}>
            Mensa Admin
          </Typography>
          <IconButton
            size="large"
            edge="end"
            aria-label="account of current user"
            aria-haspopup="true"
            onClick={handleProfileMenuOpen}
            color="inherit"
          >
            <Avatar sx={{ width: 32, height: 32, bgcolor: 'secondary.main' }}>
              {user?.vorname ? user.vorname[0] : 'A'}
            </Avatar>
          </IconButton>
          <Menu
            anchorEl={anchorEl}
            anchorOrigin={{
              vertical: 'bottom',
              horizontal: 'right',
            }}
            keepMounted
            transformOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
          >
            <MenuItem onClick={handleLogout}>Abmelden</MenuItem>
          </Menu>
        </Toolbar>
      </AppBar>
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
        aria-label="mailbox folders"
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true, // Better open performance on mobile.
          }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      <Box
        component="main"
        sx={{ flexGrow: 1, p: 3, width: { sm: `calc(100% - ${drawerWidth}px)` } }}
      >
        <Toolbar />
        <Outlet />
      </Box>
    </Box>
  );
};

export default AdminLayout;
EOL

# Common components
cat > "$FRONTEND_DIR/src/components/common/Loading.js" << 'EOL'
import React from 'react';
import { Box, CircularProgress, Typography } from '@mui/material';

const Loading = ({ message = 'Wird geladen...' }) => {
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        py: 4,
      }}
    >
      <CircularProgress size={60} thickness={4} />
      <Typography variant="h6" sx={{ mt: 2 }}>
        {message}
      </Typography>
    </Box>
  );
};

export default Loading;
EOL

cat > "$FRONTEND_DIR/src/components/common/ErrorMessage.js" << 'EOL'
import React from 'react';
import { Box, Alert, Typography, Button } from '@mui/material';
import { Refresh as RefreshIcon } from '@mui/icons-material';

const ErrorMessage = ({ message, onRetry }) => {
  return (
    <Box sx={{ my: 4 }}>
      <Alert severity="error" sx={{ mb: 2 }}>
        <Typography variant="body1">
          {message || 'Ein Fehler ist aufgetreten.'}
        </Typography>
      </Alert>
      {onRetry && (
        <Button
          variant="outlined"
          color="primary"
          startIcon={<RefreshIcon />}
          onClick={onRetry}
        >
          Erneut versuchen
        </Button>
      )}
    </Box>
  );
};

export default ErrorMessage;
EOL

cat > "$FRONTEND_DIR/src/components/common/PageTitle.js" << 'EOL'
import React from 'react';
import { Typography, Box, Divider } from '@mui/material';

const PageTitle = ({ title, subtitle, children }) => {
  return (
    <Box sx={{ mb: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        {title}
      </Typography>
      {subtitle && (
        <Typography variant="subtitle1" color="text.secondary" paragraph>
          {subtitle}
        </Typography>
      )}
      {children}
      <Divider sx={{ mt: 2 }} />
    </Box>
  );
};

export default PageTitle;
EOL

cat > "$FRONTEND_DIR/src/components/common/ConfirmDialog.js" << 'EOL'
import React from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
  Button,
} from '@mui/material';

const ConfirmDialog = ({
  open,
  title,
  message,
  confirmText = 'Bestätigen',
  cancelText = 'Abbrechen',
  onConfirm,
  onCancel,
  confirmButtonProps = {},
}) => {
  return (
    <Dialog
      open={open}
      onClose={onCancel}
      aria-labelledby="confirm-dialog-title"
      aria-describedby="confirm-dialog-description"
    >
      <DialogTitle id="confirm-dialog-title">{title}</DialogTitle>
      <DialogContent>
        <DialogContentText id="confirm-dialog-description">
          {message}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={onCancel} color="primary">
          {cancelText}
        </Button>
        <Button 
          onClick={onConfirm} 
          color="primary" 
          variant="contained" 
          autoFocus
          {...confirmButtonProps}
        >
          {confirmText}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default ConfirmDialog;
EOL

cat > "$FRONTEND_DIR/src/components/common/EmptyState.js" << 'EOL'
import React from 'react';
import { Box, Typography, Button } from '@mui/material';

const EmptyState = ({
  title,
  message,
  actionText,
  actionIcon,
  onAction,
  icon: Icon,
}) => {
  return (
    <Box
      sx={{
        textAlign: 'center',
        py: 6,
        px: 2,
        my: 4,
        borderRadius: 2,
        bgcolor: 'background.paper',
        boxShadow: 1,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
      }}
    >
      {Icon && <Icon sx={{ fontSize: 80, color: 'text.secondary', mb: 2 }} />}
      <Typography variant="h5" component="h2" gutterBottom>
        {title}
      </Typography>
      <Typography variant="body1" color="text.secondary" paragraph>
        {message}
      </Typography>
      {actionText && onAction && (
        <Button
          variant="contained"
          color="primary"
          onClick={onAction}
          startIcon={actionIcon}
          sx={{ mt: 2 }}
        >
          {actionText}
        </Button>
      )}
    </Box>
  );
};

export default EmptyState;
EOL

# Auth Komponenten
cat > "$FRONTEND_DIR/src/components/auth/LoginForm.js" << 'EOL'
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Link,
  Typography,
  InputAdornment,
  IconButton,
  CircularProgress,
} from '@mui/material';
import { Visibility, VisibilityOff } from '@mui/icons-material';
import { login } from '../../store/auth/authActions';
import MfaVerificationForm from './MfaVerificationForm';

const LoginSchema = Yup.object().shape({
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
  password: Yup.string()
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .required('Passwort ist erforderlich'),
});

const LoginForm = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const { loading, error, mfaRequired, mfaEmail, mfaPassword } = useSelector(state => state.auth);
  const [showPassword, setShowPassword] = useState(false);

  const from = location.state?.from || '/';

  const handleSubmit = (values) => {
    dispatch(login(values.email, values.password));
  };

  const handleMfaSuccess = () => {
    navigate(from, { replace: true });
  };

  const handlePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  if (mfaRequired) {
    return <MfaVerificationForm 
      email={mfaEmail} 
      password={mfaPassword} 
      onSuccess={handleMfaSuccess} 
    />;
  }

  return (
    <Formik
      initialValues={{
        email: '',
        password: '',
      }}
      validationSchema={LoginSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched }) => (
        <Form>
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="email"
                name="email"
                label="E-Mail"
                variant="outlined"
                error={touched.email && Boolean(errors.email)}
                helperText={touched.email && errors.email}
              />
            </Grid>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="password"
                name="password"
                label="Passwort"
                type={showPassword ? 'text' : 'password'}
                variant="outlined"
                error={touched.password && Boolean(errors.password)}
                helperText={touched.password && errors.password}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="toggle password visibility"
                        onClick={handlePasswordVisibility}
                        edge="end"
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
            </Grid>
            {error && (
              <Grid item xs={12}>
                <Typography color="error">{error}</Typography>
              </Grid>
            )}
            <Grid item xs={12}>
              <Button
                type="submit"
                fullWidth
                variant="contained"
                color="primary"
                disabled={loading}
                sx={{ py: 1.5 }}
                startIcon={loading && <CircularProgress size={20} color="inherit" />}
              >
                {loading ? 'Anmeldung...' : 'Anmelden'}
              </Button>
            </Grid>
            <Grid item xs={12} container justifyContent="space-between">
              <Grid item>
                <Link href="#" variant="body2" color="primary">
                  Passwort vergessen?
                </Link>
              </Grid>
              <Grid item>
                <Link href="/register" variant="body2" color="primary">
                  Kein Konto? Registrieren
                </Link>
              </Grid>
            </Grid>
          </Grid>
        </Form>
      )}
    </Formik>
  );
};

export default LoginForm;
EOL

cat > "$FRONTEND_DIR/src/components/auth/MfaVerificationForm.js" << 'EOL'
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Typography,
  CircularProgress,
  Paper,
} from '@mui/material';
import { verifyMfa } from '../../store/auth/authActions';

const MfaVerificationSchema = Yup.object().shape({
  code: Yup.string()
    .matches(/^\d{6}$/, 'Code muss 6 Ziffern enthalten')
    .required('Code ist erforderlich'),
});

const MfaVerificationForm = ({ email, password, onSuccess }) => {
  const dispatch = useDispatch();
  const { loading, error } = useSelector(state => state.auth);

  const handleSubmit = async (values) => {
    const result = await dispatch(verifyMfa(email, password, values.code));
    if (result?.type === 'auth/loginSuccess' && onSuccess) {
      onSuccess();
    }
  };

  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h5" gutterBottom align="center">
        Zwei-Faktor-Authentifizierung
      </Typography>
      <Typography variant="body1" paragraph>
        Bitte geben Sie den 6-stelligen Code aus Ihrer Authenticator-App ein.
      </Typography>
      
      <Formik
        initialValues={{
          code: '',
        }}
        validationSchema={MfaVerificationSchema}
        onSubmit={handleSubmit}
      >
        {({ errors, touched }) => (
          <Form>
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="code"
                  name="code"
                  label="Authentifizierungscode"
                  variant="outlined"
                  error={touched.code && Boolean(errors.code)}
                  helperText={touched.code && errors.code}
                  autoComplete="off"
                  inputProps={{ maxLength: 6 }}
                  placeholder="6-stelligen Code eingeben"
                />
              </Grid>
              {error && (
                <Grid item xs={12}>
                  <Typography color="error">{error}</Typography>
                </Grid>
              )}
              <Grid item xs={12}>
                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  color="primary"
                  disabled={loading}
                  sx={{ py: 1.5 }}
                  startIcon={loading && <CircularProgress size={20} color="inherit" />}
                >
                  {loading ? 'Überprüfung...' : 'Verifizieren'}
                </Button>
              </Grid>
            </Grid>
          </Form>
        )}
      </Formik>
    </Paper>
  );
};

export default MfaVerificationForm;
EOL

cat > "$FRONTEND_DIR/src/components/auth/RegisterForm.js" << 'EOL'
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Link,
  Typography,
  InputAdornment,
  IconButton,
  CircularProgress,
} from '@mui/material';
import { Visibility, VisibilityOff } from '@mui/icons-material';
import { register } from '../../store/auth/authActions';

const RegisterSchema = Yup.object().shape({
  vorname: Yup.string()
    .min(2, 'Vorname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Vorname darf maximal 50 Zeichen lang sein')
    .required('Vorname ist erforderlich'),
  nachname: Yup.string()
    .min(2, 'Nachname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Nachname darf maximal 50 Zeichen lang sein')
    .required('Nachname ist erforderlich'),
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
  password: Yup.string()
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .matches(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Passwort muss mindestens einen Grossbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten'
    )
    .required('Passwort ist erforderlich'),
  confirmPassword: Yup.string()
    .oneOf([Yup.ref('password'), null], 'Passwörter müssen übereinstimmen')
    .required('Passwortbestätigung ist erforderlich'),
});

const RegisterForm = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { loading, error } = useSelector(state => state.auth);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleSubmit = async (values, { resetForm }) => {
    const userData = {
      vorname: values.vorname,
      nachname: values.nachname,
      email: values.email,
      password: values.password,
    };

    const result = await dispatch(register(userData));
    if (result) {
      resetForm();
      navigate('/login');
    }
  };

  const handlePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const handleConfirmPasswordVisibility = () => {
    setShowConfirmPassword(!showConfirmPassword);
  };

  return (
    <Formik
      initialValues={{
        vorname: '',
        nachname: '',
        email: '',
        password: '',
        confirmPassword: '',
      }}
      validationSchema={RegisterSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched }) => (
        <Form>
          <Grid container spacing={3}>
            <Grid item xs={12} sm={6}>
              <Field
                as={TextField}
                fullWidth
                id="vorname"
                name="vorname"
                label="Vorname"
                variant="outlined"
                error={touched.vorname && Boolean(errors.vorname)}
                helperText={touched.vorname && errors.vorname}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <Field
                as={TextField}
                fullWidth
                id="nachname"
                name="nachname"
                label="Nachname"
                variant="outlined"
                error={touched.nachname && Boolean(errors.nachname)}
                helperText={touched.nachname && errors.nachname}
              />
            </Grid>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="email"
                name="email"
                label="E-Mail"
                variant="outlined"
                error={touched.email && Boolean(errors.email)}
                helperText={touched.email && errors.email}
              />
            </Grid>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="password"
                name="password"
                label="Passwort"
                type={showPassword ? 'text' : 'password'}
                variant="outlined"
                error={touched.password && Boolean(errors.password)}
                helperText={touched.password && errors.password}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="toggle password visibility"
                        onClick={handlePasswordVisibility}
                        edge="end"
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
            </Grid>
            <Grid item xs={12}>
              <Field
                as={TextField}
                fullWidth
                id="confirmPassword"
                name="confirmPassword"
                label="Passwort bestätigen"
                type={showConfirmPassword ? 'text' : 'password'}
                variant="outlined"
                error={touched.confirmPassword && Boolean(errors.confirmPassword)}
                helperText={touched.confirmPassword && errors.confirmPassword}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="toggle password visibility"
                        onClick={handleConfirmPasswordVisibility}
                        edge="end"
                      >
                        {showConfirmPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
              />
            </Grid>
            {error && (
              <Grid item xs={12}>
                <Typography color="error">{error}</Typography>
              </Grid>
            )}
            <Grid item xs={12}>
              <Button
                type="submit"
                fullWidth
                variant="contained"
                color="primary"
                disabled={loading}
                sx={{ py: 1.5 }}
                startIcon={loading && <CircularProgress size={20} color="inherit" />}
              >
                {loading ? 'Registrierung...' : 'Registrieren'}
              </Button>
            </Grid>
            <Grid item xs={12} container justifyContent="center">
              <Grid item>
                <Link href="/login" variant="body2" color="primary">
                  Bereits ein Konto? Anmelden
                </Link>
              </Grid>
            </Grid>
          </Grid>
        </Form>
      )}
    </Formik>
  );
};

export default RegisterForm;
EOL

cat > "$FRONTEND_DIR/src/components/auth/MfaSetupForm.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Typography,
  CircularProgress,
  Paper,
  Box,
  Link,
  Stepper,
  Step,
  StepLabel,
} from '@mui/material';
import { setupMfa, enableMfa, disableMfa } from '../../store/auth/authActions';

const MfaCodeSchema = Yup.object().shape({
  code: Yup.string()
    .matches(/^\d{6}$/, 'Code muss 6 Ziffern enthalten')
    .required('Code ist erforderlich'),
});

const MfaSetupForm = () => {
  const dispatch = useDispatch();
  const { user } = useSelector(state => state.auth);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [qrCodeUrl, setQrCodeUrl] = useState('');
  const [secret, setSecret] = useState('');
  const [activeStep, setActiveStep] = useState(0);
  const [mfaEnabled, setMfaEnabled] = useState(user?.mfaEnabled || false);

  useEffect(() => {
    if (user) {
      setMfaEnabled(user.mfaEnabled);
    }
  }, [user]);

  const steps = mfaEnabled
    ? ['MFA deaktivieren']
    : ['QR-Code scannen', 'Code verifizieren'];

  const handleSetup = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await dispatch(setupMfa(user.email));
      setQrCodeUrl(response.qrCodeUrl);
      setSecret(response.secret);
      setActiveStep(1);
    } catch (error) {
      setError('Fehler beim Einrichten der Zwei-Faktor-Authentifizierung');
    } finally {
      setLoading(false);
    }
  };

  const handleEnableMfa = async (values) => {
    setLoading(true);
    setError(null);
    try {
      const result = await dispatch(enableMfa(user.email, values.code));
      if (result) {
        setMfaEnabled(true);
        setActiveStep(0);
      } else {
        setError('Ungültiger Code');
      }
    } catch (error) {
      setError('Fehler beim Aktivieren der Zwei-Faktor-Authentifizierung');
    } finally {
      setLoading(false);
    }
  };

  const handleDisableMfa = async (values) => {
    setLoading(true);
    setError(null);
    try {
      const result = await dispatch(disableMfa(user.email, values.code));
      if (result) {
        setMfaEnabled(false);
      } else {
        setError('Ungültiger Code');
      }
    } catch (error) {
      setError('Fehler beim Deaktivieren der Zwei-Faktor-Authentifizierung');
    } finally {
      setLoading(false);
    }
  };

  const renderStepContent = (step) => {
    if (mfaEnabled) {
      return (
        <Formik
          initialValues={{ code: '' }}
          validationSchema={MfaCodeSchema}
          onSubmit={handleDisableMfa}
        >
          {({ errors, touched }) => (
            <Form>
              <Typography variant="body1" paragraph>
                Um die Zwei-Faktor-Authentifizierung zu deaktivieren, geben Sie bitte den aktuellen Code aus Ihrer Authenticator-App ein.
              </Typography>
              <Grid container spacing={3}>
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="code"
                    name="code"
                    label="Authentifizierungscode"
                    variant="outlined"
                    error={touched.code && Boolean(errors.code)}
                    helperText={touched.code && errors.code}
                    autoComplete="off"
                    inputProps={{ maxLength: 6 }}
                  />
                </Grid>
                {error && (
                  <Grid item xs={12}>
                    <Typography color="error">{error}</Typography>
                  </Grid>
                )}
                <Grid item xs={12}>
                  <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    color="secondary"
                    disabled={loading}
                    sx={{ py: 1.5 }}
                    startIcon={loading && <CircularProgress size={20} color="inherit" />}
                  >
                    {loading ? 'Wird deaktiviert...' : 'MFA deaktivieren'}
                  </Button>
                </Grid>
              </Grid>
            </Form>
          )}
        </Formik>
      );
    }

    switch (step) {
      case 0:
        return (
          <Box sx={{ textAlign: 'center' }}>
            <Typography variant="body1" paragraph>
              Die Zwei-Faktor-Authentifizierung erhöht die Sicherheit Ihres Kontos. Sobald aktiviert, müssen Sie bei jeder Anmeldung einen Code aus einer Authenticator-App eingeben.
            </Typography>
            <Button
              variant="contained"
              color="primary"
              onClick={handleSetup}
              disabled={loading}
              sx={{ mt: 2 }}
              startIcon={loading && <CircularProgress size={20} color="inherit" />}
            >
              {loading ? 'Wird eingerichtet...' : 'MFA einrichten'}
            </Button>
          </Box>
        );
      case 1:
        return (
          <Box sx={{ textAlign: 'center' }}>
            <Typography variant="body1" paragraph>
              Scannen Sie den QR-Code mit Ihrer Authenticator-App (z.B. Google Authenticator, Authy, Microsoft Authenticator) oder geben Sie den Code manuell ein.
            </Typography>
            <Box sx={{ my: 3 }}>
              {qrCodeUrl && (
                <img
                  src={qrCodeUrl}
                  alt="QR-Code für Zwei-Faktor-Authentifizierung"
                  style={{ maxWidth: '100%', height: 'auto' }}
                />
              )}
            </Box>
            <Typography variant="subtitle2" paragraph>
              Manueller Einrichtungscode:
            </Typography>
            <Typography
              variant="body2"
              sx={{
                backgroundColor: 'grey.100',
                padding: 2,
                borderRadius: 1,
                fontFamily: 'monospace',
                wordBreak: 'break-all',
              }}
            >
              {secret}
            </Typography>
            <Button
              variant="contained"
              color="primary"
              onClick={() => setActiveStep(2)}
              sx={{ mt: 3 }}
            >
              Weiter
            </Button>
          </Box>
        );
      case 2:
        return (
          <Formik
            initialValues={{ code: '' }}
            validationSchema={MfaCodeSchema}
            onSubmit={handleEnableMfa}
          >
            {({ errors, touched }) => (
              <Form>
                <Typography variant="body1" paragraph>
                  Geben Sie den 6-stelligen Code aus Ihrer Authenticator-App ein, um die Einrichtung abzuschliessen.
                </Typography>
                <Grid container spacing={3}>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="code"
                      name="code"
                      label="Authentifizierungscode"
                      variant="outlined"
                      error={touched.code && Boolean(errors.code)}
                      helperText={touched.code && errors.code}
                      autoComplete="off"
                      inputProps={{ maxLength: 6 }}
                    />
                  </Grid>
                  {error && (
                    <Grid item xs={12}>
                      <Typography color="error">{error}</Typography>
                    </Grid>
                  )}
                  <Grid item xs={12}>
                    <Button
                      type="submit"
                      fullWidth
                      variant="contained"
                      color="primary"
                      disabled={loading}
                      sx={{ py: 1.5 }}
                      startIcon={loading && <CircularProgress size={20} color="inherit" />}
                    >
                      {loading ? 'Wird aktiviert...' : 'MFA aktivieren'}
                    </Button>
                  </Grid>
                </Grid>
              </Form>
            )}
          </Formik>
        );
      default:
        return null;
    }
  };

  return (
    <Paper elevation={3} sx={{ p: 4 }}>
      <Typography variant="h5" gutterBottom align="center">
        Zwei-Faktor-Authentifizierung
      </Typography>
      
      <Box sx={{ width: '100%', mb: 4 }}>
        <Stepper activeStep={activeStep} alternativeLabel>
          {steps.map((label) => (
            <Step key={label}>
              <StepLabel>{label}</StepLabel>
            </Step>
          ))}
        </Stepper>
      </Box>
      
      {renderStepContent(activeStep)}
    </Paper>
  );
};

export default MfaSetupForm;
EOL

# Menu Komponenten
cat > "$FRONTEND_DIR/src/components/menu/MenuCard.js" << 'EOL'
import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  Grid,
} from '@mui/material';
import { formatDate } from '../../utils/dateUtils';

const MenuCard = ({ menuplan, compact = false }) => {
  const navigate = useNavigate();
  
  const { id, datum, gerichte } = menuplan;
  
  const handleViewDetails = () => {
    navigate(`/menu/${datum}`);
  };
  
  return (
    <Card 
      elevation={3} 
      sx={{ 
        height: compact ? 'auto' : '100%', 
        display: 'flex', 
        flexDirection: 'column',
        transition: 'transform 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
        },
      }}
    >
      <CardContent sx={{ flexGrow: 1 }}>
        <Typography variant={compact ? 'h6' : 'h5'} component="h2" gutterBottom>
          Menü für {formatDate(datum)}
        </Typography>
        
        <Divider sx={{ my: 1.5 }} />
        
        {compact ? (
          <Typography variant="body2" color="text.secondary">
            {gerichte.length} Gerichte verfügbar
          </Typography>
        ) : (
          <Box sx={{ mt: 2 }}>
            {gerichte.slice(0, 3).map((gericht) => (
              <Box key={gericht.id} sx={{ mb: 2 }}>
                <Grid container spacing={1} alignItems="center">
                  <Grid item xs>
                    <Typography variant="subtitle1" component="div">
                      {gericht.name}
                    </Typography>
                  </Grid>
                  <Grid item>
                    <Typography variant="subtitle1" component="div" color="primary.main">
                      CHF {gericht.preis.toFixed(2)}
                    </Typography>
                  </Grid>
                </Grid>
                
                <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                  {gericht.beschreibung && gericht.beschreibung.length > 60
                    ? `${gericht.beschreibung.substring(0, 60)}...`
                    : gericht.beschreibung}
                </Typography>
                
                <Box sx={{ mt: 1 }}>
                  {gericht.vegetarisch && (
                    <Chip 
                      label="Vegetarisch" 
                      size="small" 
                      color="success" 
                      variant="outlined" 
                      sx={{ mr: 0.5, mb: 0.5 }}
                    />
                  )}
                  {gericht.vegan && (
                    <Chip 
                      label="Vegan" 
                      size="small" 
                      color="success" 
                      sx={{ mr: 0.5, mb: 0.5 }}
                    />
                  )}
                </Box>
              </Box>
            ))}
            
            {gerichte.length > 3 && (
              <Typography variant="body2" color="text.secondary">
                +{gerichte.length - 3} weitere Gerichte
              </Typography>
            )}
          </Box>
        )}
      </CardContent>
      <CardActions>
        <Button 
          size="small" 
          onClick={handleViewDetails}
          sx={{ ml: 1, mb: 1 }}
        >
          Details ansehen
        </Button>
      </CardActions>
    </Card>
  );
};

export default MenuCard;
EOL

cat > "$FRONTEND_DIR/src/components/menu/DishCard.js" << 'EOL'
import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import {
  Card,
  CardContent,
  CardActions,
  CardMedia,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  IconButton,
  Collapse,
  TextField,
} from '@mui/material';
import {
  ExpandMore as ExpandMoreIcon,
  Info as InfoIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
} from '@mui/icons-material';
import { styled } from '@mui/material/styles';
import { addToCart } from '../../store/cart/cartSlice';
import { toast } from 'react-toastify';

const ExpandMore = styled((props) => {
  const { expand, ...other } = props;
  return <IconButton {...other} />;
})(({ theme, expand }) => ({
  transform: !expand ? 'rotate(0deg)' : 'rotate(180deg)',
  marginLeft: 'auto',
  transition: theme.transitions.create('transform', {
    duration: theme.transitions.duration.shortest,
  }),
}));

const DishCard = ({ gericht }) => {
  const dispatch = useDispatch();
  const [expanded, setExpanded] = useState(false);
  const [quantity, setQuantity] = useState(1);

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  const handleAddToCart = () => {
    dispatch(addToCart({ gericht, anzahl: quantity }));
    toast.success(`${quantity}x ${gericht.name} zum Warenkorb hinzugefügt`);
  };

  const handleIncreaseQuantity = () => {
    setQuantity(quantity + 1);
  };

  const handleDecreaseQuantity = () => {
    if (quantity > 1) {
      setQuantity(quantity - 1);
    }
  };

  const handleQuantityChange = (event) => {
    const value = parseInt(event.target.value, 10);
    if (!isNaN(value) && value > 0) {
      setQuantity(value);
    }
  };

  return (
    <Card
      elevation={3}
      sx={{
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
        transition: 'transform 0.2s, box-shadow 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
          boxShadow: 6,
        },
      }}
    >
      {gericht.bildUrl && (
        <CardMedia
          component="img"
          height="140"
          image={gericht.bildUrl}
          alt={gericht.name}
        />
      )}
      <CardContent sx={{ flexGrow: 1 }}>
        <Typography variant="h6" component="div" gutterBottom>
          {gericht.name}
        </Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mb: 1.5 }}>
          {gericht.beschreibung && gericht.beschreibung.length > 100
            ? `${gericht.beschreibung.substring(0, 100)}...`
            : gericht.beschreibung}
        </Typography>
        <Typography variant="h6" color="primary.main" sx={{ mb: 1.5 }}>
          CHF {gericht.preis.toFixed(2)}
        </Typography>
        <Box sx={{ mt: 1, mb: 1.5 }}>
          {gericht.vegetarisch && (
            <Chip
              label="Vegetarisch"
              size="small"
              color="success"
              variant="outlined"
              sx={{ mr: 0.5, mb: 0.5 }}
            />
          )}
          {gericht.vegan && (
            <Chip
              label="Vegan"
              size="small"
              color="success"
              sx={{ mr: 0.5, mb: 0.5 }}
            />
          )}
        </Box>
      </CardContent>
      <Divider />
      <CardActions disableSpacing>
        <Box sx={{ display: 'flex', alignItems: 'center', mr: 1 }}>
          <IconButton size="small" onClick={handleDecreaseQuantity}>
            <RemoveIcon />
          </IconButton>
          <TextField
            value={quantity}
            onChange={handleQuantityChange}
            size="small"
            inputProps={{ min: 1, style: { textAlign: 'center' } }}
            sx={{ width: '40px', mx: 1 }}
          />
          <IconButton size="small" onClick={handleIncreaseQuantity}>
            <AddIcon />
          </IconButton>
        </Box>
        
        <Button
          variant="contained"
          size="small"
          startIcon={<AddIcon />}
          onClick={handleAddToCart}
          sx={{ flexGrow: 1 }}
        >
          Hinzufügen
        </Button>
        
        <ExpandMore
          expand={expanded}
          onClick={handleExpandClick}
          aria-expanded={expanded}
          aria-label="mehr anzeigen"
        >
          <InfoIcon />
        </ExpandMore>
      </CardActions>
      <Collapse in={expanded} timeout="auto" unmountOnExit>
        <CardContent>
          {gericht.zutaten && gericht.zutaten.length > 0 && (
            <>
              <Typography variant="subtitle2" gutterBottom>
                Zutaten:
              </Typography>
              <Typography variant="body2" paragraph>
                {gericht.zutaten.join(', ')}
              </Typography>
            </>
          )}
          
          {gericht.allergene && gericht.allergene.length > 0 && (
            <>
              <Typography variant="subtitle2" gutterBottom>
                Allergene:
              </Typography>
              <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, mb: 1.5 }}>
                {gericht.allergene.map((allergen) => (
                  <Chip
                    key={allergen}
                    label={allergen}
                    size="small"
                    color="error"
                    variant="outlined"
                  />
                ))}
              </Box>
            </>
          )}
        </CardContent>
      </Collapse>
    </Card>
  );
};

export default DishCard;
EOL

cat > "$FRONTEND_DIR/src/components/menu/DateSelector.js" << 'EOL'
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Button, Typography, Paper } from '@mui/material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { addDays, format, isEqual, isToday, isTomorrow } from 'date-fns';
import { formatDate } from '../../utils/dateUtils';

const DateSelector = ({ selectedDate, onChange }) => {
  const navigate = useNavigate();
  
  const dates = [
    { date: new Date(), label: 'Heute' },
    { date: addDays(new Date(), 1), label: 'Morgen' },
    { date: addDays(new Date(), 2), label: format(addDays(new Date(), 2), 'EEE dd.MM.', { locale: deLocale }) },
    { date: addDays(new Date(), 3), label: format(addDays(new Date(), 3), 'EEE dd.MM.', { locale: deLocale }) },
    { date: addDays(new Date(), 4), label: format(addDays(new Date(), 4), 'EEE dd.MM.', { locale: deLocale }) },
  ];
  
  const handleDateChange = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    onChange(formattedDate);
    navigate(`/menu/${formattedDate}`);
  };
  
  const handleQuickSelect = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    onChange(formattedDate);
    navigate(`/menu/${formattedDate}`);
  };
  
  const isDateSelected = (date) => {
    if (!selectedDate) return false;
    const selDate = new Date(selectedDate);
    return isEqual(
      new Date(date.getFullYear(), date.getMonth(), date.getDate()),
      new Date(selDate.getFullYear(), selDate.getMonth(), selDate.getDate())
    );
  };
  
  return (
    <Paper 
      elevation={2} 
      sx={{ 
        p: 2, 
        mb: 4,
        backgroundColor: (theme) => theme.palette.background.paper
      }}
    >
      <Typography variant="h6" component="h2" gutterBottom>
        Menüplan für {selectedDate ? formatDate(selectedDate) : 'Heute'}
      </Typography>
      
      <Box sx={{ display: 'flex', flexWrap: 'wrap', mb: 2, gap: 1 }}>
        {dates.map((item) => (
          <Button
            key={item.label}
            variant={isDateSelected(item.date) ? 'contained' : 'outlined'}
            color="primary"
            size="small"
            onClick={() => handleQuickSelect(item.date)}
            sx={{ minWidth: '80px' }}
          >
            {item.label}
          </Button>
        ))}
      </Box>
      
      <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
        <DatePicker
          label="Anderes Datum wählen"
          value={selectedDate ? new Date(selectedDate) : new Date()}
          onChange={handleDateChange}
          minDate={new Date()}
          maxDate={addDays(new Date(), 30)}
          sx={{ width: '100%' }}
          slotProps={{
            textField: {
              variant: 'outlined',
              fullWidth: true,
              size: 'small',
            },
          }}
        />
      </LocalizationProvider>
    </Paper>
  );
};

export default DateSelector;
EOL

cat > "$FRONTEND_DIR/src/components/menu/FilterControls.js" << 'EOL'
import React, { useState } from 'react';
import {
  Box,
  FormGroup,
  FormControlLabel,
  Checkbox,
  TextField,
  InputAdornment,
  IconButton,
  Button,
  Chip,
  Paper,
  Typography,
  Divider,
  Collapse,
} from '@mui/material';
import {
  Search as SearchIcon,
  Clear as ClearIcon,
  ExpandMore as ExpandMoreIcon,
} from '@mui/icons-material';
import { styled } from '@mui/material/styles';

const ExpandButton = styled(Button)(({ theme, expanded }) => ({
  marginTop: theme.spacing(1),
  marginBottom: theme.spacing(1),
  '& .MuiButton-endIcon': {
    transition: 'transform 0.2s',
    transform: expanded ? 'rotate(180deg)' : 'rotate(0deg)',
  },
}));

const FilterControls = ({ onFilterChange }) => {
  const [filters, setFilters] = useState({
    search: '',
    onlyVegetarian: false,
    onlyVegan: false,
    maxPrice: '',
    allergens: [],
  });
  
  const [expanded, setExpanded] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  
  // Common allergens
  const commonAllergens = [
    'Gluten', 
    'Laktose', 
    'Eier', 
    'Nüsse', 
    'Erdnüsse', 
    'Soja', 
    'Fisch', 
    'Krebstiere', 
    'Sellerie', 
    'Senf'
  ];
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const handleSearchSubmit = () => {
    handleFilterChange('search', searchTerm);
  };
  
  const handleSearchClear = () => {
    setSearchTerm('');
    handleFilterChange('search', '');
  };
  
  const handleFilterChange = (filterName, value) => {
    const newFilters = { ...filters, [filterName]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };
  
  const handleAllergenToggle = (allergen) => {
    const currentAllergens = [...filters.allergens];
    const allergenIndex = currentAllergens.indexOf(allergen);
    
    if (allergenIndex === -1) {
      currentAllergens.push(allergen);
    } else {
      currentAllergens.splice(allergenIndex, 1);
    }
    
    handleFilterChange('allergens', currentAllergens);
  };
  
  const handleAllergenClear = () => {
    handleFilterChange('allergens', []);
  };
  
  const handleExpand = () => {
    setExpanded(!expanded);
  };
  
  const handleKeyDown = (event) => {
    if (event.key === 'Enter') {
      handleSearchSubmit();
    }
  };
  
  return (
    <Paper elevation={2} sx={{ p: 2, mb: 3 }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Filter
      </Typography>
      
      <Box sx={{ mb: 2 }}>
        <TextField
          fullWidth
          placeholder="Gerichte suchen..."
          value={searchTerm}
          onChange={handleSearchChange}
          onKeyDown={handleKeyDown}
          variant="outlined"
          size="small"
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
            endAdornment: searchTerm && (
              <InputAdornment position="end">
                <IconButton
                  aria-label="clear search"
                  onClick={handleSearchClear}
                  edge="end"
                >
                  <ClearIcon />
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <FormGroup row>
        <FormControlLabel
          control={
            <Checkbox
              checked={filters.onlyVegetarian}
              onChange={(e) => handleFilterChange('onlyVegetarian', e.target.checked)}
              color="success"
            />
          }
          label="Vegetarisch"
        />
        <FormControlLabel
          control={
            <Checkbox
              checked={filters.onlyVegan}
              onChange={(e) => handleFilterChange('onlyVegan', e.target.checked)}
              color="success"
            />
          }
          label="Vegan"
        />
      </FormGroup>
      
      <ExpandButton
        fullWidth
        endIcon={<ExpandMoreIcon />}
        onClick={handleExpand}
        expanded={expanded}
        sx={{ justifyContent: 'space-between' }}
      >
        Erweiterte Filter
      </ExpandButton>
      
      <Collapse in={expanded}>
        <Divider sx={{ my: 1 }} />
        
        <Box sx={{ mt: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Maximalpreis (CHF)
          </Typography>
          <TextField
            type="number"
            value={filters.maxPrice}
            onChange={(e) => handleFilterChange('maxPrice', e.target.value)}
            variant="outlined"
            size="small"
            fullWidth
            inputProps={{ min: 0, step: 0.5 }}
          />
        </Box>
        
        <Box sx={{ mt: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Allergene ausschliessen
          </Typography>
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
            {commonAllergens.map((allergen) => (
              <Chip
                key={allergen}
                label={allergen}
                onClick={() => handleAllergenToggle(allergen)}
                color={filters.allergens.includes(allergen) ? 'primary' : 'default'}
                variant={filters.allergens.includes(allergen) ? 'filled' : 'outlined'}
                sx={{ mb: 1 }}
              />
            ))}
          </Box>
          {filters.allergens.length > 0 && (
            <Button
              variant="text"
              size="small"
              onClick={handleAllergenClear}
              sx={{ mt: 1 }}
            >
              Auswahl zurücksetzen
            </Button>
          )}
        </Box>
      </Collapse>
    </Paper>
  );
};

export default FilterControls;
EOL

# Cart Komponenten
cat > "$FRONTEND_DIR/src/components/cart/CartItem.js" << 'EOL'
import React from 'react';
import { useDispatch } from 'react-redux';
import {
  Box,
  IconButton,
  Typography,
  Grid,
  TextField,
  Paper,
  Divider,
} from '@mui/material';
import {
  Delete as DeleteIcon,
  Add as AddIcon,
  Remove as RemoveIcon,
} from '@mui/icons-material';
import {
  removeFromCart,
  updateCartItemQuantity,
} from '../../store/cart/cartSlice';

const CartItem = ({ item }) => {
  const dispatch = useDispatch();
  const { gericht, anzahl } = item;
  
  const handleRemove = () => {
    dispatch(removeFromCart(gericht.id));
  };
  
  const handleIncrease = () => {
    dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: anzahl + 1 }));
  };
  
  const handleDecrease = () => {
    if (anzahl > 1) {
      dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: anzahl - 1 }));
    } else {
      handleRemove();
    }
  };
  
  const handleQuantityChange = (event) => {
    const value = parseInt(event.target.value, 10);
    if (!isNaN(value) && value > 0) {
      dispatch(updateCartItemQuantity({ gerichtId: gericht.id, anzahl: value }));
    } else if (value === 0) {
      handleRemove();
    }
  };
  
  const totalPrice = gericht.preis * anzahl;
  
  return (
    <Paper
      elevation={1}
      sx={{
        p: 2,
        mb: 2,
        '&:last-child': {
          mb: 0,
        },
      }}
    >
      <Grid container spacing={2} alignItems="center">
        <Grid item xs={12} sm={6}>
          <Typography variant="subtitle1" component="div">
            {gericht.name}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {gericht.vegetarisch && 'Vegetarisch'} 
            {gericht.vegetarisch && gericht.vegan && ' · '}
            {gericht.vegan && 'Vegan'}
          </Typography>
        </Grid>
        
        <Grid item xs={12} sm={6}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <IconButton
                size="small"
                onClick={handleDecrease}
                aria-label="Menge reduzieren"
              >
                <RemoveIcon fontSize="small" />
              </IconButton>
              
              <TextField
                value={anzahl}
                onChange={handleQuantityChange}
                inputProps={{
                  min: 1,
                  style: { textAlign: 'center', width: '30px' },
                }}
                variant="standard"
                sx={{ mx: 1, width: '40px' }}
              />
              
              <IconButton
                size="small"
                onClick={handleIncrease}
                aria-label="Menge erhöhen"
              >
                <AddIcon fontSize="small" />
              </IconButton>
            </Box>
            
            <Box sx={{ textAlign: 'right', minWidth: '80px' }}>
              <Typography variant="subtitle2" component="div">
                CHF {totalPrice.toFixed(2)}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                (CHF {gericht.preis.toFixed(2)} pro Stück)
              </Typography>
            </Box>
            
            <IconButton
              edge="end"
              aria-label="Entfernen"
              onClick={handleRemove}
              sx={{ ml: 1 }}
              color="error"
            >
              <DeleteIcon />
            </IconButton>
          </Box>
        </Grid>
      </Grid>
    </Paper>
  );
};

export default CartItem;
EOL

cat > "$FRONTEND_DIR/src/components/cart/CartSummary.js" << 'EOL'
import React from 'react';
import { useSelector } from 'react-redux';
import {
  Box,
  Typography,
  Paper,
  Button,
  Divider,
} from '@mui/material';
import { ShoppingBag as ShoppingBagIcon } from '@mui/icons-material';
import { selectCartItems, selectCartTotal, selectCartItemsCount } from '../../store/cart/cartSlice';
import { formatDate } from '../../utils/dateUtils';

const CartSummary = ({ onCheckout, showCheckoutButton = true }) => {
  const cartItems = useSelector(selectCartItems);
  const cartTotal = useSelector(selectCartTotal);
  const itemCount = useSelector(selectCartItemsCount);
  const abholDatum = useSelector(state => state.cart.abholDatum);
  const abholZeit = useSelector(state => state.cart.abholZeit);
  
  const isEmpty = cartItems.length === 0;
  
  if (isEmpty && !showCheckoutButton) {
    return null;
  }
  
  return (
    <Paper elevation={3} sx={{ p: 3 }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Zusammenfassung
      </Typography>
      
      {isEmpty ? (
        <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
          Ihr Warenkorb ist leer.
        </Typography>
      ) : (
        <>
          <Box sx={{ mb: 2 }}>
            <Typography variant="body2" color="text.secondary" gutterBottom>
              {itemCount} {itemCount === 1 ? 'Artikel' : 'Artikel'} im Warenkorb
            </Typography>
            
            {abholDatum && abholZeit && (
              <Typography variant="body2" color="text.secondary">
                Abholung am {formatDate(abholDatum)} um {abholZeit} Uhr
              </Typography>
            )}
          </Box>
          
          <Divider sx={{ mb: 2 }} />
          
          <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
            <Typography variant="subtitle1">Zwischensumme</Typography>
            <Typography variant="subtitle1">CHF {cartTotal.toFixed(2)}</Typography>
          </Box>
          
          <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
            <Typography variant="h6">Gesamtsumme</Typography>
            <Typography variant="h6" color="primary.main">CHF {cartTotal.toFixed(2)}</Typography>
          </Box>
        </>
      )}
      
      {showCheckoutButton && (
        <Button
          variant="contained"
          color="primary"
          fullWidth
          size="large"
          onClick={onCheckout}
          disabled={isEmpty || !abholDatum || !abholZeit}
          startIcon={<ShoppingBagIcon />}
          sx={{ py: 1.5 }}
        >
          Zur Kasse
        </Button>
      )}
    </Paper>
  );
};

export default CartSummary;
EOL

cat > "$FRONTEND_DIR/src/components/cart/PickupSelector.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  TextField,
} from '@mui/material';
import { TimePicker } from '@mui/x-date-pickers/TimePicker';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { addDays, format, isToday, parseISO, set } from 'date-fns';
import { setAbholDatum, setAbholZeit, setBemerkungen } from '../../store/cart/cartSlice';

const PickupSelector = () => {
  const dispatch = useDispatch();
  const selectedDate = useSelector(state => state.cart.abholDatum);
  const selectedTime = useSelector(state => state.cart.abholZeit);
  const bemerkungen = useSelector(state => state.cart.bemerkungen);
  
  const [minTime, setMinTime] = useState(null);
  
  // Set default date to today if not selected
  useEffect(() => {
    if (!selectedDate) {
      handleDateChange(new Date());
    } else {
      updateMinTime(selectedDate);
    }
  }, [selectedDate]);
  
  const handleDateChange = (date) => {
    const formattedDate = format(date, 'yyyy-MM-dd');
    dispatch(setAbholDatum(formattedDate));
    updateMinTime(formattedDate);
    
    // If time is now out of range, reset it
    if (selectedTime) {
      const timeObj = parseTimeString(selectedTime);
      if (isToday(parseISO(formattedDate)) && (timeObj.getHours() < 10 || timeObj.getHours() >= 15)) {
        dispatch(setAbholZeit(null));
      }
    }
  };
  
  const handleTimeChange = (time) => {
    if (time) {
      const formattedTime = format(time, 'HH:mm');
      dispatch(setAbholZeit(formattedTime));
    } else {
      dispatch(setAbholZeit(null));
    }
  };
  
  const handleBemerkungenChange = (event) => {
    dispatch(setBemerkungen(event.target.value));
  };
  
  const updateMinTime = (date) => {
    if (isToday(parseISO(date))) {
      const now = new Date();
      // Set min time to 10:00 or current time + 30 min (whichever is later)
      const minTimeDate = set(now, { hours: 10, minutes: 0, seconds: 0 });
      const currentPlusBuffer = set(now, { 
        minutes: now.getMinutes() + 30, 
        seconds: 0 
      });
      
      setMinTime(currentPlusBuffer > minTimeDate ? currentPlusBuffer : minTimeDate);
    } else {
      // Set min time to 10:00 for future dates
      setMinTime(set(new Date(), { hours: 10, minutes: 0, seconds: 0 }));
    }
  };
  
  const parseTimeString = (timeString) => {
    const [hours, minutes] = timeString.split(':').map(Number);
    return set(new Date(), { hours, minutes, seconds: 0 });
  };
  
  return (
    <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
      <Typography variant="h6" component="h2" gutterBottom>
        Abholzeit auswählen
      </Typography>
      
      <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
        <Grid container spacing={3}>
          <Grid item xs={12} sm={6}>
            <DatePicker
              label="Abholdatum"
              value={selectedDate ? parseISO(selectedDate) : null}
              onChange={handleDateChange}
              minDate={new Date()}
              maxDate={addDays(new Date(), 7)}
              sx={{ width: '100%' }}
              slotProps={{
                textField: {
                  variant: 'outlined',
                  fullWidth: true,
                  required: true,
                  helperText: 'Bitte wählen Sie ein Datum aus',
                },
              }}
            />
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <TimePicker
              label="Abholzeit"
              value={selectedTime ? parseTimeString(selectedTime) : null}
              onChange={handleTimeChange}
              minTime={minTime}
              maxTime={set(new Date(), { hours: 14, minutes: 30 })}
              sx={{ width: '100%' }}
              slotProps={{
                textField: {
                  variant: 'outlined',
                  fullWidth: true,
                  required: true,
                  helperText: 'Verfügbar zwischen 10:00 und 14:30 Uhr',
                },
              }}
            />
          </Grid>
          
          <Grid item xs={12}>
            <TextField
              label="Bemerkungen zur Bestellung (optional)"
              multiline
              rows={3}
              value={bemerkungen}
              onChange={handleBemerkungenChange}
              variant="outlined"
              fullWidth
              placeholder="Spezielle Wünsche oder Informationen"
            />
          </Grid>
        </Grid>
      </LocalizationProvider>
    </Paper>
  );
};

export default PickupSelector;
EOL

# Order Komponenten
cat > "$FRONTEND_DIR/src/components/orders/OrderCard.js" << 'EOL'
import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box,
  Chip,
  Divider,
  Grid,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  AccessTime as AccessTimeIcon,
  CalendarToday as CalendarTodayIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel } from '../../utils/statusUtils';

const OrderCard = ({ order }) => {
  const navigate = useNavigate();
  
  const handleViewDetails = () => {
    navigate(`/orders/${order.id}`);
  };
  
  return (
    <Card 
      elevation={2} 
      sx={{ 
        mb: 2, 
        borderLeft: 4, 
        borderColor: getStatusColor(order.status),
        transition: 'transform 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
        },
      }}
    >
      <CardContent>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
          <Box>
            <Typography variant="h6" component="div">
              Bestellung #{order.id}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Bestellt am {formatDate(order.bestellDatum)}
            </Typography>
          </Box>
          <Chip 
            label={getStatusLabel(order.status)} 
            color={getStatusColor(order.status, 'mui')} 
            size="small"
          />
        </Box>
        
        <Grid container spacing={2}>
          <Grid item xs={12} sm={6}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
              <CalendarTodayIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                Abholung am {formatDate(order.abholDatum)}
              </Typography>
            </Box>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <AccessTimeIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                Uhrzeit: {order.abholZeit} Uhr
              </Typography>
            </Box>
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
              <ReceiptIcon fontSize="small" sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="body2">
                {order.positionen.length} {order.positionen.length === 1 ? 'Position' : 'Positionen'}
              </Typography>
            </Box>
            <Typography variant="subtitle1" color="primary.main">
              CHF {order.gesamtPreis.toFixed(2)}
            </Typography>
          </Grid>
        </Grid>
        
        <Divider sx={{ my: 1.5 }} />
        
        <Box>
          <Typography variant="body2" component="div">
            Zahlungsstatus: <Chip 
              label={order.zahlungsStatus === 'BEZAHLT' ? 'Bezahlt' : 'Ausstehend'} 
              color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
              size="small" 
              sx={{ ml: 1 }}
            />
          </Typography>
        </Box>
      </CardContent>
      <CardActions>
        <Button size="small" onClick={handleViewDetails}>
          Details anzeigen
        </Button>
      </CardActions>
    </Card>
  );
};

export default OrderCard;
EOL

cat > "$FRONTEND_DIR/src/components/orders/OrderDetail.js" << 'EOL'
import React from 'react';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Chip,
  Divider,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  CalendarToday as CalendarTodayIcon,
  AccessTime as AccessTimeIcon,
  LocalDining as LocalDiningIcon,
  Payment as PaymentIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel, getZahlungsStatusLabel } from '../../utils/statusUtils';

const OrderDetail = ({ order, onStartPayment, onCancelOrder }) => {
  if (!order) return null;
  
  const canBeCancelled = order.status === 'NEU' && order.zahlungsStatus !== 'BEZAHLT';
  const needsPayment = order.zahlungsStatus === 'AUSSTEHEND';
  
  return (
    <Box>
      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 3 }}>
          <Box>
            <Typography variant="h5" component="h1">
              Bestellung #{order.id}
            </Typography>
            <Typography variant="body1" color="text.secondary">
              Bestellt am {formatDate(order.bestellDatum)}
            </Typography>
          </Box>
          <Chip 
            label={getStatusLabel(order.status)} 
            color={getStatusColor(order.status, 'mui')} 
          />
        </Box>
        
        <Grid container spacing={3}>
          <Grid item xs={12} md={6}>
            <Paper variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                <CalendarTodayIcon sx={{ mr: 1 }} /> Abholinformationen
              </Typography>
              <Typography variant="body1" paragraph>
                Datum: <strong>{formatDate(order.abholDatum)}</strong>
              </Typography>
              <Typography variant="body1">
                Uhrzeit: <strong>{order.abholZeit} Uhr</strong>
              </Typography>
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={6}>
            <Paper variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                <PaymentIcon sx={{ mr: 1 }} /> Zahlungsinformationen
              </Typography>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Typography variant="body1">
                  Status: 
                </Typography>
                <Chip 
                  label={getZahlungsStatusLabel(order.zahlungsStatus)} 
                  color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
                />
              </Box>
              {order.zahlungsReferenz && (
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  Referenz: {order.zahlungsReferenz}
                </Typography>
              )}
            </Paper>
          </Grid>
        </Grid>
        
        {order.bemerkungen && (
          <Paper variant="outlined" sx={{ p: 2, mt: 3 }}>
            <Typography variant="h6" gutterBottom>
              Bemerkungen
            </Typography>
            <Typography variant="body1">
              {order.bemerkungen}
            </Typography>
          </Paper>
        )}
        
        <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 3, gap: 2 }}>
          {canBeCancelled && (
            <Button 
              variant="outlined" 
              color="error" 
              onClick={onCancelOrder}
            >
              Bestellung stornieren
            </Button>
          )}
          
          {needsPayment && (
            <Button 
              variant="contained" 
              color="primary" 
              onClick={onStartPayment}
              startIcon={<PaymentIcon />}
            >
              Jetzt bezahlen
            </Button>
          )}
        </Box>
      </Paper>
      
      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
          <LocalDiningIcon sx={{ mr: 1 }} /> Bestellte Gerichte
        </Typography>
        
        <TableContainer component={Paper} variant="outlined" sx={{ mt: 2 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Gericht</TableCell>
                <TableCell align="right">Preis</TableCell>
                <TableCell align="right">Anzahl</TableCell>
                <TableCell align="right">Gesamt</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {order.positionen.map((position) => (
                <TableRow key={position.id}>
                  <TableCell>{position.gerichtName}</TableCell>
                  <TableCell align="right">CHF {position.einzelPreis.toFixed(2)}</TableCell>
                  <TableCell align="right">{position.anzahl}</TableCell>
                  <TableCell align="right">CHF {position.gesamtPreis.toFixed(2)}</TableCell>
                </TableRow>
              ))}
              <TableRow>
                <TableCell colSpan={3} align="right" sx={{ fontWeight: 'bold' }}>
                  Gesamtsumme:
                </TableCell>
                <TableCell align="right" sx={{ fontWeight: 'bold' }}>
                  CHF {order.gesamtPreis.toFixed(2)}
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  );
};

export default OrderDetail;
EOL

cat > "$FRONTEND_DIR/src/components/orders/PaymentForm.js" << 'EOL'
import React, { useState } from 'react';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  TextField,
  Button,
  Grid,
  Typography,
  Paper,
  Box,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormHelperText,
  Divider,
  CircularProgress,
} from '@mui/material';
import { CreditCard, AccountBalance, Receipt } from '@mui/icons-material';

const PaymentSchema = Yup.object().shape({
  zahlungsMethode: Yup.string().required('Bitte wählen Sie eine Zahlungsmethode'),
  kartenNummer: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Kartennummer ist erforderlich')
      .matches(/^\d{16}$/, 'Kartennummer muss 16 Ziffern haben'),
  }),
  kartenName: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string().required('Name ist erforderlich'),
  }),
  kartenCVV: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('CVV ist erforderlich')
      .matches(/^\d{3}$/, 'CVV muss 3 Ziffern haben'),
  }),
  kartenAblaufMonat: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Monat ist erforderlich')
      .matches(/^(0[1-9]|1[0-2])$/, 'Ungültiger Monat'),
  }),
  kartenAblaufJahr: Yup.string().when('zahlungsMethode', {
    is: 'KREDITKARTE',
    then: () => Yup.string()
      .required('Jahr ist erforderlich')
      .matches(/^\d{2}$/, 'Jahr muss 2 Ziffern haben'),
  }),
});

const PaymentForm = ({ order, onSubmit, loading }) => {
  const [paymentMethod, setPaymentMethod] = useState('');
  
  const initialValues = {
    zahlungsMethode: '',
    kartenNummer: '',
    kartenName: '',
    kartenCVV: '',
    kartenAblaufMonat: '',
    kartenAblaufJahr: '',
  };
  
  const handleSubmit = (values) => {
    const paymentData = {
      ...values,
      betrag: order.gesamtPreis,
    };
    onSubmit(paymentData);
  };
  
  return (
    <Formik
      initialValues={initialValues}
      validationSchema={PaymentSchema}
      onSubmit={handleSubmit}
    >
      {({ errors, touched, values, setFieldValue }) => (
        <Form>
          <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" gutterBottom>
              Zahlungsinformationen
            </Typography>
            
            <Box sx={{ mb: 3 }}>
              <Typography variant="body1" gutterBottom>
                Bestellung #{order.id}
              </Typography>
              <Typography variant="h6" color="primary.main">
                Gesamtbetrag: CHF {order.gesamtPreis.toFixed(2)}
              </Typography>
            </Box>
            
            <Divider sx={{ mb: 3 }} />
            
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <FormControl fullWidth error={touched.zahlungsMethode && Boolean(errors.zahlungsMethode)}>
                  <InputLabel id="zahlungsMethode-label">Zahlungsmethode</InputLabel>
                  <Field
                    as={Select}
                    labelId="zahlungsMethode-label"
                    id="zahlungsMethode"
                    name="zahlungsMethode"
                    label="Zahlungsmethode"
                    onChange={(e) => {
                      setFieldValue('zahlungsMethode', e.target.value);
                      setPaymentMethod(e.target.value);
                    }}
                  >
                    <MenuItem value="KREDITKARTE" sx={{ display: 'flex', alignItems: 'center' }}>
                      <CreditCard sx={{ mr: 1 }} /> Kreditkarte
                    </MenuItem>
                    <MenuItem value="BANKUEBERWEISUNG" sx={{ display: 'flex', alignItems: 'center' }}>
                      <AccountBalance sx={{ mr: 1 }} /> Banküberweisung
                    </MenuItem>
                    <MenuItem value="RECHNUNG" sx={{ display: 'flex', alignItems: 'center' }}>
                      <Receipt sx={{ mr: 1 }} /> Rechnung
                    </MenuItem>
                  </Field>
                  {touched.zahlungsMethode && errors.zahlungsMethode && (
                    <FormHelperText>{errors.zahlungsMethode}</FormHelperText>
                  )}
                </FormControl>
              </Grid>
              
              {paymentMethod === 'KREDITKARTE' && (
                <>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenNummer"
                      name="kartenNummer"
                      label="Kartennummer"
                      variant="outlined"
                      error={touched.kartenNummer && Boolean(errors.kartenNummer)}
                      helperText={touched.kartenNummer && errors.kartenNummer}
                      inputProps={{ maxLength: 16 }}
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenName"
                      name="kartenName"
                      label="Name auf der Karte"
                      variant="outlined"
                      error={touched.kartenName && Boolean(errors.kartenName)}
                      helperText={touched.kartenName && errors.kartenName}
                    />
                  </Grid>
                  <Grid item xs={6}>
                    <Grid container spacing={2}>
                      <Grid item xs={6}>
                        <Field
                          as={TextField}
                          fullWidth
                          id="kartenAblaufMonat"
                          name="kartenAblaufMonat"
                          label="Monat"
                          placeholder="MM"
                          variant="outlined"
                          error={touched.kartenAblaufMonat && Boolean(errors.kartenAblaufMonat)}
                          helperText={touched.kartenAblaufMonat && errors.kartenAblaufMonat}
                          inputProps={{ maxLength: 2 }}
                        />
                      </Grid>
                      <Grid item xs={6}>
                        <Field
                          as={TextField}
                          fullWidth
                          id="kartenAblaufJahr"
                          name="kartenAblaufJahr"
                          label="Jahr"
                          placeholder="JJ"
                          variant="outlined"
                          error={touched.kartenAblaufJahr && Boolean(errors.kartenAblaufJahr)}
                          helperText={touched.kartenAblaufJahr && errors.kartenAblaufJahr}
                          inputProps={{ maxLength: 2 }}
                        />
                      </Grid>
                    </Grid>
                  </Grid>
                  <Grid item xs={6}>
                    <Field
                      as={TextField}
                      fullWidth
                      id="kartenCVV"
                      name="kartenCVV"
                      label="CVV"
                      variant="outlined"
                      error={touched.kartenCVV && Boolean(errors.kartenCVV)}
                      helperText={touched.kartenCVV && errors.kartenCVV}
                      inputProps={{ maxLength: 3 }}
                    />
                  </Grid>
                </>
              )}
              
              {paymentMethod === 'BANKUEBERWEISUNG' && (
                <Grid item xs={12}>
                  <Typography variant="body2" sx={{ mb: 1 }}>
                    Bitte verwenden Sie die folgenden Informationen für die Überweisung:
                  </Typography>
                  <Box sx={{ p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
                    <Typography variant="body2">
                      <strong>Empfänger:</strong> Mensa App GmbH
                    </Typography>
                    <Typography variant="body2">
                      <strong>IBAN:</strong> CH93 0076 2011 6238 5295 7
                    </Typography>
                    <Typography variant="body2">
                      <strong>BIC/SWIFT:</strong> POFICHBEXXX
                    </Typography>
                    <Typography variant="body2">
                      <strong>Verwendungszweck:</strong> Bestellung #{order.id}
                    </Typography>
                    <Typography variant="body2">
                      <strong>Betrag:</strong> CHF {order.gesamtPreis.toFixed(2)}
                    </Typography>
                  </Box>
                </Grid>
              )}
              
              {paymentMethod === 'RECHNUNG' && (
                <Grid item xs={12}>
                  <Typography variant="body2">
                    Sie erhalten eine Rechnung per E-Mail. Bitte bezahlen Sie diese innerhalb von 10 Tagen.
                  </Typography>
                </Grid>
              )}
              
              <Grid item xs={12}>
                <Button
                  type="submit"
                  fullWidth
                  variant="contained"
                  color="primary"
                  disabled={loading || !paymentMethod}
                  sx={{ py: 1.5, mt: 2 }}
                  startIcon={loading && <CircularProgress size={20} color="inherit" />}
                >
                  {loading ? 'Wird verarbeitet...' : 'Bezahlen'}
                </Button>
              </Grid>
            </Grid>
          </Paper>
        </Form>
      )}
    </Formik>
  );
};

export default PaymentForm;
EOL

# Admin Komponenten
cat > "$FRONTEND_DIR/src/components/admin/OrderManagement.js" << 'EOL'
import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  Button,
  Menu,
  MenuItem,
  IconButton,
  Typography,
  Box,
  Divider,
  TextField,
  Grid,
} from '@mui/material';
import {
  MoreVert as MoreVertIcon,
  FilterList as FilterListIcon,
  Refresh as RefreshIcon,
  ExpandMore as ExpandMoreIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';
import { getStatusColor, getStatusLabel, getZahlungsStatusLabel } from '../../utils/statusUtils';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import deLocale from 'date-fns/locale/de';

const OrderManagement = ({ orders, onUpdateStatus, onRefresh }) => {
  const [statusAnchorEl, setStatusAnchorEl] = useState(null);
  const [currentOrderId, setCurrentOrderId] = useState(null);
  const [showFilters, setShowFilters] = useState(false);
  const [filterDate, setFilterDate] = useState(null);
  const [filterStatus, setFilterStatus] = useState('');
  
  const handleStatusMenuOpen = (event, orderId) => {
    setStatusAnchorEl(event.currentTarget);
    setCurrentOrderId(orderId);
  };
  
  const handleStatusMenuClose = () => {
    setStatusAnchorEl(null);
    setCurrentOrderId(null);
  };
  
  const handleStatusChange = (status) => {
    if (currentOrderId) {
      onUpdateStatus(currentOrderId, status);
    }
    handleStatusMenuClose();
  };
  
  const toggleFilters = () => {
    setShowFilters(!showFilters);
  };
  
  const handleFilterDateChange = (date) => {
    setFilterDate(date);
  };
  
  const handleFilterStatusChange = (event) => {
    setFilterStatus(event.target.value);
  };
  
  const clearFilters = () => {
    setFilterDate(null);
    setFilterStatus('');
  };
  
  // Status options for filter and change status menu
  const statusOptions = [
    { value: 'NEU', label: 'Neu' },
    { value: 'IN_ZUBEREITUNG', label: 'In Zubereitung' },
    { value: 'BEREIT', label: 'Bereit' },
    { value: 'ABGEHOLT', label: 'Abgeholt' },
    { value: 'STORNIERT', label: 'Storniert' },
  ];
  
  // Filter orders
  const filteredOrders = orders.filter(order => {
    let match = true;
    
    if (filterDate) {
      const orderDate = new Date(order.abholDatum);
      const filterDateObj = new Date(filterDate);
      
      match = match && 
        orderDate.getFullYear() === filterDateObj.getFullYear() &&
        orderDate.getMonth() === filterDateObj.getMonth() &&
        orderDate.getDate() === filterDateObj.getDate();
    }
    
    if (filterStatus) {
      match = match && order.status === filterStatus;
    }
    
    return match;
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        <Typography variant="h6" component="h2">
          Bestellungen verwalten
        </Typography>
        
        <Box>
          <Button 
            startIcon={<FilterListIcon />} 
            onClick={toggleFilters}
            endIcon={<ExpandMoreIcon sx={{ transform: showFilters ? 'rotate(180deg)' : 'rotate(0deg)' }} />}
            sx={{ mr: 1 }}
          >
            Filter
          </Button>
          <Button 
            startIcon={<RefreshIcon />} 
            onClick={onRefresh}
          >
            Aktualisieren
          </Button>
        </Box>
      </Box>
      
      {showFilters && (
        <Paper sx={{ p: 2, mb: 3 }}>
          <Typography variant="subtitle1" gutterBottom>
            Bestellungen filtern
          </Typography>
          
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} sm={4}>
              <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
                <DatePicker
                  label="Abholdatum"
                  value={filterDate}
                  onChange={handleFilterDateChange}
                  sx={{ width: '100%' }}
                  slotProps={{
                    textField: {
                      variant: 'outlined',
                      fullWidth: true,
                      size: 'small',
                    },
                  }}
                />
              </LocalizationProvider>
            </Grid>
            
            <Grid item xs={12} sm={4}>
              <TextField
                select
                fullWidth
                label="Status"
                value={filterStatus}
                onChange={handleFilterStatusChange}
                variant="outlined"
                size="small"
              >
                <MenuItem value="">Alle Status</MenuItem>
                {statusOptions.map((option) => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.label}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            
            <Grid item xs={12} sm={4}>
              <Button variant="outlined" onClick={clearFilters} fullWidth>
                Filter zurücksetzen
              </Button>
            </Grid>
          </Grid>
        </Paper>
      )}
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>Bestell-Nr.</TableCell>
              <TableCell>Kunde</TableCell>
              <TableCell>Abholdatum</TableCell>
              <TableCell>Abholzeit</TableCell>
              <TableCell>Gerichte</TableCell>
              <TableCell>Gesamt</TableCell>
              <TableCell>Zahlungsstatus</TableCell>
              <TableCell>Status</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredOrders.length > 0 ? (
              filteredOrders.map((order) => (
                <TableRow key={order.id}>
                  <TableCell>{order.id}</TableCell>
                  <TableCell>{order.userName}</TableCell>
                  <TableCell>{formatDate(order.abholDatum)}</TableCell>
                  <TableCell>{order.abholZeit}</TableCell>
                  <TableCell>{order.positionen.length}</TableCell>
                  <TableCell>CHF {order.gesamtPreis.toFixed(2)}</TableCell>
                  <TableCell>
                    <Chip 
                      label={getZahlungsStatusLabel(order.zahlungsStatus)} 
                      color={order.zahlungsStatus === 'BEZAHLT' ? 'success' : 'warning'} 
                      size="small" 
                    />
                  </TableCell>
                  <TableCell>
                    <Chip 
                      label={getStatusLabel(order.status)} 
                      color={getStatusColor(order.status, 'mui')} 
                      size="small" 
                    />
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      aria-label="Status ändern"
                      onClick={(e) => handleStatusMenuOpen(e, order.id)}
                    >
                      <MoreVertIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Bestellungen gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Menu
        anchorEl={statusAnchorEl}
        open={Boolean(statusAnchorEl)}
        onClose={handleStatusMenuClose}
      >
        <MenuItem disabled>
          <Typography variant="caption">Status ändern zu:</Typography>
        </MenuItem>
        <Divider />
        {statusOptions.map((option) => (
          <MenuItem 
            key={option.value} 
            onClick={() => handleStatusChange(option.value)}
          >
            {option.label}
          </MenuItem>
        ))}
      </Menu>
    </>
  );
};

export default OrderManagement;
EOL

cat > "$FRONTEND_DIR/src/components/admin/MenuList.js" << 'EOL'
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Button,
  IconButton,
  Box,
  Typography,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Visibility as VisibilityIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';

const MenuList = ({ menuPlans, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [menuToDelete, setMenuToDelete] = useState(null);
  
  const handleEdit = (id) => {
    navigate(`/admin/menus/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/menus/new');
  };
  
  const handleOpenDeleteDialog = (menu) => {
    setMenuToDelete(menu);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setMenuToDelete(null);
  };
  
  const handleDelete = () => {
    if (menuToDelete) {
      onDelete(menuToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Menüpläne verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neuer Menüplan
        </Button>
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Datum</TableCell>
              <TableCell>Anzahl Gerichte</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {menuPlans.length > 0 ? (
              menuPlans.map((menu) => (
                <TableRow key={menu.id}>
                  <TableCell>{menu.id}</TableCell>
                  <TableCell>{formatDate(menu.datum)}</TableCell>
                  <TableCell>{menu.gerichte.length}</TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="info"
                      onClick={() => navigate(`/menu/${menu.datum}`)}
                      sx={{ mr: 1 }}
                    >
                      <VisibilityIcon />
                    </IconButton>
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(menu.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(menu)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={4} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Menüpläne gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={deleteDialogOpen}
        onClose={handleCloseDeleteDialog}
      >
        <DialogTitle>Menüplan löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie den Menüplan für den {menuToDelete && formatDate(menuToDelete.datum)} wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDeleteDialog}>Abbrechen</Button>
          <Button onClick={handleDelete} color="error" variant="contained">
            Löschen
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default MenuList;
EOL

cat > "$FRONTEND_DIR/src/components/admin/MenuForm.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  Chip,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
  Divider,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  CircularProgress,
} from '@mui/material';
import {
  Add as AddIcon,
  Delete as DeleteIcon,
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import deLocale from 'date-fns/locale/de';
import { formatDate } from '../../utils/dateUtils';

const MenuForm = ({ menuplan, dishes, onSave, loading, isEdit }) => {
  const [formData, setFormData] = useState({
    datum: null,
    gerichtIds: [],
  });
  const [selectedDishes, setSelectedDishes] = useState([]);
  const [dishDialogOpen, setDishDialogOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  
  useEffect(() => {
    if (menuplan) {
      setFormData({
        datum: menuplan.datum,
        gerichtIds: menuplan.gerichte.map(g => g.id),
      });
      setSelectedDishes(menuplan.gerichte);
    } else {
      setFormData({
        datum: new Date(),
        gerichtIds: [],
      });
      setSelectedDishes([]);
    }
  }, [menuplan]);
  
  const handleDateChange = (date) => {
    setFormData({ ...formData, datum: date });
  };
  
  const handleOpenDishDialog = () => {
    setDishDialogOpen(true);
    setSearchTerm('');
  };
  
  const handleCloseDishDialog = () => {
    setDishDialogOpen(false);
  };
  
  const handleAddDish = (dish) => {
    if (!formData.gerichtIds.includes(dish.id)) {
      setFormData({
        ...formData,
        gerichtIds: [...formData.gerichtIds, dish.id],
      });
      setSelectedDishes([...selectedDishes, dish]);
    }
    handleCloseDishDialog();
  };
  
  const handleRemoveDish = (dishId) => {
    setFormData({
      ...formData,
      gerichtIds: formData.gerichtIds.filter(id => id !== dishId),
    });
    setSelectedDishes(selectedDishes.filter(dish => dish.id !== dishId));
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value.toLowerCase());
  };
  
  const handleSubmit = (event) => {
    event.preventDefault();
    onSave(formData);
  };
  
  const filteredDishes = dishes.filter(dish => {
    return (
      dish.name.toLowerCase().includes(searchTerm) ||
      (dish.beschreibung && dish.beschreibung.toLowerCase().includes(searchTerm))
    ) && !formData.gerichtIds.includes(dish.id);
  });
  
  return (
    <form onSubmit={handleSubmit}>
      <Paper sx={{ p: 3, mb: 3 }}>
        <Typography variant="h6" component="h2" gutterBottom>
          {isEdit ? 'Menüplan bearbeiten' : 'Neuen Menüplan erstellen'}
        </Typography>
        
        <Grid container spacing={3}>
          <Grid item xs={12} md={6}>
            <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={deLocale}>
              <DatePicker
                label="Datum"
                value={formData.datum ? new Date(formData.datum) : null}
                onChange={handleDateChange}
                sx={{ width: '100%' }}
                slotProps={{
                  textField: {
                    variant: 'outlined',
                    fullWidth: true,
                    required: true,
                    helperText: 'Wählen Sie das Datum für den Menüplan',
                  },
                }}
              />
            </LocalizationProvider>
          </Grid>
        </Grid>
      </Paper>
      
      <Paper sx={{ p: 3, mb: 3 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Typography variant="h6" component="h3">
            Gerichte ({selectedDishes.length})
          </Typography>
          
          <Button
            variant="outlined"
            startIcon={<AddIcon />}
            onClick={handleOpenDishDialog}
          >
            Gericht hinzufügen
          </Button>
        </Box>
        
        {selectedDishes.length > 0 ? (
          <List sx={{ bgcolor: 'background.paper' }}>
            {selectedDishes.map((dish, index) => (
              <React.Fragment key={dish.id}>
                {index > 0 && <Divider />}
                <ListItem>
                  <ListItemText
                    primary={dish.name}
                    secondary={
                      <>
                        <Typography component="span" variant="body2" color="text.primary">
                          CHF {dish.preis.toFixed(2)}
                        </Typography>
                        {' — '}
                        {dish.vegetarisch && 'Vegetarisch'}
                        {dish.vegetarisch && dish.vegan && ' · '}
                        {dish.vegan && 'Vegan'}
                      </>
                    }
                  />
                  <ListItemSecondaryAction>
                    <IconButton edge="end" aria-label="delete" onClick={() => handleRemoveDish(dish.id)}>
                      <DeleteIcon />
                    </IconButton>
                  </ListItemSecondaryAction>
                </ListItem>
              </React.Fragment>
            ))}
          </List>
        ) : (
          <Typography variant="body2" color="text.secondary" sx={{ textAlign: 'center', py: 3 }}>
            Keine Gerichte ausgewählt. Klicken Sie auf "Gericht hinzufügen", um zu beginnen.
          </Typography>
        )}
      </Paper>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
        <Button
          variant="outlined"
          startIcon={<ArrowBackIcon />}
          onClick={() => window.history.back()}
        >
          Zurück
        </Button>
        
        <Button
          type="submit"
          variant="contained"
          color="primary"
          startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
          disabled={loading || formData.gerichtIds.length === 0 || !formData.datum}
        >
          {loading ? 'Wird gespeichert...' : 'Speichern'}
        </Button>
      </Box>
      
      <Dialog
        open={dishDialogOpen}
        onClose={handleCloseDishDialog}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>Gericht hinzufügen</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Gerichte durchsuchen"
            type="text"
            fullWidth
            variant="outlined"
            value={searchTerm}
            onChange={handleSearchChange}
            sx={{ mb: 2 }}
          />
          
          <List sx={{ bgcolor: 'background.paper' }}>
            {filteredDishes.length > 0 ? (
              filteredDishes.map((dish, index) => (
                <React.Fragment key={dish.id}>
                  {index > 0 && <Divider />}
                  <ListItem button onClick={() => handleAddDish(dish)}>
                    <ListItemText
                      primary={dish.name}
                      secondary={
                        <>
                          <Typography component="span" variant="body2" color="text.primary">
                            CHF {dish.preis.toFixed(2)}
                          </Typography>
                          {' — '}
                          {dish.beschreibung && dish.beschreibung.length > 60
                            ? `${dish.beschreibung.substring(0, 60)}...`
                            : dish.beschreibung}
                          <Box sx={{ mt: 0.5 }}>
                            {dish.vegetarisch && (
                              <Chip 
                                label="Vegetarisch" 
                                size="small" 
                                color="success" 
                                variant="outlined" 
                                sx={{ mr: 0.5 }}
                              />
                            )}
                            {dish.vegan && (
                              <Chip 
                                label="Vegan" 
                                size="small" 
                                color="success" 
                                sx={{ mr: 0.5 }}
                              />
                            )}
                          </Box>
                        </>
                      }
                    />
                  </ListItem>
                </React.Fragment>
              ))
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ textAlign: 'center', py: 2 }}>
                Keine passenden Gerichte gefunden
              </Typography>
            )}
          </List>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDishDialog}>Abbrechen</Button>
        </DialogActions>
      </Dialog>
    </form>
  );
};

export default MenuForm;
EOL

cat > "$FRONTEND_DIR/src/components/admin/DishList.js" << 'EOL'
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Button,
  IconButton,
  Box,
  Typography,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  TextField,
  InputAdornment,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Search as SearchIcon,
  FilterList as FilterListIcon,
} from '@mui/icons-material';

const DishList = ({ dishes, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [dishToDelete, setDishToDelete] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterVegetarian, setFilterVegetarian] = useState(false);
  const [filterVegan, setFilterVegan] = useState(false);
  
  const handleEdit = (id) => {
    navigate(`/admin/dishes/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/dishes/new');
  };
  
  const handleOpenDeleteDialog = (dish) => {
    setDishToDelete(dish);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setDishToDelete(null);
  };
  
  const handleDelete = () => {
    if (dishToDelete) {
      onDelete(dishToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const toggleFilterVegetarian = () => {
    setFilterVegetarian(!filterVegetarian);
    if (!filterVegetarian) {
      setFilterVegan(false);
    }
  };
  
  const toggleFilterVegan = () => {
    setFilterVegan(!filterVegan);
    if (!filterVegan) {
      setFilterVegetarian(true);
    }
  };
  
  const filteredDishes = dishes.filter(dish => {
    const matchesSearch = dish.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (dish.beschreibung && dish.beschreibung.toLowerCase().includes(searchTerm.toLowerCase()));
    
    const matchesVegetarian = !filterVegetarian || dish.vegetarisch;
    const matchesVegan = !filterVegan || dish.vegan;
    
    return matchesSearch && matchesVegetarian && matchesVegan;
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Gerichte verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neues Gericht
        </Button>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Gerichte suchen..."
          variant="outlined"
          size="small"
          value={searchTerm}
          onChange={handleSearchChange}
          sx={{ width: '40%' }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
        
        <Box>
          <Chip
            label="Vegetarisch"
            clickable
            color={filterVegetarian ? 'success' : 'default'}
            onClick={toggleFilterVegetarian}
            sx={{ mr: 1 }}
          />
          <Chip
            label="Vegan"
            clickable
            color={filterVegan ? 'success' : 'default'}
            onClick={toggleFilterVegan}
          />
        </Box>
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Preis (CHF)</TableCell>
              <TableCell>Vegetarisch</TableCell>
              <TableCell>Vegan</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredDishes.length > 0 ? (
              filteredDishes.map((dish) => (
                <TableRow key={dish.id}>
                  <TableCell>{dish.id}</TableCell>
                  <TableCell>{dish.name}</TableCell>
                  <TableCell>{dish.preis.toFixed(2)}</TableCell>
                  <TableCell>
                    {dish.vegetarisch ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell>
                    {dish.vegan ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(dish.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(dish)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Gerichte gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={deleteDialogOpen}
        onClose={handleCloseDeleteDialog}
      >
        <DialogTitle>Gericht löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie das Gericht "{dishToDelete?.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDeleteDialog}>Abbrechen</Button>
          <Button onClick={handleDelete} color="error" variant="contained">
            Löschen
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default DishList;
EOL

cat > "$FRONTEND_DIR/src/components/admin/DishForm.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import * as Yup from 'yup';
import {
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  TextField,
  FormControlLabel,
  Checkbox,
  Chip,
  IconButton,
  Divider,
  CircularProgress,
} from '@mui/material';
import {
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
  Add as AddIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';

const DishSchema = Yup.object().shape({
  name: Yup.string()
    .required('Name ist erforderlich')
    .max(100, 'Name darf maximal 100 Zeichen lang sein'),
  beschreibung: Yup.string()
    .max(1000, 'Beschreibung darf maximal 1000 Zeichen lang sein'),
  preis: Yup.number()
    .required('Preis ist erforderlich')
    .positive('Preis muss positiv sein')
    .max(100, 'Preis darf maximal 100 CHF sein'),
  vegetarisch: Yup.boolean(),
  vegan: Yup.boolean(),
  zutaten: Yup.array().of(Yup.string()),
  allergene: Yup.array().of(Yup.string()),
  bildUrl: Yup.string().url('Bitte geben Sie eine gültige URL ein').nullable(),
});

const DishForm = ({ dish, onSave, loading, isEdit }) => {
  const [newZutat, setNewZutat] = useState('');
  const [newAllergen, setNewAllergen] = useState('');
  
  const initialValues = {
    name: '',
    beschreibung: '',
    preis: '',
    vegetarisch: false,
    vegan: false,
    zutaten: [],
    allergene: [],
    bildUrl: '',
  };
  
  useEffect(() => {
    if (dish) {
      // Felder aus dem dish-Objekt übernehmen, falls vorhanden
      Object.keys(initialValues).forEach(key => {
        if (dish[key] !== undefined) {
          initialValues[key] = dish[key];
        }
      });
    }
  }, [dish]);
  
  const handleSubmit = (values) => {
    onSave(values);
  };
  
  return (
    <Formik
      initialValues={dish || initialValues}
      validationSchema={DishSchema}
      onSubmit={handleSubmit}
      enableReinitialize
    >
      {({ values, errors, touched, setFieldValue }) => (
        <Form>
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              {isEdit ? 'Gericht bearbeiten' : 'Neues Gericht erstellen'}
            </Typography>
            
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="name"
                  name="name"
                  label="Name"
                  variant="outlined"
                  error={touched.name && Boolean(errors.name)}
                  helperText={touched.name && errors.name}
                  required
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="beschreibung"
                  name="beschreibung"
                  label="Beschreibung"
                  variant="outlined"
                  multiline
                  rows={3}
                  error={touched.beschreibung && Boolean(errors.beschreibung)}
                  helperText={touched.beschreibung && errors.beschreibung}
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <Field
                  as={TextField}
                  fullWidth
                  id="preis"
                  name="preis"
                  label="Preis (CHF)"
                  variant="outlined"
                  type="number"
                  InputProps={{ inputProps: { min: 0, step: 0.1 } }}
                  error={touched.preis && Boolean(errors.preis)}
                  helperText={touched.preis && errors.preis}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="vegetarisch"
                      name="vegetarisch"
                      color="success"
                      checked={values.vegetarisch}
                      onChange={(e) => {
                        setFieldValue('vegetarisch', e.target.checked);
                        // Wenn vegetarisch abgewählt wird, auch vegan abwählen
                        if (!e.target.checked) {
                          setFieldValue('vegan', false);
                        }
                      }}
                    />
                  }
                  label="Vegetarisch"
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="vegan"
                      name="vegan"
                      color="success"
                      checked={values.vegan}
                      onChange={(e) => {
                        setFieldValue('vegan', e.target.checked);
                        // Wenn vegan ausgewählt wird, auch vegetarisch auswählen
                        if (e.target.checked) {
                          setFieldValue('vegetarisch', true);
                        }
                      }}
                      disabled={!values.vegetarisch}
                    />
                  }
                  label="Vegan"
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="bildUrl"
                  name="bildUrl"
                  label="Bild-URL"
                  variant="outlined"
                  error={touched.bildUrl && Boolean(errors.bildUrl)}
                  helperText={touched.bildUrl && errors.bildUrl}
                />
              </Grid>
            </Grid>
          </Paper>
          
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h3" gutterBottom>
              Zutaten
            </Typography>
            
            <Box sx={{ display: 'flex', mb: 2 }}>
              <TextField
                fullWidth
                label="Neue Zutat"
                variant="outlined"
                value={newZutat}
                onChange={(e) => setNewZutat(e.target.value)}
                size="small"
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<AddIcon />}
                onClick={() => {
                  if (newZutat.trim()) {
                    setFieldValue('zutaten', [...values.zutaten, newZutat.trim()]);
                    setNewZutat('');
                  }
                }}
                disabled={!newZutat.trim()}
                sx={{ ml: 1 }}
              >
                Hinzufügen
              </Button>
            </Box>
            
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
              <FieldArray name="zutaten">
                {({ remove }) => (
                  <>
                    {values.zutaten.length > 0 ? (
                      values.zutaten.map((zutat, index) => (
                        <Chip
                          key={index}
                          label={zutat}
                          onDelete={() => remove(index)}
                          color="primary"
                          variant="outlined"
                        />
                      ))
                    ) : (
                      <Typography variant="body2" color="text.secondary">
                        Keine Zutaten hinzugefügt
                      </Typography>
                    )}
                  </>
                )}
              </FieldArray>
            </Box>
          </Paper>
          
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h3" gutterBottom>
              Allergene
            </Typography>
            
            <Box sx={{ display: 'flex', mb: 2 }}>
              <TextField
                fullWidth
                label="Neues Allergen"
                variant="outlined"
                value={newAllergen}
                onChange={(e) => setNewAllergen(e.target.value)}
                size="small"
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<AddIcon />}
                onClick={() => {
                  if (newAllergen.trim()) {
                    setFieldValue('allergene', [...values.allergene, newAllergen.trim()]);
                    setNewAllergen('');
                  }
                }}
                disabled={!newAllergen.trim()}
                sx={{ ml: 1 }}
              >
                Hinzufügen
              </Button>
            </Box>
            
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
              <FieldArray name="allergene">
                {({ remove }) => (
                  <>
                    {values.allergene.length > 0 ? (
                      values.allergene.map((allergen, index) => (
                        <Chip
                          key={index}
                          label={allergen}
                          onDelete={() => remove(index)}
                          color="error"
                          variant="outlined"
                        />
                      ))
                    ) : (
                      <Typography variant="body2" color="text.secondary">
                        Keine Allergene hinzugefügt
                      </Typography>
                    )}
                  </>
                )}
              </FieldArray>
            </Box>
          </Paper>
          
          <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
            <Button
              variant="outlined"
              startIcon={<ArrowBackIcon />}
              onClick={() => window.history.back()}
            >
              Zurück
            </Button>
            
            <Button
              type="submit"
              variant="contained"
              color="primary"
              startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
              disabled={loading}
            >
              {loading ? 'Wird gespeichert...' : 'Speichern'}
            </Button>
          </Box>
        </Form>
      )}
    </Formik>
  );
};

export default DishForm;
EOL

cat > "$FRONTEND_DIR/src/components/admin/DrinkList.js" << 'EOL'
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Button,
  IconButton,
  Box,
  Typography,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  TextField,
  InputAdornment,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  Search as SearchIcon,
} from '@mui/icons-material';

const DrinkList = ({ drinks, onDelete }) => {
  const navigate = useNavigate();
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [drinkToDelete, setDrinkToDelete] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  
  const handleEdit = (id) => {
    navigate(`/admin/drinks/${id}`);
  };
  
  const handleCreate = () => {
    navigate('/admin/drinks/new');
  };
  
  const handleOpenDeleteDialog = (drink) => {
    setDrinkToDelete(drink);
    setDeleteDialogOpen(true);
  };
  
  const handleCloseDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setDrinkToDelete(null);
  };
  
  const handleDelete = () => {
    if (drinkToDelete) {
      onDelete(drinkToDelete.id);
    }
    handleCloseDeleteDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const filteredDrinks = drinks.filter(drink => {
    return drink.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (drink.beschreibung && drink.beschreibung.toLowerCase().includes(searchTerm.toLowerCase()));
  });
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Getränke verwalten
        </Typography>
        
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />} 
          onClick={handleCreate}
        >
          Neues Getränk
        </Button>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Getränke suchen..."
          variant="outlined"
          size="small"
          value={searchTerm}
          onChange={handleSearchChange}
          sx={{ width: '40%' }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Preis (CHF)</TableCell>
              <TableCell>Vorrat</TableCell>
              <TableCell>Verfügbar</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredDrinks.length > 0 ? (
              filteredDrinks.map((drink) => (
                <TableRow key={drink.id}>
                  <TableCell>{drink.id}</TableCell>
                  <TableCell>{drink.name}</TableCell>
                  <TableCell>{drink.preis.toFixed(2)}</TableCell>
                  <TableCell>{drink.vorrat}</TableCell>
                  <TableCell>
                    {drink.verfuegbar ? 
                      <Chip label="Ja" size="small" color="success" /> : 
                      <Chip label="Nein" size="small" color="error" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleEdit(drink.id)}
                      sx={{ mr: 1 }}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      color="error"
                      onClick={() => handleOpenDeleteDialog(drink)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Getränke gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={deleteDialogOpen}
        onClose={handleCloseDeleteDialog}
      >
        <DialogTitle>Getränk löschen</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Möchten Sie das Getränk "{drinkToDelete?.name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDeleteDialog}>Abbrechen</Button>
          <Button onClick={handleDelete} color="error" variant="contained">
            Löschen
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default DrinkList;
EOL

cat > "$FRONTEND_DIR/src/components/admin/DrinkForm.js" << 'EOL'
import React from 'react';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import {
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  TextField,
  FormControlLabel,
  Checkbox,
  CircularProgress,
} from '@mui/material';
import {
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';

const DrinkSchema = Yup.object().shape({
  name: Yup.string()
    .required('Name ist erforderlich')
    .max(100, 'Name darf maximal 100 Zeichen lang sein'),
  beschreibung: Yup.string()
    .max(1000, 'Beschreibung darf maximal 1000 Zeichen lang sein'),
  preis: Yup.number()
    .required('Preis ist erforderlich')
    .positive('Preis muss positiv sein')
    .max(100, 'Preis darf maximal 100 CHF sein'),
  vorrat: Yup.number()
    .required('Vorrat ist erforderlich')
    .min(0, 'Vorrat darf nicht negativ sein')
    .integer('Vorrat muss eine ganze Zahl sein'),
  verfuegbar: Yup.boolean(),
  bildUrl: Yup.string().url('Bitte geben Sie eine gültige URL ein').nullable(),
});

const DrinkForm = ({ drink, onSave, loading, isEdit }) => {
  const initialValues = {
    name: '',
    beschreibung: '',
    preis: '',
    vorrat: 0,
    verfuegbar: true,
    bildUrl: '',
  };
  
  const handleSubmit = (values) => {
    onSave(values);
  };
  
  return (
    <Formik
      initialValues={drink || initialValues}
      validationSchema={DrinkSchema}
      onSubmit={handleSubmit}
      enableReinitialize
    >
      {({ errors, touched }) => (
        <Form>
          <Paper sx={{ p: 3, mb: 3 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              {isEdit ? 'Getränk bearbeiten' : 'Neues Getränk erstellen'}
            </Typography>
            
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="name"
                  name="name"
                  label="Name"
                  variant="outlined"
                  error={touched.name && Boolean(errors.name)}
                  helperText={touched.name && errors.name}
                  required
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="beschreibung"
                  name="beschreibung"
                  label="Beschreibung"
                  variant="outlined"
                  multiline
                  rows={3}
                  error={touched.beschreibung && Boolean(errors.beschreibung)}
                  helperText={touched.beschreibung && errors.beschreibung}
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <Field
                  as={TextField}
                  fullWidth
                  id="preis"
                  name="preis"
                  label="Preis (CHF)"
                  variant="outlined"
                  type="number"
                  InputProps={{ inputProps: { min: 0, step: 0.1 } }}
                  error={touched.preis && Boolean(errors.preis)}
                  helperText={touched.preis && errors.preis}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <Field
                  as={TextField}
                  fullWidth
                  id="vorrat"
                  name="vorrat"
                  label="Vorrat"
                  variant="outlined"
                  type="number"
                  InputProps={{ inputProps: { min: 0, step: 1 } }}
                  error={touched.vorrat && Boolean(errors.vorrat)}
                  helperText={touched.vorrat && errors.vorrat}
                  required
                />
              </Grid>
              
              <Grid item xs={12} sm={4}>
                <FormControlLabel
                  control={
                    <Field
                      as={Checkbox}
                      id="verfuegbar"
                      name="verfuegbar"
                      color="success"
                    />
                  }
                  label="Verfügbar"
                />
              </Grid>
              
              <Grid item xs={12}>
                <Field
                  as={TextField}
                  fullWidth
                  id="bildUrl"
                  name="bildUrl"
                  label="Bild-URL"
                  variant="outlined"
                  error={touched.bildUrl && Boolean(errors.bildUrl)}
                  helperText={touched.bildUrl && errors.bildUrl}
                />
              </Grid>
            </Grid>
          </Paper>
          
          <Box sx={{ display: 'flex', justifyContent: 'space-between' }}>
            <Button
              variant="outlined"
              startIcon={<ArrowBackIcon />}
              onClick={() => window.history.back()}
            >
              Zurück
            </Button>
            
            <Button
              type="submit"
              variant="contained"
              color="primary"
              startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
              disabled={loading}
            >
              {loading ? 'Wird gespeichert...' : 'Speichern'}
            </Button>
          </Box>
        </Form>
      )}
    </Formik>
  );
};

export default DrinkForm;
EOL

cat > "$FRONTEND_DIR/src/components/admin/UserList.js" << 'EOL'
import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  Box,
  Typography,
  Chip,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  InputAdornment,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Button,
} from '@mui/material';
import {
  Edit as EditIcon,
  Security as SecurityIcon,
  Search as SearchIcon,
  Save as SaveIcon,
} from '@mui/icons-material';

const UserList = ({ users, onUpdateRoles }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [roleDialogOpen, setRoleDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedRoles, setSelectedRoles] = useState([]);
  
  const handleOpenRoleDialog = (user) => {
    setSelectedUser(user);
    setSelectedRoles(user.roles.map(role => role.replace('ROLE_', '')));
    setRoleDialogOpen(true);
  };
  
  const handleCloseRoleDialog = () => {
    setRoleDialogOpen(false);
    setSelectedUser(null);
  };
  
  const handleRoleChange = (event) => {
    setSelectedRoles(event.target.value);
  };
  
  const handleSaveRoles = () => {
    if (selectedUser) {
      onUpdateRoles(selectedUser.id, selectedRoles);
    }
    handleCloseRoleDialog();
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const filteredUsers = users.filter(user => {
    return user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
           user.vorname.toLowerCase().includes(searchTerm.toLowerCase()) ||
           user.nachname.toLowerCase().includes(searchTerm.toLowerCase());
  });
  
  const getRoleChip = (role) => {
    let color = 'default';
    let label = role.replace('ROLE_', '');
    
    switch (role) {
      case 'ROLE_ADMIN':
        color = 'error';
        break;
      case 'ROLE_STAFF':
        color = 'primary';
        break;
      case 'ROLE_USER':
        color = 'success';
        break;
      default:
        color = 'default';
    }
    
    return <Chip label={label} color={color} size="small" sx={{ mr: 0.5 }} />;
  };
  
  return (
    <>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h6" component="h2">
          Benutzer verwalten
        </Typography>
      </Box>
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <TextField
          placeholder="Benutzer suchen..."
          variant="outlined"
          size="small"
          value={searchTerm}
          onChange={handleSearchChange}
          sx={{ width: '40%' }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650 }}>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>E-Mail</TableCell>
              <TableCell>Rollen</TableCell>
              <TableCell>MFA</TableCell>
              <TableCell align="right">Aktionen</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredUsers.length > 0 ? (
              filteredUsers.map((user) => (
                <TableRow key={user.id}>
                  <TableCell>{user.id}</TableCell>
                  <TableCell>{`${user.vorname} ${user.nachname}`}</TableCell>
                  <TableCell>{user.email}</TableCell>
                  <TableCell>
                    {user.roles.map(role => (
                      <span key={role}>
                        {getRoleChip(role)}
                      </span>
                    ))}
                  </TableCell>
                  <TableCell>
                    {user.mfaEnabled ? 
                      <Chip label="Aktiviert" size="small" color="success" /> : 
                      <Chip label="Deaktiviert" size="small" variant="outlined" />
                    }
                  </TableCell>
                  <TableCell align="right">
                    <IconButton
                      color="primary"
                      onClick={() => handleOpenRoleDialog(user)}
                      title="Rollen bearbeiten"
                    >
                      <SecurityIcon />
                    </IconButton>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={6} align="center">
                  <Typography variant="body1" sx={{ py: 2 }}>
                    Keine Benutzer gefunden
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
      
      <Dialog
        open={roleDialogOpen}
        onClose={handleCloseRoleDialog}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>Benutzerrollen bearbeiten</DialogTitle>
        <DialogContent>
          {selectedUser && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" gutterBottom>
                Benutzer: {selectedUser.vorname} {selectedUser.nachname}
              </Typography>
              <Typography variant="body2" color="text.secondary" gutterBottom>
                E-Mail: {selectedUser.email}
              </Typography>
              
              <FormControl fullWidth sx={{ mt: 2 }}>
                <InputLabel id="roles-label">Rollen</InputLabel>
                <Select
                  labelId="roles-label"
                  id="roles"
                  multiple
                  value={selectedRoles}
                  onChange={handleRoleChange}
                  renderValue={(selected) => (
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                      {selected.map((value) => (
                        <Chip key={value} label={value} />
                      ))}
                    </Box>
                  )}
                >
                  <MenuItem value="USER">Benutzer</MenuItem>
                  <MenuItem value="STAFF">Mitarbeiter</MenuItem>
                  <MenuItem value="ADMIN">Administrator</MenuItem>
                </Select>
              </FormControl>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseRoleDialog}>Abbrechen</Button>
          <Button
            onClick={handleSaveRoles}
            variant="contained"
            color="primary"
            startIcon={<SaveIcon />}
          >
            Speichern
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default UserList;
EOL

cat > "$FRONTEND_DIR/src/components/admin/DashboardSummary.js" << 'EOL'
import React from 'react';
import {
  Box,
  Paper,
  Typography,
  Grid,
  Card,
  CardContent,
  List,
  ListItem,
  ListItemText,
  Divider,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  ShoppingCart as ShoppingCartIcon,
  Person as PersonIcon,
  AttachMoney as AttachMoneyIcon,
  TrendingUp as TrendingUpIcon,
} from '@mui/icons-material';
import { formatDate } from '../../utils/dateUtils';

const DashboardSummary = ({ stats, todaysOrders }) => {
  return (
    <Box>
      <Typography variant="h5" component="h1" gutterBottom>
        Dashboard Übersicht
      </Typography>
      
      <Grid container spacing={3} sx={{ mb: 3 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'primary.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Bestellungen heute
              </Typography>
              <ShoppingCartIcon color="primary" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.ordersToday}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'success.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Gerichte im Menü
              </Typography>
              <RestaurantIcon color="success" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.dishCount}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'info.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Registrierte Benutzer
              </Typography>
              <PersonIcon color="info" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              {stats.userCount}
            </Typography>
          </Paper>
        </Grid>
        
        <Grid item xs={12} sm={6} md={3}>
          <Paper
            elevation={3}
            sx={{ 
              p: 2, 
              display: 'flex', 
              flexDirection: 'column',
              borderLeft: 4,
              borderColor: 'secondary.main'
            }}
          >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Typography variant="subtitle2" color="text.secondary">
                Umsatz heute
              </Typography>
              <AttachMoneyIcon color="secondary" />
            </Box>
            <Typography variant="h4" component="div" sx={{ mt: 1 }}>
              CHF {stats.revenue.toFixed(2)}
            </Typography>
          </Paper>
        </Grid>
      </Grid>
      
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Bestellungen für heute ({formatDate(new Date())})
            </Typography>
            
            {todaysOrders.length > 0 ? (
              <List>
                {todaysOrders.map((order, index) => (
                  <React.Fragment key={order.id}>
                    {index > 0 && <Divider component="li" />}
                    <ListItem>
                      <ListItemText
                        primary={`#${order.id} - ${order.userName}`}
                        secondary={
                          <>
                            <Typography component="span" variant="body2">
                              {order.abholZeit} Uhr | {order.positionen.length} Artikel | CHF {order.gesamtPreis.toFixed(2)}
                            </Typography>
                            <br />
                            <Typography component="span" variant="body2" color="text.secondary">
                              Status: {order.status}
                            </Typography>
                          </>
                        }
                      />
                    </ListItem>
                  </React.Fragment>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                Keine Bestellungen für heute
              </Typography>
            )}
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2 }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Beliebteste Gerichte
            </Typography>
            
            {stats.popularDishes && stats.popularDishes.length > 0 ? (
              <List>
                {stats.popularDishes.map((dish, index) => (
                  <React.Fragment key={dish.id}>
                    {index > 0 && <Divider component="li" />}
                    <ListItem>
                      <ListItemText
                        primary={dish.name}
                        secondary={`${dish.orderCount} Bestellungen`}
                      />
                    </ListItem>
                  </React.Fragment>
                ))}
              </List>
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                Keine Daten verfügbar
              </Typography>
            )}
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default DashboardSummary;
EOL

# Utils erstellen
mkdir -p "$FRONTEND_DIR/src/utils"
cat > "$FRONTEND_DIR/src/utils/dateUtils.js" << 'EOL'
import { format, isToday, isYesterday, isTomorrow, parseISO } from 'date-fns';
import { de } from 'date-fns/locale';

/**
 * Formatiert ein Datum für die Anzeige
 * @param {string|Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatDate = (date) => {
  if (!date) return '';
  
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  
  if (isToday(dateObj)) {
    return 'Heute';
  } else if (isYesterday(dateObj)) {
    return 'Gestern';
  } else if (isTomorrow(dateObj)) {
    return 'Morgen';
  } else {
    return format(dateObj, 'EEEE, dd. MMMM yyyy', { locale: de });
  }
};

/**
 * Formatiert ein Datum als kurzes Datum (DD.MM.YYYY)
 * @param {string|Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatShortDate = (date) => {
  if (!date) return '';
  
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  return format(dateObj, 'dd.MM.yyyy');
};

/**
 * Formatiert ein Datum als ISO-String (YYYY-MM-DD)
 * @param {Date} date - Das zu formatierende Datum
 * @returns {string} Das formatierte Datum
 */
export const formatISODate = (date) => {
  if (!date) return '';
  return format(date, 'yyyy-MM-dd');
};
EOL

cat > "$FRONTEND_DIR/src/utils/statusUtils.js" << 'EOL'
/**
 * Gibt den Anzeigenamen für einen Bestellstatus zurück
 * @param {string} status - Der Bestellstatus
 * @returns {string} Der Anzeigename des Status
 */
export const getStatusLabel = (status) => {
  switch (status) {
    case 'NEU':
      return 'Neu';
    case 'IN_ZUBEREITUNG':
      return 'In Zubereitung';
    case 'BEREIT':
      return 'Bereit zur Abholung';
    case 'ABGEHOLT':
      return 'Abgeholt';
    case 'STORNIERT':
      return 'Storniert';
    default:
      return status;
  }
};

/**
 * Gibt den Anzeigenamen für einen Zahlungsstatus zurück
 * @param {string} status - Der Zahlungsstatus
 * @returns {string} Der Anzeigename des Status
 */
export const getZahlungsStatusLabel = (status) => {
  switch (status) {
    case 'AUSSTEHEND':
      return 'Ausstehend';
    case 'BEZAHLT':
      return 'Bezahlt';
    case 'STORNIERT':
      return 'Storniert';
    default:
      return status;
  }
};

/**
 * Gibt die Farbe für einen Bestellstatus zurück
 * @param {string} status - Der Bestellstatus
 * @param {string} type - Der Typ der Farbe ('mui' für Material-UI Farben, sonst CSS-Farben)
 * @returns {string} Die Farbe für den Status
 */
export const getStatusColor = (status, type = 'css') => {
  let color;
  
  switch (status) {
    case 'NEU':
      color = type === 'mui' ? 'info' : '#2196f3';
      break;
    case 'IN_ZUBEREITUNG':
      color = type === 'mui' ? 'warning' : '#ff9800';
      break;
    case 'BEREIT':
      color = type === 'mui' ? 'success' : '#4caf50';
      break;
    case 'ABGEHOLT':
      color = type === 'mui' ? 'success' : '#4caf50';
      break;
    case 'STORNIERT':
      color = type === 'mui' ? 'error' : '#f44336';
      break;
    default:
      color = type === 'mui' ? 'default' : '#9e9e9e';
  }
  
  return color;
};
EOL

# Pages erstellen
cat > "$FRONTEND_DIR/src/pages/Home.js" << 'EOL'
import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link as RouterLink } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Grid,
  Card,
  CardContent,
  CardMedia,
  Container,
  Paper,
} from '@mui/material';
import {
  Restaurant as RestaurantIcon,
  Event as EventIcon,
  ShoppingCart as ShoppingCartIcon,
} from '@mui/icons-material';
import { fetchTodayMenu, fetchWeeklyMenu } from '../store/menu/menuActions';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import MenuCard from '../components/menu/MenuCard';

const Home = () => {
  const dispatch = useDispatch();
  const { menuplan, weeklyMenus, loading, error } = useSelector(state => state.menu);
  
  useEffect(() => {
    dispatch(fetchTodayMenu());
    dispatch(fetchWeeklyMenu(new Date()));
  }, [dispatch]);
  
  const renderMenuPreview = () => {
    if (loading) return <Loading message="Menü wird geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchTodayMenu())} />;
    
    if (menuplan) {
      return (
        <Box sx={{ mb: 4 }}>
          <Typography variant="h5" component="h2" gutterBottom>
            Heutiges Menü
          </Typography>
          <MenuCard menuplan={menuplan} />
          <Box sx={{ mt: 2, textAlign: 'center' }}>
            <Button
              variant="contained"
              color="primary"
              component={RouterLink}
              to={`/menu/${menuplan.datum}`}
              startIcon={<RestaurantIcon />}
            >
              Vollständiges Menü anzeigen
            </Button>
          </Box>
        </Box>
      );
    }
    
    return (
      <Box sx={{ textAlign: 'center', py: 4 }}>
        <Typography variant="h6" color="text.secondary">
          Kein Menü für heute verfügbar
        </Typography>
        <Button
          variant="contained"
          color="primary"
          component={RouterLink}
          to="/menu"
          sx={{ mt: 2 }}
        >
          Menüplan anzeigen
        </Button>
      </Box>
    );
  };
  
  const renderWeeklyPreview = () => {
    if (weeklyMenus && weeklyMenus.length > 0) {
      // Nur die nächsten 3 Tage anzeigen
      const nextDays = weeklyMenus.slice(0, 3);
      
      return (
        <Box sx={{ mb: 4 }}>
          <Typography variant="h5" component="h2" gutterBottom>
            Kommende Menüs
          </Typography>
          <Grid container spacing={3}>
            {nextDays.map(menu => (
              <Grid item xs={12} sm={6} md={4} key={menu.id}>
                <MenuCard menuplan={menu} compact />
              </Grid>
            ))}
          </Grid>
          <Box sx={{ mt: 2, textAlign: 'center' }}>
            <Button
              variant="outlined"
              color="primary"
              component={RouterLink}
              to="/menu"
              startIcon={<EventIcon />}
            >
              Vollständigen Menüplan anzeigen
            </Button>
          </Box>
        </Box>
      );
    }
    
    return null;
  };
  
  return (
    <Box>
      {/* Hero Section */}
      <Paper
        sx={{
          position: 'relative',
          color: 'white',
          mb: 4,
          backgroundSize: 'cover',
          backgroundRepeat: 'no-repeat',
          backgroundPosition: 'center',
          backgroundImage: 'url(https://source.unsplash.com/random?food)',
          height: '400px',
          display: 'flex',
          alignItems: 'center',
        }}
      >
        <Box
          sx={{
            position: 'absolute',
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            backgroundColor: 'rgba(0,0,0,.6)',
          }}
        />
        <Container sx={{ position: 'relative', p: 4 }}>
          <Box maxWidth="sm">
            <Typography variant="h3" component="h1" gutterBottom>
              Willkommen in unserer Mensa
            </Typography>
            <Typography variant="h5" paragraph>
              Entdecken, bestellen und geniessen Sie unser vielfältiges Angebot
            </Typography>
            <Button
              variant="contained"
              size="large"
              component={RouterLink}
              to="/menu"
              startIcon={<ShoppingCartIcon />}
            >
              Jetzt bestellen
            </Button>
          </Box>
        </Container>
      </Paper>
      
      {renderMenuPreview()}
      
      {renderWeeklyPreview()}
      
      {/* Features */}
      <Typography variant="h5" component="h2" gutterBottom>
        Unsere Vorteile
      </Typography>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Vorbestellung
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Bestellen Sie Ihr Essen im Voraus und sparen Sie wertvolle Zeit. Kein Anstehen mehr in der Mittagspause.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Vielfältiges Angebot
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Geniessen Sie täglich wechselnde Menüs mit vegetarischen und veganen Optionen. Für jeden Geschmack ist etwas dabei.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={4}>
          <Card elevation={3}>
            <CardContent>
              <Typography variant="h6" component="h3" gutterBottom>
                Einfache Bezahlung
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Bezahlen Sie bequem und sicher online. Verschiedene Zahlungsmethoden stehen zur Auswahl.
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Home;
EOL

cat > "$FRONTEND_DIR/src/pages/Login.js" << 'EOL'
import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  Paper,
  Typography,
  Box,
  Container,
  Grid,
} from '@mui/material';
import LoginForm from '../components/auth/LoginForm';
import PageTitle from '../components/common/PageTitle';

const Login = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
  
  const from = location.state?.from || '/';
  
  useEffect(() => {
    if (isLoggedIn) {
      navigate(from, { replace: true });
    }
  }, [isLoggedIn, navigate, from]);
  
  return (
    <Container maxWidth="sm">
      <Grid container justifyContent="center">
        <Grid item xs={12}>
          <Paper elevation={3} sx={{ p: 4, mb: 4 }}>
            <PageTitle 
              title="Anmelden" 
              subtitle="Melden Sie sich an, um fortzufahren"
            />
            
            <LoginForm />
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Login;
EOL

cat > "$FRONTEND_DIR/src/pages/Register.js" << 'EOL'
import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Paper,
  Typography,
  Box,
  Container,
  Grid,
} from '@mui/material';
import RegisterForm from '../components/auth/RegisterForm';
import PageTitle from '../components/common/PageTitle';

const Register = () => {
  const navigate = useNavigate();
  const isLoggedIn = useSelector(state => state.auth.isLoggedIn);
  
  useEffect(() => {
    if (isLoggedIn) {
      navigate('/');
    }
  }, [isLoggedIn, navigate]);
  
  return (
    <Container maxWidth="md">
      <Grid container justifyContent="center">
        <Grid item xs={12}>
          <Paper elevation={3} sx={{ p: 4, mb: 4 }}>
            <PageTitle 
              title="Registrieren" 
              subtitle="Erstellen Sie ein neues Konto"
            />
            
            <RegisterForm />
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Register;
EOL

cat > "$FRONTEND_DIR/src/pages/Menu.js" << 'EOL'
import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
} from '@mui/material';
import { fetchWeeklyMenu } from '../store/menu/menuActions';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import MenuCard from '../components/menu/MenuCard';
import DateSelector from '../components/menu/DateSelector';

const Menu = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { weeklyMenus, selectedDate, loading, error } = useSelector(state => state.menu);
  const [currentDate, setCurrentDate] = useState(selectedDate || new Date().toISOString().split('T')[0]);
  
  useEffect(() => {
    dispatch(fetchWeeklyMenu());
  }, [dispatch]);
  
  const handleDateChange = (date) => {
    setCurrentDate(date);
  };
  
  const renderMenuCards = () => {
    if (loading) return <Loading message="Menüpläne werden geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchWeeklyMenu())} />;
    
    if (weeklyMenus && weeklyMenus.length > 0) {
      return (
        <Grid container spacing={3}>
          {weeklyMenus.map(menu => (
            <Grid item xs={12} md={6} key={menu.id}>
              <MenuCard menuplan={menu} />
            </Grid>
          ))}
        </Grid>
      );
    }
    
    return (
      <Paper sx={{ p: 3, textAlign: 'center' }}>
        <Typography variant="h6" color="text.secondary">
          Keine Menüpläne verfügbar
        </Typography>
      </Paper>
    );
  };
  
  return (
    <Box>
      <DateSelector selectedDate={currentDate} onChange={handleDateChange} />
      
      {renderMenuCards()}
    </Box>
  );
};

export default Menu;
EOL

cat > "$FRONTEND_DIR/src/pages/MenuDetails.js" << 'EOL'
import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Divider,
  CircularProgress,
} from '@mui/material';
import { fetchMenuByDate } from '../store/menu/menuActions';
import { addToCart } from '../store/cart/cartSlice';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import DishCard from '../components/menu/DishCard';
import DateSelector from '../components/menu/DateSelector';
import FilterControls from '../components/menu/FilterControls';
import { formatDate } from '../utils/dateUtils';

const MenuDetails = () => {
  const { date } = useParams();
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { menuplan, loading, error } = useSelector(state => state.menu);
  const [currentDate, setCurrentDate] = useState(date || new Date().toISOString().split('T')[0]);
  const [filteredDishes, setFilteredDishes] = useState([]);
  
  useEffect(() => {
    dispatch(fetchMenuByDate(currentDate));
  }, [dispatch, currentDate]);
  
  useEffect(() => {
    if (menuplan && menuplan.gerichte) {
      setFilteredDishes(menuplan.gerichte);
    }
  }, [menuplan]);
  
  useEffect(() => {
    if (date && date !== currentDate) {
      setCurrentDate(date);
    }
  }, [date]);
  
  const handleDateChange = (date) => {
    setCurrentDate(date);
    navigate(`/menu/${date}`);
  };
  
  const handleFilterChange = (filters) => {
    if (!menuplan || !menuplan.gerichte) return;
    
    const filtered = menuplan.gerichte.filter(gericht => {
      // Filtern nach Suchbegriff
      const matchesSearch = filters.search ? 
        gericht.name.toLowerCase().includes(filters.search.toLowerCase()) ||
        (gericht.beschreibung && gericht.beschreibung.toLowerCase().includes(filters.search.toLowerCase())) : 
        true;
      
      // Filtern nach vegetarisch
      const matchesVegetarian = filters.onlyVegetarian ? gericht.vegetarisch : true;
      
      // Filtern nach vegan
      const matchesVegan = filters.onlyVegan ? gericht.vegan : true;
      
      // Filtern nach Maximalpreis
      const matchesPrice = filters.maxPrice ? gericht.preis <= parseFloat(filters.maxPrice) : true;
      
      // Filtern nach Allergenen
      const matchesAllergenes = filters.allergens.length > 0 ?
        !filters.allergens.some(allergen => 
          gericht.allergene && gericht.allergene.includes(allergen)
        ) : true;
      
      return matchesSearch && matchesVegetarian && matchesVegan && matchesPrice && matchesAllergenes;
    });
    
    setFilteredDishes(filtered);
  };
  
  const renderContent = () => {
    if (loading) return <Loading message="Menü wird geladen..." />;
    if (error) return <ErrorMessage message={error} onRetry={() => dispatch(fetchMenuByDate(currentDate))} />;
    
    if (menuplan && menuplan.gerichte && menuplan.gerichte.length > 0) {
      return (
        <>
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 3 }}>
            <Typography variant="h5" component="h1">
              Speisekarte für {formatDate(menuplan.datum)}
            </Typography>
          </Box>
          
          <Grid container spacing={3}>
            <Grid item xs={12} md={3}>
              <FilterControls onFilterChange={handleFilterChange} />
            </Grid>
            
            <Grid item xs={12} md={9}>
              {filteredDishes.length > 0 ? (
                <Grid container spacing={3}>
                  {filteredDishes.map(gericht => (
                    <Grid item xs={12} sm={6} md={4} key={gericht.id}>
                      <DishCard gericht={gericht} />
                    </Grid>
                  ))}
                </Grid>
              ) : (
                <Paper sx={{ p: 3, textAlign: 'center' }}>
                  <Typography variant="h6" color="text.secondary">
                    Keine passenden Gerichte gefunden
                  </Typography>
                  <Button 
                    variant="outlined" 
                    sx={{ mt: 2 }}
                    onClick={() => handleFilterChange({})}
                  >
                    Filter zurücksetzen
                  </Button>
                </Paper>
              )}
            </Grid>
          </Grid>
        </>
      );
    }
    
    return (
      <Paper sx={{ p: 3, textAlign: 'center' }}>
        <Typography variant="h6" color="text.secondary">
          Kein Menü für dieses Datum verfügbar
        </Typography>
        <Button 
          variant="outlined" 
          sx={{ mt: 2 }}
          onClick={() => navigate('/menu')}
        >
          Zur Menüübersicht
        </Button>
      </Paper>
    );
  };
  
  return (
    <Box>
      <DateSelector selectedDate={currentDate} onChange={handleDateChange} />
      
      {renderContent()}
    </Box>
  );
};

export default MenuDetails;
EOL

cat > "$FRONTEND_DIR/src/pages/Checkout.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Stepper,
  Step,
  StepLabel,
  CircularProgress,
} from '@mui/material';
import {
  ShoppingCart as ShoppingCartIcon,
  Schedule as ScheduleIcon,
  Payment as PaymentIcon,
  Restaurant as RestaurantIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import CartItem from '../components/cart/CartItem';
import CartSummary from '../components/cart/CartSummary';
import PickupSelector from '../components/cart/PickupSelector';
import EmptyState from '../components/common/EmptyState';
import { bestellungService } from '../services/api';
import { clearCart, selectCartItems, selectCartTotal } from '../store/cart/cartSlice';

const steps = ['Warenkorb', 'Abholzeit', 'Bestellübersicht'];

const Checkout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const cartItems = useSelector(selectCartItems);
  const cartTotal = useSelector(selectCartTotal);
  const abholDatum = useSelector(state => state.cart.abholDatum);
  const abholZeit = useSelector(state => state.cart.abholZeit);
  const bemerkungen = useSelector(state => state.cart.bemerkungen);
  
  const [activeStep, setActiveStep] = useState(0);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    // Wenn der Warenkorb leer ist, zurück zum Menü navigieren
    if (cartItems.length === 0 && activeStep !== 0) {
      setActiveStep(0);
    }
  }, [cartItems, activeStep]);
  
  const handleNext = () => {
    const nextStep = activeStep + 1;
    
    // Validieren je nach aktuellem Schritt
    if (activeStep === 0 && cartItems.length === 0) {
      toast.error('Ihr Warenkorb ist leer. Bitte fügen Sie einige Gerichte hinzu.');
      return;
    }
    
    if (activeStep === 1 && (!abholDatum || !abholZeit)) {
      toast.error('Bitte wählen Sie ein Abholdatum und eine Abholzeit.');
      return;
    }
    
    setActiveStep(nextStep);
  };
  
  const handleBack = () => {
    setActiveStep(activeStep - 1);
  };
  
  const handleSubmitOrder = async () => {
    if (cartItems.length === 0) {
      toast.error('Ihr Warenkorb ist leer');
      return;
    }
    
    setLoading(true);
    
    const orderData = {
      abholDatum,
      abholZeit,
      bemerkungen,
      positionen: cartItems.map(item => ({
        gerichtId: item.gericht.id,
        anzahl: item.anzahl
      }))
    };
    
    try {
      const response = await bestellungService.createBestellung(orderData);
      dispatch(clearCart());
      navigate(`/payment/${response.data.id}`);
    } catch (error) {
      const message = error.response?.data?.message || 'Ein Fehler ist aufgetreten';
      toast.error(message);
      setLoading(false);
    }
  };
  
  const renderStepContent = (step) => {
    switch (step) {
      case 0:
        return renderCartStep();
      case 1:
        return renderPickupStep();
      case 2:
        return renderConfirmationStep();
      default:
        return null;
    }
  };
  
  const renderCartStep = () => {
    if (cartItems.length === 0) {
      return (
        <EmptyState
          title="Ihr Warenkorb ist leer"
          message="Fügen Sie einige Gerichte aus dem Menü hinzu, um fortzufahren."
          actionText="Zum Menü"
          onAction={() => navigate('/menu')}
          icon={RestaurantIcon}
        />
      );
    }
    
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3, mb: { xs: 3, md: 0 } }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Warenkorb
            </Typography>
            
            <Box sx={{ mt: 2 }}>
              {cartItems.map((item) => (
                <CartItem key={item.gericht.id} item={item} />
              ))}
            </Box>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary onCheckout={handleNext} />
        </Grid>
      </Grid>
    );
  };
  
  const renderPickupStep = () => {
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <PickupSelector />
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary onCheckout={handleNext} />
        </Grid>
      </Grid>
    );
  };
  
  const renderConfirmationStep = () => {
    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3, mb: { xs: 3, md: 0 } }}>
            <Typography variant="h6" component="h2" gutterBottom>
              Bestellübersicht
            </Typography>
            
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle1" gutterBottom>
                Abholung
              </Typography>
              <Typography variant="body1" paragraph>
                Datum: <strong>{abholDatum}</strong><br />
                Uhrzeit: <strong>{abholZeit} Uhr</strong>
              </Typography>
              
              {bemerkungen && (
                <>
                  <Typography variant="subtitle1" gutterBottom>
                    Bemerkungen
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {bemerkungen}
                  </Typography>
                </>
              )}
              
              <Typography variant="subtitle1" gutterBottom>
                Bestellte Gerichte
              </Typography>
              {cartItems.map((item) => (
                <Box key={item.gericht.id} sx={{ mb: 2 }}>
                  <Grid container>
                    <Grid item xs={8}>
                      <Typography variant="body1">
                        {item.anzahl}× {item.gericht.name}
                      </Typography>
                    </Grid>
                    <Grid item xs={4} sx={{ textAlign: 'right' }}>
                      <Typography variant="body1">
                        CHF {(item.gericht.preis * item.anzahl).toFixed(2)}
                      </Typography>
                    </Grid>
                  </Grid>
                </Box>
              ))}
            </Box>
          </Paper>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <CartSummary showCheckoutButton={false} />
          
          <Box sx={{ mt: 3 }}>
            <Button
              variant="contained"
              color="primary"
              fullWidth
              size="large"
              onClick={handleSubmitOrder}
              disabled={loading}
              startIcon={loading ? <CircularProgress size={20} color="inherit" /> : <PaymentIcon />}
              sx={{ py: 1.5 }}
            >
              {loading ? 'Wird verarbeitet...' : 'Jetzt bestellen und bezahlen'}
            </Button>
          </Box>
        </Grid>
      </Grid>
    );
  };
  
  return (
    <Box>
      <PageTitle title="Checkout" />
      
      <Stepper activeStep={activeStep} sx={{ mb: 4 }}>
        {steps.map((label) => (
          <Step key={label}>
            <StepLabel>{label}</StepLabel>
          </Step>
        ))}
      </Stepper>
      
      {renderStepContent(activeStep)}
      
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mt: 4 }}>
        <Button
          variant="outlined"
          onClick={handleBack}
          disabled={activeStep === 0}
          sx={{ display: activeStep === 0 ? 'none' : 'inline-flex' }}
        >
          Zurück
        </Button>
        
        <Box sx={{ flex: '1 1 auto' }} />
        
        {activeStep < steps.length - 1 && cartItems.length > 0 && (
          <Button
            variant="contained"
            onClick={handleNext}
          >
            Weiter
          </Button>
        )}
      </Box>
    </Box>
  );
};

export default Checkout;
EOL

cat > "$FRONTEND_DIR/src/pages/Payment.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  CircularProgress,
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import PaymentForm from '../components/orders/PaymentForm';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import { bestellungService, zahlungService } from '../services/api';

const Payment = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [processingPayment, setProcessingPayment] = useState(false);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(orderId);
        setOrder(response.data);
        
        // Wenn die Bestellung bereits bezahlt ist, zur Bestätigungsseite navigieren
        if (response.data.zahlungsStatus === 'BEZAHLT') {
          navigate(`/order-confirmation/${orderId}`);
        }
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellung konnte nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrder();
  }, [orderId, navigate]);
  
  const handlePaymentSubmit = async (paymentData) => {
    setProcessingPayment(true);
    try {
      await zahlungService.processZahlung(orderId, paymentData);
      toast.success('Zahlung erfolgreich');
      navigate(`/order-confirmation/${orderId}`);
    } catch (error) {
      const message = error.response?.data?.message || 'Zahlung konnte nicht verarbeitet werden';
      toast.error(message);
      setProcessingPayment(false);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bezahlung" />
        <ErrorMessage 
          message={error} 
          onRetry={() => navigate(`/orders/${orderId}`)} 
        />
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate(-1)}
          sx={{ mt: 2 }}
        >
          Zurück
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <PageTitle 
        title="Bezahlung" 
        subtitle="Schliessen Sie Ihre Bestellung mit der Bezahlung ab" 
      />
      
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <PaymentForm 
            order={order} 
            onSubmit={handlePaymentSubmit} 
            loading={processingPayment} 
          />
        </Grid>
        
        <Grid item xs={12} md={6}>
          <OrderDetail 
            order={order} 
            hideButtons={true}
          />
        </Grid>
      </Grid>
    </Box>
  );
};

export default Payment;
EOL

cat > "$FRONTEND_DIR/src/pages/OrderConfirmation.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  Stack,
  Divider,
} from '@mui/material';
import {
  CheckCircle as CheckCircleIcon,
  Home as HomeIcon,
  ViewList as ViewListIcon,
  Receipt as ReceiptIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import { bestellungService } from '../services/api';
import { formatDate } from '../utils/dateUtils';

const OrderConfirmation = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(orderId);
        setOrder(response.data);
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellung konnte nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrder();
  }, [orderId]);
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bestellbestätigung" />
        <ErrorMessage message={error} />
        <Button
          variant="contained"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
          sx={{ mt: 2 }}
        >
          Zur Startseite
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <Paper 
        elevation={3} 
        sx={{ 
          p: 4, 
          mb: 4, 
          textAlign: 'center',
          bgcolor: 'success.light',
          color: 'success.contrastText' 
        }}
      >
        <CheckCircleIcon sx={{ fontSize: 60, mb: 2 }} />
        <Typography variant="h4" component="h1" gutterBottom>
          Vielen Dank für Ihre Bestellung!
        </Typography>
        <Typography variant="h6" gutterBottom>
          Ihre Bestellung #{order.id} wurde erfolgreich aufgenommen.
        </Typography>
        <Typography variant="body1">
          Ihr Essen wird am {formatDate(order.abholDatum)} um {order.abholZeit} Uhr für Sie bereit sein.
        </Typography>
      </Paper>
      
      <OrderDetail order={order} />
      
      <Stack
        direction={{ xs: 'column', sm: 'row' }}
        spacing={2}
        justifyContent="center"
        sx={{ mt: 4 }}
      >
        <Button
          variant="outlined"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
        >
          Zur Startseite
        </Button>
        <Button
          variant="contained"
          startIcon={<ViewListIcon />}
          onClick={() => navigate('/orders')}
        >
          Meine Bestellungen
        </Button>
      </Stack>
    </Box>
  );
};

export default OrderConfirmation;
EOL

cat > "$FRONTEND_DIR/src/pages/Profile.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  Box,
  Grid,
  Typography,
  Button,
  Paper,
  Tabs,
  Tab,
  Divider,
} from '@mui/material';
import {
  Person as PersonIcon,
  VpnKey as VpnKeyIcon,
  Security as SecurityIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import { userService } from '../services/api';
import { updateProfile, updatePassword } from '../store/auth/authActions';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import MfaSetupForm from '../components/auth/MfaSetupForm';

const ProfileSchema = Yup.object().shape({
  vorname: Yup.string()
    .required('Vorname ist erforderlich')
    .min(2, 'Vorname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Vorname darf maximal 50 Zeichen lang sein'),
  nachname: Yup.string()
    .required('Nachname ist erforderlich')
    .min(2, 'Nachname muss mindestens 2 Zeichen lang sein')
    .max(50, 'Nachname darf maximal 50 Zeichen lang sein'),
  email: Yup.string()
    .email('Ungültige E-Mail-Adresse')
    .required('E-Mail ist erforderlich'),
});

const PasswordSchema = Yup.object().shape({
  altesPassword: Yup.string()
    .required('Aktuelles Passwort ist erforderlich'),
  neuesPassword: Yup.string()
    .required('Neues Passwort ist erforderlich')
    .min(8, 'Passwort muss mindestens 8 Zeichen lang sein')
    .matches(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Passwort muss mindestens einen Grossbuchstaben, einen Kleinbuchstaben und eine Zahl enthalten'
    ),
  neuesPasswordBestaetigung: Yup.string()
    .oneOf([Yup.ref('neuesPassword'), null], 'Passwörter müssen übereinstimmen')
    .required('Passwortbestätigung ist erforderlich'),
});

const Profile = () => {
  const dispatch = useDispatch();
  const user = useSelector(state => state.auth.user);
  const [tabValue, setTabValue] = useState(0);
  const [loading, setLoading] = useState(false);
  
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };
  
  const handleProfileUpdate = async (values) => {
    setLoading(true);
    try {
      await dispatch(updateProfile(values));
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  };
  
  const handlePasswordUpdate = async (values, { resetForm }) => {
    setLoading(true);
    try {
      const success = await dispatch(updatePassword({
        altesPassword: values.altesPassword,
        neuesPassword: values.neuesPassword,
      }));
      
      if (success) {
        resetForm();
      }
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  };
  
  const renderProfileTab = () => {
    return (
      <Box sx={{ mt: 3 }}>
        <Formik
          initialValues={{
            vorname: user?.vorname || '',
            nachname: user?.nachname || '',
            email: user?.email || '',
          }}
          validationSchema={ProfileSchema}
          onSubmit={handleProfileUpdate}
        >
          {({ errors, touched }) => (
            <Form>
              <Grid container spacing={3}>
                <Grid item xs={12} sm={6}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="vorname"
                    name="vorname"
                    label="Vorname"
                    variant="outlined"
                    error={touched.vorname && Boolean(errors.vorname)}
                    helperText={touched.vorname && errors.vorname}
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="nachname"
                    name="nachname"
                    label="Nachname"
                    variant="outlined"
                    error={touched.nachname && Boolean(errors.nachname)}
                    helperText={touched.nachname && errors.nachname}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="email"
                    name="email"
                    label="E-Mail"
                    variant="outlined"
                    error={touched.email && Boolean(errors.email)}
                    helperText={touched.email && errors.email}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Button
                    type="submit"
                    variant="contained"
                    color="primary"
                    disabled={loading}
                    sx={{ mt: 1 }}
                  >
                    {loading ? 'Wird gespeichert...' : 'Profil aktualisieren'}
                  </Button>
                </Grid>
              </Grid>
            </Form>
          )}
        </Formik>
      </Box>
    );
  };
  
  const renderPasswordTab = () => {
    return (
      <Box sx={{ mt: 3 }}>
        <Formik
          initialValues={{
            altesPassword: '',
            neuesPassword: '',
            neuesPasswordBestaetigung: '',
          }}
          validationSchema={PasswordSchema}
          onSubmit={handlePasswordUpdate}
        >
          {({ errors, touched }) => (
            <Form>
              <Grid container spacing={3}>
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="altesPassword"
                    name="altesPassword"
                    label="Aktuelles Passwort"
                    type="password"
                    variant="outlined"
                    error={touched.altesPassword && Boolean(errors.altesPassword)}
                    helperText={touched.altesPassword && errors.altesPassword}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="neuesPassword"
                    name="neuesPassword"
                    label="Neues Passwort"
                    type="password"
                    variant="outlined"
                    error={touched.neuesPassword && Boolean(errors.neuesPassword)}
                    helperText={touched.neuesPassword && errors.neuesPassword}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Field
                    as={TextField}
                    fullWidth
                    id="neuesPasswordBestaetigung"
                    name="neuesPasswordBestaetigung"
                    label="Passwort bestätigen"
                    type="password"
                    variant="outlined"
                    error={touched.neuesPasswordBestaetigung && Boolean(errors.neuesPasswordBestaetigung)}
                    helperText={touched.neuesPasswordBestaetigung && errors.neuesPasswordBestaetigung}
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <Button
                    type="submit"
                    variant="contained"
                    color="primary"
                    disabled={loading}
                    sx={{ mt: 1 }}
                  >
                    {loading ? 'Wird aktualisiert...' : 'Passwort ändern'}
                  </Button>
                </Grid>
              </Grid>
            </Form>
          )}
        </Formik>
      </Box>
    );
  };
  
  return (
    <Box>
      <PageTitle title="Mein Profil" subtitle="Verwalten Sie Ihre persönlichen Informationen" />
      
      <Paper elevation={3} sx={{ p: 3 }}>
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          variant="fullWidth"
          aria-label="Profil Tabs"
        >
          <Tab label="Persönliche Daten" icon={<PersonIcon />} />
          <Tab label="Passwort ändern" icon={<VpnKeyIcon />} />
          <Tab label="Zwei-Faktor-Authentifizierung" icon={<SecurityIcon />} />
        </Tabs>
        
        <Divider sx={{ mb: 3 }} />
        
        {tabValue === 0 && renderProfileTab()}
        {tabValue === 1 && renderPasswordTab()}
        {tabValue === 2 && <MfaSetupForm />}
      </Paper>
    </Box>
  );
};

export default Profile;
EOL

cat > "$FRONTEND_DIR/src/pages/OrderHistory.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Paper,
  Grid,
} from '@mui/material';
import {
  Receipt as ReceiptIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderCard from '../components/orders/OrderCard';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import EmptyState from '../components/common/EmptyState';
import { bestellungService } from '../services/api';

const OrderHistory = () => {
  const navigate = useNavigate();
  
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const response = await bestellungService.getMyBestellungen();
        setOrders(response.data);
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellungen konnten nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrders();
  }, []);
  
  if (loading) {
    return <Loading message="Bestellungen werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => window.location.reload()} />;
  }
  
  if (orders.length === 0) {
    return (
      <Box>
        <PageTitle title="Meine Bestellungen" />
        <EmptyState
          title="Keine Bestellungen gefunden"
          message="Sie haben noch keine Bestellungen aufgegeben."
          actionText="Menü anzeigen"
          onAction={() => navigate('/menu')}
          icon={ReceiptIcon}
        />
      </Box>
    );
  }
  
  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <PageTitle title="Meine Bestellungen" />
        
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => navigate('/menu')}
        >
          Neue Bestellung
        </Button>
      </Box>
      
      <Grid container spacing={3}>
        {orders.map(order => (
          <Grid item xs={12} key={order.id}>
            <OrderCard order={order} />
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default OrderHistory;
EOL

cat > "$FRONTEND_DIR/src/pages/OrderDetail.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
} from '@mui/material';
import {
  ArrowBack as ArrowBackIcon,
} from '@mui/icons-material';
import { toast } from 'react-toastify';

import PageTitle from '../components/common/PageTitle';
import OrderDetail from '../components/orders/OrderDetail';
import Loading from '../components/common/Loading';
import ErrorMessage from '../components/common/ErrorMessage';
import ConfirmDialog from '../components/common/ConfirmDialog';
import { bestellungService } from '../services/api';

const OrderDetailPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [cancelDialogOpen, setCancelDialogOpen] = useState(false);
  
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const response = await bestellungService.getBestellungById(id);
        setOrder(response.data);
      } catch (error) {
        const message = error.response?.data?.message || 'Bestellung konnte nicht geladen werden';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchOrder();
  }, [id]);
  
  const handleStartPayment = () => {
    navigate(`/payment/${id}`);
  };
  
  const handleCancelOrder = async () => {
    try {
      await bestellungService.storniereBestellung(id);
      toast.success('Bestellung wurde storniert');
      
      // Bestellung neu laden
      const response = await bestellungService.getBestellungById(id);
      setOrder(response.data);
    } catch (error) {
      const message = error.response?.data?.message || 'Bestellung konnte nicht storniert werden';
      toast.error(message);
    } finally {
      setCancelDialogOpen(false);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellung wird geladen..." />;
  }
  
  if (error) {
    return (
      <Box>
        <PageTitle title="Bestelldetails" />
        <ErrorMessage message={error} />
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/orders')}
          sx={{ mt: 2 }}
        >
          Zurück zu meinen Bestellungen
        </Button>
      </Box>
    );
  }
  
  return (
    <Box>
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={() => navigate('/orders')}
          sx={{ mr: 2 }}
        >
          Zurück
        </Button>
        <PageTitle title={`Bestellung #${order.id}`} />
      </Box>
      
      <OrderDetail 
        order={order} 
        onStartPayment={handleStartPayment}
        onCancelOrder={() => setCancelDialogOpen(true)}
      />
      
      <ConfirmDialog
        open={cancelDialogOpen}
        title="Bestellung stornieren"
        message="Möchten Sie diese Bestellung wirklich stornieren? Diese Aktion kann nicht rückgängig gemacht werden."
        confirmText="Stornieren"
        cancelText="Abbrechen"
        onConfirm={handleCancelOrder}
        onCancel={() => setCancelDialogOpen(false)}
        confirmButtonProps={{ color: 'error' }}
      />
    </Box>
  );
};

export default OrderDetailPage;
EOL

cat > "$FRONTEND_DIR/src/pages/NotFound.js" << 'EOL'
import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  Paper,
} from '@mui/material';
import {
  SentimentDissatisfied as SentimentDissatisfiedIcon,
  Home as HomeIcon,
} from '@mui/icons-material';

const NotFound = () => {
  const navigate = useNavigate();
  
  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        height: '70vh',
      }}
    >
      <Paper
        elevation={3}
        sx={{
          p: 5,
          textAlign: 'center',
          maxWidth: '500px',
        }}
      >
        <SentimentDissatisfiedIcon sx={{ fontSize: 80, color: 'text.secondary', mb: 2 }} />
        
        <Typography variant="h4" component="h1" gutterBottom>
          404 - Seite nicht gefunden
        </Typography>
        
        <Typography variant="body1" color="text.secondary" paragraph>
          Die angeforderte Seite existiert nicht. Möglicherweise haben Sie einen falschen Link verwendet oder die Seite wurde verschoben.
        </Typography>
        
        <Button
          variant="contained"
          color="primary"
          startIcon={<HomeIcon />}
          onClick={() => navigate('/')}
          sx={{ mt: 2 }}
        >
          Zur Startseite
        </Button>
      </Paper>
    </Box>
  );
};

export default NotFound;
EOL

# Admin Pages erstellen
mkdir -p "$FRONTEND_DIR/src/pages/admin"

cat > "$FRONTEND_DIR/src/pages/admin/Dashboard.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  CircularProgress,
} from '@mui/material';
import { toast } from 'react-toastify';

import DashboardSummary from '../../components/admin/DashboardSummary';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { bestellungService, menuplanService, userService, gerichtService } from '../../services/api';

const Dashboard = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    ordersToday: 0,
    dishCount: 0,
    userCount: 0,
    revenue: 0,
    popularDishes: []
  });
  const [todaysOrders, setTodaysOrders] = useState([]);
  
  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const today = new Date().toISOString().split('T')[0];
        
        // Bestellungen für heute laden
        const ordersResponse = await bestellungService.getBestellungenByDatum(today);
        const orders = ordersResponse.data;
        setTodaysOrders(orders);
        
        // Anzahl der Gerichte laden
        const dishesResponse = await gerichtService.getAllGerichte();
        const dishes = dishesResponse.data;
        
        // Benutzer laden
        const usersResponse = await userService.getAllUsers();
        const users = usersResponse.data;
        
        // Gesamtumsatz für heute berechnen
        const revenue = orders
          .filter(order => order.zahlungsStatus === 'BEZAHLT')
          .reduce((total, order) => total + order.gesamtPreis, 0);
        
        // Beliebte Gerichte ermitteln
        const dishOrderCounts = {};
        orders.forEach(order => {
          order.positionen.forEach(position => {
            if (!dishOrderCounts[position.gerichtId]) {
              dishOrderCounts[position.gerichtId] = {
                id: position.gerichtId,
                name: position.gerichtName,
                orderCount: 0
              };
            }
            dishOrderCounts[position.gerichtId].orderCount += position.anzahl;
          });
        });
        
        const popularDishes = Object.values(dishOrderCounts)
          .sort((a, b) => b.orderCount - a.orderCount)
          .slice(0, 5);
        
        setStats({
          ordersToday: orders.length,
          dishCount: dishes.length,
          userCount: users.length,
          revenue,
          popularDishes
        });
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden der Dashboard-Daten';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDashboardData();
  }, []);
  
  if (loading) {
    return <Loading message="Dashboard wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => window.location.reload()} />;
  }
  
  return (
    <Box>
      <DashboardSummary stats={stats} todaysOrders={todaysOrders} />
    </Box>
  );
};

export default Dashboard;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/Orders.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import OrderManagement from '../../components/admin/OrderManagement';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { bestellungService } from '../../services/api';

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchOrders = async () => {
    setLoading(true);
    try {
      const response = await bestellungService.getAllBestellungen();
      setOrders(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Bestellungen';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchOrders();
  }, []);
  
  const handleUpdateStatus = async (orderId, status) => {
    try {
      await bestellungService.updateBestellungStatus(orderId, status);
      toast.success('Status erfolgreich aktualisiert');
      
      // Bestellungen neu laden
      fetchOrders();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Aktualisieren des Status';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Bestellungen werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchOrders} />;
  }
  
  return (
    <Box>
      <OrderManagement 
        orders={orders} 
        onUpdateStatus={handleUpdateStatus} 
        onRefresh={fetchOrders}
      />
    </Box>
  );
};

export default Orders;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/Menus.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import MenuList from '../../components/admin/MenuList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { menuplanService } from '../../services/api';

const Menus = () => {
  const [menuPlans, setMenuPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchMenuPlans = async () => {
    setLoading(true);
    try {
      const response = await menuplanService.getAllMenuplans();
      setMenuPlans(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Menüpläne';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchMenuPlans();
  }, []);
  
  const handleDeleteMenu = async (menuId) => {
    try {
      await menuplanService.deleteMenuplan(menuId);
      toast.success('Menüplan erfolgreich gelöscht');
      
      // Menüpläne neu laden
      fetchMenuPlans();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Menüplans';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Menüpläne werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchMenuPlans} />;
  }
  
  return (
    <Box>
      <MenuList 
        menuPlans={menuPlans} 
        onDelete={handleDeleteMenu}
      />
    </Box>
  );
};

export default Menus;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/MenuEdit.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import MenuForm from '../../components/admin/MenuForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { menuplanService, gerichtService } from '../../services/api';

const MenuEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [menuplan, setMenuplan] = useState(null);
  const [dishes, setDishes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Alle Gerichte laden
        const dishesResponse = await gerichtService.getAllGerichte();
        setDishes(dishesResponse.data);
        
        // Wenn im Bearbeitungsmodus, Menüplan laden
        if (isEdit) {
          const menuResponse = await menuplanService.getMenuplanById(id);
          setMenuplan(menuResponse.data);
        }
        
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden der Daten';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await menuplanService.updateMenuplan(id, formData);
        toast.success('Menüplan erfolgreich aktualisiert');
      } else {
        await menuplanService.createMenuplan(formData);
        toast.success('Menüplan erfolgreich erstellt');
      }
      
      navigate('/admin/menus');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Menüplans';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message={isEdit ? 'Menüplan wird geladen...' : 'Daten werden geladen...'} />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/menus')} />;
  }
  
  return (
    <Box>
      <MenuForm 
        menuplan={menuplan} 
        dishes={dishes} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default MenuEdit;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/Dishes.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DishList from '../../components/admin/DishList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { gerichtService } from '../../services/api';

const Dishes = () => {
  const [dishes, setDishes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchDishes = async () => {
    setLoading(true);
    try {
      const response = await gerichtService.getAllGerichte();
      setDishes(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Gerichte';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchDishes();
  }, []);
  
  const handleDeleteDish = async (dishId) => {
    try {
      await gerichtService.deleteGericht(dishId);
      toast.success('Gericht erfolgreich gelöscht');
      
      // Gerichte neu laden
      fetchDishes();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Gerichts';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Gerichte werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchDishes} />;
  }
  
  return (
    <Box>
      <DishList 
        dishes={dishes} 
        onDelete={handleDeleteDish}
      />
    </Box>
  );
};

export default Dishes;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/DishEdit.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DishForm from '../../components/admin/DishForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { gerichtService } from '../../services/api';

const DishEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [dish, setDish] = useState(null);
  const [loading, setLoading] = useState(isEdit);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchDish = async () => {
      if (!isEdit) {
        setLoading(false);
        return;
      }
      
      try {
        const response = await gerichtService.getGerichtById(id);
        setDish(response.data);
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden des Gerichts';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDish();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await gerichtService.updateGericht(id, formData);
        toast.success('Gericht erfolgreich aktualisiert');
      } else {
        await gerichtService.createGericht(formData);
        toast.success('Gericht erfolgreich erstellt');
      }
      
      navigate('/admin/dishes');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Gerichts';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message="Gericht wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/dishes')} />;
  }
  
  return (
    <Box>
      <DishForm 
        dish={dish} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default DishEdit;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/Drinks.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DrinkList from '../../components/admin/DrinkList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { getraenkService } from '../../services/api';

const Drinks = () => {
  const [drinks, setDrinks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchDrinks = async () => {
    setLoading(true);
    try {
      const response = await getraenkService.getAllGetraenke();
      setDrinks(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Getränke';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchDrinks();
  }, []);
  
  const handleDeleteDrink = async (drinkId) => {
    try {
      await getraenkService.deleteGetraenk(drinkId);
      toast.success('Getränk erfolgreich gelöscht');
      
      // Getränke neu laden
      fetchDrinks();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Löschen des Getränks';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Getränke werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchDrinks} />;
  }
  
  return (
    <Box>
      <DrinkList 
        drinks={drinks} 
        onDelete={handleDeleteDrink}
      />
    </Box>
  );
};

export default Drinks;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/DrinkEdit.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import DrinkForm from '../../components/admin/DrinkForm';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { getraenkService } from '../../services/api';

const DrinkEdit = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;
  
  const [drink, setDrink] = useState(null);
  const [loading, setLoading] = useState(isEdit);
  const [error, setError] = useState(null);
  const [saving, setSaving] = useState(false);
  
  useEffect(() => {
    const fetchDrink = async () => {
      if (!isEdit) {
        setLoading(false);
        return;
      }
      
      try {
        const response = await getraenkService.getGetraenkById(id);
        setDrink(response.data);
        setError(null);
      } catch (error) {
        const message = error.response?.data?.message || 'Fehler beim Laden des Getränks';
        setError(message);
        toast.error(message);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDrink();
  }, [id, isEdit]);
  
  const handleSave = async (formData) => {
    setSaving(true);
    try {
      if (isEdit) {
        await getraenkService.updateGetraenk(id, formData);
        toast.success('Getränk erfolgreich aktualisiert');
      } else {
        await getraenkService.createGetraenk(formData);
        toast.success('Getränk erfolgreich erstellt');
      }
      
      navigate('/admin/drinks');
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Speichern des Getränks';
      toast.error(message);
      setSaving(false);
    }
  };
  
  if (loading) {
    return <Loading message="Getränk wird geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={() => navigate('/admin/drinks')} />;
  }
  
  return (
    <Box>
      <DrinkForm 
        drink={drink} 
        onSave={handleSave} 
        loading={saving}
        isEdit={isEdit}
      />
    </Box>
  );
};

export default DrinkEdit;
EOL

cat > "$FRONTEND_DIR/src/pages/admin/Users.js" << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
} from '@mui/material';
import { toast } from 'react-toastify';

import UserList from '../../components/admin/UserList';
import Loading from '../../components/common/Loading';
import ErrorMessage from '../../components/common/ErrorMessage';
import { userService } from '../../services/api';

const Users = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await userService.getAllUsers();
      setUsers(response.data);
      setError(null);
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Laden der Benutzer';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  };
  
  useEffect(() => {
    fetchUsers();
  }, []);
  
  const handleUpdateRoles = async (userId, roles) => {
    try {
      await userService.updateUserRoles(userId, roles);
      toast.success('Benutzerrollen erfolgreich aktualisiert');
      
      // Benutzer neu laden
      fetchUsers();
    } catch (error) {
      const message = error.response?.data?.message || 'Fehler beim Aktualisieren der Benutzerrollen';
      toast.error(message);
    }
  };
  
  if (loading) {
    return <Loading message="Benutzer werden geladen..." />;
  }
  
  if (error) {
    return <ErrorMessage message={error} onRetry={fetchUsers} />;
  }
  
  return (
    <Box>
      <UserList 
        users={users} 
        onUpdateRoles={handleUpdateRoles}
      />
    </Box>
  );
};

export default Users;
EOL

# Fix für TextField-Import in einigen Komponenten
sed -i "s/import {/import { TextField, /g" "$FRONTEND_DIR/src/components/auth/MfaSetupForm.js"
sed -i "s/import {/import { TextField, /g" "$FRONTEND_DIR/src/pages/Profile.js"
echo "Done!"