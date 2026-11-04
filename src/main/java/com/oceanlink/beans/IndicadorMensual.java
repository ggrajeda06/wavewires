package com.oceanlink.beans;

import java.math.BigDecimal;

public class IndicadorMensual {
    private int mes;
    private int incidenciasDetectadas;
    private int incidenciasCerradas;
    private int mantenimientosProgramados;
    private int solicitudesRegistradas;
    private int serviciosActivados;
    private BigDecimal capacidadActivada = BigDecimal.ZERO;

    public int getMes() {
        return mes;
    }

    public void setMes(int mes) {
        this.mes = mes;
    }

    public int getIncidenciasDetectadas() {
        return incidenciasDetectadas;
    }

    public void setIncidenciasDetectadas(int incidenciasDetectadas) {
        this.incidenciasDetectadas = incidenciasDetectadas;
    }

    public int getIncidenciasCerradas() {
        return incidenciasCerradas;
    }

    public void setIncidenciasCerradas(int incidenciasCerradas) {
        this.incidenciasCerradas = incidenciasCerradas;
    }

    public int getMantenimientosProgramados() {
        return mantenimientosProgramados;
    }

    public void setMantenimientosProgramados(int mantenimientosProgramados) {
        this.mantenimientosProgramados = mantenimientosProgramados;
    }

    public int getSolicitudesRegistradas() {
        return solicitudesRegistradas;
    }

    public void setSolicitudesRegistradas(int solicitudesRegistradas) {
        this.solicitudesRegistradas = solicitudesRegistradas;
    }

    public int getServiciosActivados() {
        return serviciosActivados;
    }

    public void setServiciosActivados(int serviciosActivados) {
        this.serviciosActivados = serviciosActivados;
    }

    public BigDecimal getCapacidadActivada() {
        return capacidadActivada;
    }

    public void setCapacidadActivada(BigDecimal capacidadActivada) {
        this.capacidadActivada = capacidadActivada;
    }
}
