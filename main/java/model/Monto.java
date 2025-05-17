// Clase Monto
package main.java.model;

import java.math.BigDecimal;
import java.util.Date;

public class Monto extends BaseEntity {
    private Turno turno;
    private Date fechaPago;
    private BigDecimal monto;
    private Estado estado;

    // Constructor vacío
    public Monto() {
    }

    // Constructor con parámetros
    public Monto(Turno turno, Date fechaPago, BigDecimal monto, Estado estado) {
        this.turno = turno;
        this.fechaPago = fechaPago;
        this.monto = monto;
        this.estado = estado;
    }

    // Getters y Setters
    public Turno getTurno() {
        return turno;
    }

    public void setTurno(Turno turno) {
        this.turno = turno;
    }

    public Date getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Date fechaPago) {
        this.fechaPago = fechaPago;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }
}