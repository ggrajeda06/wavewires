package com.oceanlink.servlets;

import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Solicitudes;
import com.oceanlink.daos.ClienteDao;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.SolicitudesDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "SolicitudesServlet", value = "/SolicitudesServlet")
public class SolicitudesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SolicitudesDao solicitudesDao = new SolicitudesDao();
        ClienteDao clienteDao = new ClienteDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("listaSolicitudes", solicitudesDao.listarSolicitudes());
                request.setAttribute("listaClientes", clienteDao.listarClientes());
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                view = request.getRequestDispatcher("CapacityPlanner/solicitudes.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                Solicitudes solicitudBorrar = solicitudesDao.obtenerSolicitud(numero(request.getParameter("id")));
                if (solicitudBorrar != null) {
                    solicitudesDao.borrarSolicitud(solicitudBorrar.getIdSolicitudCapacidad());
                }
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SolicitudesDao solicitudesDao = new SolicitudesDao();
        SegmentoDao segmentoDao = new SegmentoDao();

        int idCliente = numero(request.getParameter("idCliente"));
        double capacidad = decimal(request.getParameter("capacidad"));
        String origen = texto(request.getParameter("origen"));
        String destino = texto(request.getParameter("destino"));
        int duracionMeses = numero(request.getParameter("duracionMeses"));
        String observaciones = texto(request.getParameter("observaciones"));

        // datos minimos de cualquier solicitud
        boolean datosMal = new ClienteDao().obtenerCliente(idCliente) == null
                || origen.isEmpty() || destino.isEmpty() || origen.length() > 100 || destino.length() > 100
                || capacidad <= 0 || capacidad > 99999999
                || duracionMeses < 1 || duracionMeses > 120
                || observaciones.length() > 255;

        switch (action) {
            case "crear":
                if (datosMal) {
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=datos");
                    break;
                }
                solicitudesDao.crearSolicitud(capacidad, origen, destino, "Registrado", observaciones, duracionMeses, idCliente);
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;

            case "actualizar":
                Solicitudes actual = solicitudesDao.obtenerSolicitud(numero(request.getParameter("idSolicitudCapacidad")));
                // una solicitud Activa ya es un servicio: no se vuelve a editar
                if (actual == null || actual.getEstado().equals("Activo")) {
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                    break;
                }
                String estado = texto(request.getParameter("estado"));
                Segmento segmento = segmentoDao.obtenerSegmento(numero(request.getParameter("idSegmento")));
                boolean necesitaSegmento = estado.equals("Aprobado") || estado.equals("Provisionado") || estado.equals("Activo");

                if (datosMal) {
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=datos");
                } else if (!estadosPermitidos(actual.getEstado()).contains(estado)) {
                    // RN7: se respeta el flujo de estados
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=estado");
                } else if (necesitaSegmento && segmento == null) {
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=segmento");
                } else if (estado.equals("Provisionado") && capacidad > segmento.getCapacidadReservada().doubleValue()) {
                    // RN2: no se provisiona sin capacidad reservada
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=sinReserva");
                } else if (estado.equals("Activo") && segmento.getEstado().equals("Fuera de servicio")) {
                    // RN3: no se activa un servicio sobre un segmento Fuera de servicio
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=fueraServicio");
                } else if (estado.equals("Activo")
                        && segmento.getCapacidadUsada().doubleValue() + capacidad > segmento.getCapacidadTotal().doubleValue()) {
                    // RN1: lo usado no puede pasar la capacidad total del segmento
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=capacidad");
                } else {
                    Integer idSegmento = segmento == null ? null : segmento.getIdSegmento();
                    solicitudesDao.actualizarSolicitud(actual.getIdSolicitudCapacidad(), capacidad, origen, destino,
                            estado, observaciones, duracionMeses, idSegmento, idCliente);
                    response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;
        }
    }

    // estados a los que puede pasar una solicitud desde su estado actual (incluye quedarse igual)
    private ArrayList<String> estadosPermitidos(String estado) {
        ArrayList<String> estados = new ArrayList<>();
        estados.add(estado);
        if (estado.equals("Registrado")) {
            estados.add("En evaluación");
        } else if (estado.equals("En evaluación")) {
            estados.add("Aprobado");
            estados.add("Rechazado");
        } else if (estado.equals("Aprobado")) {
            estados.add("Provisionado");
            estados.add("Pendiente por Capacidad");
        } else if (estado.equals("Pendiente por Capacidad")) {
            estados.add("Provisionado");
            estados.add("Rechazado");
        } else if (estado.equals("Provisionado")) {
            estados.add("Activo");
        }
        return estados;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private int numero(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private double decimal(String valor) {
        try {
            double d = Double.parseDouble(valor);
            return Double.isNaN(d) ? 0 : d;
        } catch (NumberFormatException | NullPointerException e) {
            return 0;
        }
    }
}