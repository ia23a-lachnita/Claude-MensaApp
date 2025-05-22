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
