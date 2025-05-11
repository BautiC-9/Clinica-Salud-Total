//Clase HistorialEstadoTurno
package main.java.model;
import java.sql.Timestamp;

public class HistorialEstadoTurno extends BaseEntity{
    private Turno turno;
    private Timestamp fechaCambio;
    private Estado estadoAnterior;
    private Estado estadoNuevo;
    private String observacion;

    // Constructor vacío
    public HistorialEstadoTurno() {
    }

    // Constructor con parámetros
    public HistorialEstadoTurno(Turno turno, Estado estadoAnterior, Estado estadoNuevo) {
        this.turno = turno;
        this.estadoAnterior = estadoAnterior;
        this.estadoNuevo = estadoNuevo;
        this.fechaCambio = new Timestamp(System.currentTimeMillis());
    }

    // Getters y Setters
    public Turno getTurno() {
        return turno;
    }

    public void setTurno(Turno turno) {
        this.turno = turno;
    }

    public Timestamp getFechaCambio() {
        return fechaCambio;
    }

    public void setFechaCambio(Timestamp fechaCambio) {
        this.fechaCambio = fechaCambio;
    }

    public Estado getEstadoAnterior() {
        return estadoAnterior;
    }

    public void setEstadoAnterior(Estado estadoAnterior) {
        this.estadoAnterior = estadoAnterior;
    }

    public Estado getEstadoNuevo() {
        return estadoNuevo;
    }

    public void setEstadoNuevo(Estado estadoNuevo) {
        this.estadoNuevo = estadoNuevo;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
}
