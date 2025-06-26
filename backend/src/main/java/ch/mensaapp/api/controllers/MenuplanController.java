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
import java.util.stream.Collectors;

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

    @GetMapping("/zukuenftig")
    public ResponseEntity<List<MenuplanResponse>> getZukuenftigeMenuplaene() {
        return ResponseEntity.ok(menuplanService.getZukuenftigeMenuplaene());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MenuplanResponse> getMenuplanById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(menuplanService.getMenuplanById(id));
    }

    @GetMapping("/verfuegbare-daten")
    public ResponseEntity<List<LocalDate>> getVerfuegbareDaten() {
        List<LocalDate> verfuegbareDaten = menuplanService.getAlleMenuplaene().stream()
                .map(menuplan -> menuplan.getDatum())
                .filter(datum -> !datum.isBefore(LocalDate.now()))
                .sorted()
                .collect(Collectors.toList());
        return ResponseEntity.ok(verfuegbareDaten);
    }

    @GetMapping("/datum/{datum}")
    public ResponseEntity<MenuplanResponse> getMenuplanByDatum(
            @PathVariable("datum") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate datum) {
        return ResponseEntity.ok(menuplanService.getMenuplanByDatum(datum));
    }

    @PostMapping
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<MenuplanResponse> erstelleMenuplan(@Valid @RequestBody MenuplanRequest menuplanRequest) {
        return ResponseEntity.ok(menuplanService.erstelleMenuplan(menuplanRequest));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<MenuplanResponse> aktualisiereMenuplan(@PathVariable("id") Long id, @Valid @RequestBody MenuplanRequest menuplanRequest) {
        return ResponseEntity.ok(menuplanService.aktualisiereMenuplan(id, menuplanRequest));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('MENSA_ADMIN')")
    public ResponseEntity<MessageResponse> loescheMenuplan(@PathVariable("id") Long id) {
        menuplanService.loescheMenuplan(id);
        return ResponseEntity.ok(new MessageResponse("Menuplan erfolgreich gelöscht"));
    }
}
