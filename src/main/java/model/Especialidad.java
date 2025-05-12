//Clase Especialidad
package main.java.model;

public class Especialidad extends BaseEntity {
    private String nombre;
    private String descripcion;
    private Estado estado;

    // Constructor vacío
    public Especialidad() {
    }

    // Constructor con parámetros
    public Especialidad(String nombre, String descripcion, Estado estado) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.estado = estado;
    }

    // Getters y Setters
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return nombre;
    }
}
