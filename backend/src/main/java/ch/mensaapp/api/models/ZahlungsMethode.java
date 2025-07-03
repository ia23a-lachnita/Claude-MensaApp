package ch.mensaapp.api.models;

public enum ZahlungsMethode {
    KREDITKARTE("Kreditkarte"),
    DEBITKARTE("Debitkarte"),
    TWINT("TWINT");

    private final String displayName;

    ZahlungsMethode(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}