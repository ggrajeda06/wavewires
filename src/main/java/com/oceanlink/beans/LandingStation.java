package com.oceanlink.beans;

public class LandingStation {
    private int idLandingStations;
    private String nombre;
    private String pais;
    private String ciudad;
    private String estado;

    public int getIdLandingStations() {
        return idLandingStations;
    }

    public void setIdLandingStations(int idLandingStations) {
        this.idLandingStations = idLandingStations;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}