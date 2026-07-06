package model;

public class Tache {

    private int id;
    private String nom;
    private String description;
    private String statut;
    private String priorite;
    private int projetId;

    public Tache() {}

    public Tache(int id, String nom, String description, String statut, String priorite, int projetId) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.statut = statut;
        this.priorite = priorite;
        this.projetId = projetId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getPriorite() { return priorite; }
    public void setPriorite(String priorite) { this.priorite = priorite; }

    public int getProjetId() { return projetId; }
    public void setProjetId(int projetId) { this.projetId = projetId; }
}