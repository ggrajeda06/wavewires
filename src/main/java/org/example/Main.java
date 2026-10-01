package org.example;

import com.oceanlink.beans.LandingStation;
import com.oceanlink.beans.SolicitudCapacidad;
import com.oceanlink.beans.Usuario;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.SolicitudCapacidadDao;
import com.oceanlink.daos.UsuarioDao;

public class Main {
    public static void main(String[] args) {
        System.out.println("=========================================================================================");
        System.out.println("                             OCEANLINK - REPORTE DE QUERIES                              ");
        System.out.println("=========================================================================================\n");

        UsuarioDao usuarioDao = new UsuarioDao();
        LandingStationDao landingDao = new LandingStationDao();
        SolicitudCapacidadDao solicitudDao = new SolicitudCapacidadDao();

        // Imprimir Usuarios
        System.out.println("====================================== USUARIOS ==========================================");
        System.out.printf("| %-7s | %-20s | %-25s | %-18s | %-8s |\n", "ID", "Nombre", "Correo", "Rol", "Estado");
        System.out.println("-----------------------------------------------------------------------------------------");
        for (Usuario u : usuarioDao.listarUsuarios()) {
            String idFormato = String.format("U-%03d", u.getIdUser());
            System.out.printf("| %-7s | %-20s | %-25s | %-18s | %-8s |\n",
                    idFormato, u.getNombre(), u.getCorreo(), u.getRol(), u.getEstado());
        }
        System.out.println("=========================================================================================\n");

        // Imprimir Landing Stations
        System.out.println("================================= LANDING STATIONS =======================================");
        System.out.printf("| %-4s | %-25s | %-25s | %-15s |\n", "ID", "Nombre", "Ubicación (Ciudad, País)", "Estado");
        System.out.println("-----------------------------------------------------------------------------------------");
        for (LandingStation ls : landingDao.listarLandingStations()) {
            String ubicacion = ls.getCiudad() + ", " + ls.getPais();
            System.out.printf("| %-4d | %-25s | %-25s | %-15s |\n",
                    ls.getIdLandingStations(), ls.getNombre(), ubicacion, ls.getEstado());
        }
        System.out.println("=========================================================================================\n");

        // Imprimir Solicitudes de Capacidad
        System.out.println("============================= SOLICITUDES DE CAPACIDAD ===================================");
        System.out.printf("| %-13s | %-18s | %-12s | %-10s | %-15s |\n", "Solicitud", "Ruta", "Capacidad", "Duración", "Estado");
        System.out.println("-----------------------------------------------------------------------------------------");
        for (SolicitudCapacidad sc : solicitudDao.listarSolicitudes()) {
            String idSolicitud = "Solicitud " + sc.getIdSolicitudCapacidad();
            String ruta = sc.getOrigen() + " - " + sc.getDestino();
            String capacidad = sc.getCapacidad() + " GBPS";
            String duracion = sc.getDuracionMeses() + " meses";
            System.out.printf("| %-13s | %-18s | %-12s | %-10s | %-15s |\n",
                    idSolicitud, ruta, capacidad, duracion, sc.getEstado());
        }
        System.out.println("=========================================================================================");
    }
}