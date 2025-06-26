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
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
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
            @PathVariable("datum") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(menuService.getMenuplanFuerDatum(datum));
    }

    @GetMapping("/woche")
    public ResponseEntity<List<MenuplanResponse>> getMenuFuerWoche(
            @RequestParam(value = "startDatum", required = false) String startDatum) {
        LocalDate date;

        if (startDatum == null) {
            date = LocalDate.now();
        } else {
            // Handle both date formats: "2025-06-05" and "2025-06-05T09:19:48.213Z"
            try {
                if (startDatum.contains("T")) {
                    // It's a full timestamp, extract just the date part
                    date = OffsetDateTime.parse(startDatum).toLocalDate();
                } else {
                    // It's already just a date
                    date = LocalDate.parse(startDatum);
                }
            } catch (Exception e) {
                // Fallback to today if parsing fails
                date = LocalDate.now();
            }
        }

        return ResponseEntity.ok(menuService.getMenuplanFuerWoche(date));
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
