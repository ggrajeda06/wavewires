package com.oceanlink.servlets;

import com.oceanlink.beans.Segmento;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.SegmentoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SegmentoServlet", value = "/SegmentoServlet")
public class SegmentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();
        LandingStationDao landingStationDao = new LandingStationDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                view = request.getRequestDispatcher("Administrador/admin_segmentos.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                int idBorrar = numero(request.getParameter("id"));
                if (segmentoDao.obtenerSegmento(idBorrar) == null || segmentoDao.borrarSegmento(idBorrar)) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=enUso");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();
        LandingStationDao landingStationDao = new LandingStationDao();

        int idSegmento = numero(request.getParameter("idSegmento"));
        int idOrigen = numero(request.getParameter("idOrigen"));
        int idDestino = numero(request.getParameter("idDestino"));
        double capacidadTotal = decimal(request.getParameter("capacidadTotal"));
        String estado = texto(request.getParameter("estado"));

        String error = null;
        if (landingStationDao.obtenerLandingStation(idOrigen) == null || landingStationDao.obtenerLandingStation(idDestino) == null) {
            error = "landing";
        } else if (idOrigen == idDestino) {
            error = "ruta";
        } else if (capacidadTotal <= 0 || capacidadTotal > 99999999) {
            error = "capacidad";
        } else if (!estado.equals("Operativo") && !estado.equals("Degradado")
                && !estado.equals("En mantenimiento") && !estado.equals("Fuera de servicio")) {
            error = "estado";
        }

        switch (action) {
            case "crear":
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=" + error);
                    break;
                }
                segmentoDao.registrarSegmento(idOrigen, idDestino, capacidadTotal, estado);
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;

            case "actualizar":
                Segmento actual = segmentoDao.obtenerSegmento(idSegmento);
                if (actual == null) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                    break;
                }
                // la capacidad total no puede quedar por debajo de lo que ya esta usado y reservado
                double ocupada = actual.getCapacidadUsada().doubleValue() + actual.getCapacidadReservada().doubleValue();
                if (error == null && capacidadTotal < ocupada) {
                    error = "capacidadMenor";
                }
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=" + error);
                    break;
                }
                segmentoDao.actualizarSegmento(idSegmento, idOrigen, idDestino, capacidadTotal, estado);
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;
        }
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