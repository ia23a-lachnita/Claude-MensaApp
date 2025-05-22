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
