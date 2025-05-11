//Clase Usuario
package main.java.model;

public class Usuario extends BaseEntity {
     private String nombreUsuario;
    private String contrasena;
    private Persona persona;
    private Estado estado;

    // Constructor vacío
    public Usuario() {
    }

    // Constructor con parámetros
    public Usuario(String nombreUsuario, String contrasena, Persona persona, Estado estado) {
        this.nombreUsuario = nombreUsuario;
        this.contrasena = contrasena;
        this.persona = persona;
        this.estado = estado;
    }

    // Getters y Setters
    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public Persona getPersona() {
        return persona;
    }

    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return nombreUsuario;
    }
}
