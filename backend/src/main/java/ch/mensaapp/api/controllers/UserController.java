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
