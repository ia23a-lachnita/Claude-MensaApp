package ch.mensaapp.api.controllers;

import ch.mensaapp.api.payload.request.BasketValidationRequest;
import ch.mensaapp.api.payload.response.BasketValidationResponse;
import ch.mensaapp.api.services.BasketService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/basket")
public class BasketController {

    @Autowired
    private BasketService basketService;

    @PostMapping("/validate")
    public ResponseEntity<BasketValidationResponse> validateBasket(@Valid @RequestBody BasketValidationRequest request) {
        return ResponseEntity.ok(basketService.validateBasket(request));
    }
}