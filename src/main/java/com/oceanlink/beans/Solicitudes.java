package com.oceanlink.beans;

import java.sql.Timestamp;

public class Solicitudes {

    private int idSolicitudCapacidad;
    private double capacidad;
    private String origen;
    private String destino;
    private String estado;
    private String observaciones;
    private Timestamp fechaRegistroSolicitud;
    private int duracionMeses;
    private Integer idSegmento; // Acá usamos el tipo Integer para poder permitir null cuando esté en "No asignado"
    private int idCliente;

    public Solicitudes() {
    }

    public int getIdSolicitudCapacidad() {
        return idSolicitudCapacidad;
    }

    public void setIdSolicitudCapacidad(int idSolicitudCapacidad) {
        this.idSolicitudCapacidad = idSolicitudCapacidad;
    }

    public double getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(double capacidad) {
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

    public Integer getIdSegmento() {
        return idSegmento;
    }

    public void setIdSegmento(Integer idSegmento) {
        this.idSegmento = idSegmento;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }
}