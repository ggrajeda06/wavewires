package com.oceanlink.beans;

import java.math.BigDecimal;

public class Segmento {
    private int idSegmento;
    private int idOrigen;
    private int idDestino;
    private BigDecimal capacidadTotal;
    private BigDecimal capacidadUsada;
    private BigDecimal capacidadReservada;
    private String estado;
    private String nombreOrigen;
    private String nombreDestino;

    public int getIdSegmento() {
        return idSegmento;
    }

    public void setIdSegmento(int idSegmento) {
        this.idSegmento = idSegmento;
    }

    public int getIdOrigen() {
        return idOrigen;
    }

    public void setIdOrigen(int idOrigen) {
        this.idOrigen = idOrigen;
    }

    public int getIdDestino() {
        return idDestino;
    }

    public void setIdDestino(int idDestino) {
        this.idDestino = idDestino;
    }

    public BigDecimal getCapacidadTotal() {
        return capacidadTotal;
    }

    public void setCapacidadTotal(BigDecimal capacidadTotal) {
        this.capacidadTotal = capacidadTotal;
    }

    public BigDecimal getCapacidadUsada() {
        return capacidadUsada;
    }

    public void setCapacidadUsada(BigDecimal capacidadUsada) {
        this.capacidadUsada = capacidadUsada;
    }

    public BigDecimal getCapacidadReservada() {
        return capacidadReservada;
    }

    public void setCapacidadReservada(BigDecimal capacidadReservada) {
        this.capacidadReservada = capacidadReservada;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombreOrigen() {
        return nombreOrigen;
    }

    public void setNombreOrigen(String nombreOrigen) {
        this.nombreOrigen = nombreOrigen;
    }

    public String getNombreDestino() {
        return nombreDestino;
    }

    public void setNombreDestino(String nombreDestino) {
        this.nombreDestino = nombreDestino;
    }
}