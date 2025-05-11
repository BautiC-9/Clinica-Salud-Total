//Clase Profesional
package main.java.model;

public class Profesional extends BaseEntity{
    private Persona persona;
    private String matriculaProfesional;
    private Estado estado;

    // Constructor vacío
    public Profesional() {
    }

    // Constructor con parámetros
    public Profesional(Persona persona, String matriculaProfesional, Estado estado) {
        this.persona = persona;
        this.matriculaProfesional = matriculaProfesional;
        this.estado = estado;
    }

    // Getters y Setters
    public Persona getPersona() {
        return persona;
    }

    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    public String getMatriculaProfesional() {
        return matriculaProfesional;
    }

    public void setMatriculaProfesional(String matriculaProfesional) {
        this.matriculaProfesional = matriculaProfesional;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        if (persona != null) {
            String especialidad = persona.getEspecialidad() != null ? 
                    " (" + persona.getEspecialidad().getNombre() + ")" : "";
            return "Dr. " + persona.getNombreCompleto() + especialidad;
        }
        return "Sin nombre";
    }
}

