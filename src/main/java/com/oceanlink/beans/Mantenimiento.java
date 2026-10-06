package com.oceanlink.beans;

import java.sql.Date;

public class Mantenimiento {
    private int idMantenimiento;
    private String nombre;
    private String descripcion;
    private String tipo;
    private String estado;
    private Date fechaRegistrada;
    private int duracionHoras;
    private String actividadesRealizadas;
    private int idLandingStation;

    public int getIdMantenimiento() {
        return idMantenimiento;
    }

    public void setIdMantenimiento(int idMantenimiento) {
        this.idMantenimiento = idMantenimiento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFechaRegistrada() {
        return fechaRegistrada;
    }

    public void setFechaRegistrada(Date fechaRegistrada) {
        this.fechaRegistrada = fechaRegistrada;
    }

    public int getDuracionHoras() {
        return duracionHoras;
    }

    public void setDuracionHoras(int duracionHoras) {
        this.duracionHoras = duracionHoras;
    }

    public String getActividadesRealizadas() {
        return actividadesRealizadas;
    }

    public void setActividadesRealizadas(String actividadesRealizadas) {
        this.actividadesRealizadas = actividadesRealizadas;
    }

    public int getIdLandingStation() {
        return idLandingStation;
    }

    public void setIdLandingStation(int idLandingStation) {
        this.idLandingStation = idLandingStation;
    }
}