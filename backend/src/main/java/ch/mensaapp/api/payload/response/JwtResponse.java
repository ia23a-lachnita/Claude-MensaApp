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
