package com.oceanlink.beans;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SolicitudCapacidad {
    private int idSolicitudCapacidad;
    private BigDecimal capacidad;
    private String origen;
    private String destino;
    private String estado;
    private String observaciones;
    private Timestamp fechaRegistroSolicitud;
    private int duracionMeses;
    private int idSegmentos;
    private int idCliente;

    public int getIdSolicitudCapacidad() {
        return idSolicitudCapacidad;
    }

    public void setIdSolicitudCapacidad(int idSolicitudCapacidad) {
        this.idSolicitudCapacidad = idSolicitudCapacidad;
    }

    public BigDecimal getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(BigDecimal capacidad) {
        this.capacidad = capacidad;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Timestamp getFechaRegistroSolicitud() {
        return fechaRegistroSolicitud;
    }

    public void setFechaRegistroSolicitud(Timestamp fechaRegistroSolicitud) {
        this.fechaRegistroSolicitud = fechaRegistroSolicitud;
    }

    public int getDuracionMeses() {
        return duracionMeses;
    }

    public void setDuracionMeses(int duracionMeses) {
        this.duracionMeses = duracionMeses;
    }

    public int getIdSegmentos() {
        return idSegmentos;
    }

    public void setIdSegmentos(int idSegmentos) {
        this.idSegmentos = idSegmentos;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }
}