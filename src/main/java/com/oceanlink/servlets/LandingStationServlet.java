package com.oceanlink.servlets;

import com.oceanlink.beans.LandingStation;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.SegmentoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "LandingStationServlet", value = "/LandingStationServlet")
public class LandingStationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        LandingStationDao landingStationDao = new LandingStationDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                ArrayList<LandingStation> listaLandings = landingStationDao.listarLandingStations();
                request.setAttribute("lista", listaLandings);
                view = request.getRequestDispatcher("Administrador/admin_landings.jsp");
                view.forward(request, response);
                break;
            case "formCrear":
                view = request.getRequestDispatcher("Administrador/admin_landing_form.jsp");
                view.forward(request, response);
                break;
            case "editar":
                int idLanding = numero(request.getParameter("id"));
                LandingStation landing = landingStationDao.obtenerLandingStation(idLanding);
                if (landing == null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else {
                    request.setAttribute("landing", landing);
                    view = request.getRequestDispatcher("Administrador/admin_landing_editar.jsp");
                    view.forward(request, response);
                }
                break;
            case "verSegmentos":
                int idVer = numero(request.getParameter("id"));
                LandingStation landingVer = landingStationDao.obtenerLandingStation(idVer);
                if (landingVer == null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else {
                    request.setAttribute("landing", landingVer);
                    request.setAttribute("listaSegmentos", segmentoDao.listarSegmentosPorLanding(idVer));
                    request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                    view = request.getRequestDispatcher("Administrador/admin_landing_segmentos.jsp");
                    view.forward(request, response);
                }
                break;
            case "borrar":
                int idBorrar = numero(request.getParameter("id"));
                if (landingStationDao.obtenerLandingStation(idBorrar) == null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else if (landingStationDao.borrarLandingStation(idBorrar)) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet?error=noBorrado");
                }
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        LandingStationDao landingStationDao = new LandingStationDao();

        String nombre = texto(request.getParameter("nombre"));
        String pais = texto(request.getParameter("pais"));
        String ciudad = texto(request.getParameter("ciudad"));
        String estado = texto(request.getParameter("estado"));

        String error = null;
        if (nombre.isEmpty() || pais.isEmpty() || ciudad.isEmpty()) {
            error = "vacio";
        } else if (nombre.length() > 100 || pais.length() > 100 || ciudad.length() > 100) {
            error = "largo";
        } else if (!estado.equals("Operativa") && !estado.equals("Degradada")
                && !estado.equals("En mantenimiento") && !estado.equals("Fuera de servicio")) {
            error = "estado";
        }

        switch (action) {
            case "crear":
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet?action=formCrear&error=" + error);
                    break;
                }
                landingStationDao.crearLandingStation(nombre, pais, ciudad, estado);
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                break;
            case "actualizar":
                int idLanding = numero(request.getParameter("id"));
                if (landingStationDao.obtenerLandingStation(idLanding) == null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                    break;
                }
                if (error != null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet?action=editar&id=" + idLanding + "&error=" + error);
                    break;
                }
                landingStationDao.actualizarLandingStation(idLanding, nombre, pais, ciudad, estado);
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
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
}