package com.oceanlink.beans;

import java.math.BigDecimal;
import java.sql.Date;

public class ServicioAfectado {
    private int idIncidencia;
    private String identificadorIncidencia;
    private int idServicio;
    private String identificadorServicio;
    private BigDecimal capacidad;
    private int idSegmento;
    private String razonSocial;
    private Date fechaRestauracion;

    public int getIdIncidencia() {
        return idIncidencia;
    }

    public void setIdIncidencia(int idIncidencia) {
        this.idIncidencia = idIncidencia;
    }

    public String getIdentificadorIncidencia() {
        return identificadorIncidencia;
    }

    public void setIdentificadorIncidencia(String identificadorIncidencia) {
        this.identificadorIncidencia = identificadorIncidencia;
    }

    public int getIdServicio() {
        return idServicio;
    }

    public void setIdServicio(int idServicio) {
        this.idServicio = idServicio;
    }

    public String getIdentificadorServicio() {
        return identificadorServicio;
    }

    public void setIdentificadorServicio(String identificadorServicio) {
        this.identificadorServicio = identificadorServicio;
    }

    public BigDecimal getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(BigDecimal capacidad) {
        this.capacidad = capacidad;
    }

    public int getIdSegmento() {
        return idSegmento;
    }

    public void setIdSegmento(int idSegmento) {
        this.idSegmento = idSegmento;
    }

    public String getRazonSocial() {
        return razonSocial;
    }

    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    public Date getFechaRestauracion() {
        return fechaRestauracion;
    }

    public void setFechaRestauracion(Date fechaRestauracion) {
        this.fechaRestauracion = fechaRestauracion;
    }
}