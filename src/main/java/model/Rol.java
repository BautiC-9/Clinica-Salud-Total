//Clase Rol
package main.java.model;

public class Rol extends BaseEntity {
    private String nombre;
    private String descripcion;

    // Constructor vacío
    public Rol() {
    }

    // Constructor con parámetros
    public Rol(String nombre, String descripcion) {
        this.nombre = nombre;
        this.descripcion = descripcion;
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

    @Override
    public String toString() {
        return nombre;
    }
}

