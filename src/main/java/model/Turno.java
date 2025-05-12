// Clase Turno
package main.java.model;

import java.sql.Timestamp;
import java.util.Date;

public class Turno extends BaseEntity {
    private Paciente paciente;
    private Profesional profesional;
    private Date fechaHora;
    private Integer duracion;  // Minutos
    private Estado estado;
    private String observaciones;
    private Timestamp fechaCreacion;
    private Timestamp ultimaModificacion;

    // Constructor vacío
    public Turno() {
    }

    // Constructor con parámetros principales
    public Turno(Paciente paciente, Profesional profesional, Date fechaHora, Integer duracion, Estado estado) {
        this.paciente = paciente;
        this.profesional = profesional;
        this.fechaHora = fechaHora;
        this.duracion = duracion;
        this.estado = estado;
    }

    // Getters y Setters
    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public Profesional getProfesional() {
        return profesional;
    }

    public void setProfesional(Profesional profesional) {
        this.profesional = profesional;
    }

    public Date getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(Date fechaHora) {
        this.fechaHora = fechaHora;
    }

    public Integer getDuracion() {
        return duracion;
    }

    public void setDuracion(Integer duracion) {
        this.duracion = duracion;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Timestamp getUltimaModificacion() {
        return ultimaModificacion;
    }

    public void setUltimaModificacion(Timestamp ultimaModificacion) {
        this.ultimaModificacion = ultimaModificacion;
    }
}