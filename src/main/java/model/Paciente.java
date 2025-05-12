// Clase Paciente
package main.java.model;

public class Paciente extends BaseEntity {
    private Persona persona;
    private String obraSocial;
    private Estado estado;

    // Constructor vacío
    public Paciente() {
    }

    // Constructor con parámetros
    public Paciente(Persona persona, String obraSocial, Estado estado) {
        this.persona = persona;
        this.obraSocial = obraSocial;
        this.estado = estado;
    }

    // Getters y Setters
    public Persona getPersona() {
        return persona;
    }

    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    public String getObraSocial() {
        return obraSocial;
    }

    public void setObraSocial(String obraSocial) {
        this.obraSocial = obraSocial;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return persona != null ? persona.getNombreCompleto() : "Sin nombre";
    }
}