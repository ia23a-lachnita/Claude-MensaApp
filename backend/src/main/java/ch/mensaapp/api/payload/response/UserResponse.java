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
