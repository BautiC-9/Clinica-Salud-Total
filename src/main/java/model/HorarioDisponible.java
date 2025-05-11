//Clase HorarioDisponible
package main.java.model;
import java.sql.Time;
public class HorarioDisponible extends BaseEntity {
    private Profesional profesional;
    private String diaSemana;  // Enum en la BD
    private Time horaInicio;
    private Time horaFin;
    private Estado estado;

    // Constructor vacío
    public HorarioDisponible() {
    }

    // Constructor con parámetros
    public HorarioDisponible(Profesional profesional, String diaSemana, Time horaInicio, Time horaFin, Estado estado) {
        this.profesional = profesional;
        this.diaSemana = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.estado = estado;
    }

    // Getters y Setters
    public Profesional getProfesional() {
        return profesional;
    }

    public void setProfesional(Profesional profesional) {
        this.profesional = profesional;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public Time getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(Time horaInicio) {
        this.horaInicio = horaInicio;
    }

    public Time getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(Time horaFin) {
        this.horaFin = horaFin;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return diaSemana + " " + horaInicio + " - " + horaFin;
    }
}
