//Clase Estado
package main.java.model;

public class Estado extends BaseEntity {
  private String nombre;
    private String descripcion;
    private String tipoEntidad;  // Enum en la BD

    // Constructor vacío
    public Estado() {
    }

    // Constructor con parámetros
    public Estado(String nombre, String descripcion, String tipoEntidad) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.tipoEntidad = tipoEntidad;
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

    public String getTipoEntidad() {
        return tipoEntidad;
    }

    public void setTipoEntidad(String tipoEntidad) {
        this.tipoEntidad = tipoEntidad;
    }

    @Override
    public String toString() {
        return nombre;
    }  
}
