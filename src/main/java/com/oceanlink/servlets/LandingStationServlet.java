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
                int idLanding = Integer.parseInt(request.getParameter("id"));
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
                int idVer = Integer.parseInt(request.getParameter("id"));
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
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                if (landingStationDao.obtenerLandingStation(idBorrar) == null) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else if (landingStationDao.borrarLandingStation(idBorrar)) {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/LandingStationServlet?error=noBorrado");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        LandingStationDao landingStationDao = new LandingStationDao();

        switch (action) {
            case "crear":
                String nombre = request.getParameter("nombre");
                String pais = request.getParameter("pais");
                String ciudad = request.getParameter("ciudad");
                String estado = request.getParameter("estado");
                landingStationDao.crearLandingStation(nombre, pais, ciudad, estado);
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                break;
            case "actualizar":
                int idLanding = Integer.parseInt(request.getParameter("id"));
                String nombreEditado = request.getParameter("nombre");
                String paisEditado = request.getParameter("pais");
                String ciudadEditada = request.getParameter("ciudad");
                String estadoEditado = request.getParameter("estado");
                landingStationDao.actualizarLandingStation(idLanding, nombreEditado, paisEditado, ciudadEditada, estadoEditado);
                response.sendRedirect(request.getContextPath() + "/LandingStationServlet");
                break;
        }
    }
}