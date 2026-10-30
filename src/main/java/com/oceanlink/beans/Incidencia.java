package com.oceanlink.beans;

import java.sql.Date;
import java.util.List;

public class Incidencia {
    private int idIncidencia;
    private String identificador;
    private String severidad;
    private String estado;
    private String observaciones;
    private Date fechaRegistro;
    private Date fechaCierre;
    private List<Integer> idsSegmentos;
    private List<Integer> idsServicios;

    public int getIdIncidencia() {
        return idIncidencia;
    }

    public void setIdIncidencia(int idIncidencia) {
        this.idIncidencia = idIncidencia;
    }

    public String getIdentificador() {
        return identificador;
    }

    public void setIdentificador(String identificador) {
        this.identificador = identificador;
    }

    public String getSeveridad() {
        return severidad;
    }

    public void setSeveridad(String severidad) {
        this.severidad = severidad;
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

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Date getFechaCierre() {
        return fechaCierre;
    }

    public void setFechaCierre(Date fechaCierre) {
        this.fechaCierre = fechaCierre;
    }

    public List<Integer> getIdsSegmentos() {
        return idsSegmentos;
    }

    public void setIdsSegmentos(List<Integer> idsSegmentos) {
        this.idsSegmentos = idsSegmentos;
    }

    public List<Integer> getIdsServicios() {
        return idsServicios;
    }

    public void setIdsServicios(List<Integer> idsServicios) {
        this.idsServicios = idsServicios;
    }
}