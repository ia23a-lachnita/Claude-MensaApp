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
    // Account Lock Status
    private final boolean accountNonLocked;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserDetailsImpl(Long id, String email, String password, String vorname, String nachname,
                           boolean mfaEnabled, String mfaSecret, boolean accountNonLocked,
                           Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.vorname = vorname;
        this.nachname = nachname;
        this.mfaEnabled = mfaEnabled;
        this.mfaSecret = mfaSecret;
        this.accountNonLocked = accountNonLocked;
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
                user.isAccountNonLocked(),
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
    public boolean isAccountNonLocked() {
        return accountNonLocked;
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
