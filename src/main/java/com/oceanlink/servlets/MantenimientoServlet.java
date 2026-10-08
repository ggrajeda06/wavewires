package com.oceanlink.servlets;

import com.oceanlink.beans.Mantenimiento;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.MantenimientoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "MantenimientoServlet", value = "/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();
        LandingStationDao landingStationDao = new LandingStationDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                ArrayList<Mantenimiento> listaMantenimientos = mantenimientoDao.listarMantenimientos();
                request.setAttribute("lista", listaMantenimientos);
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                view = request.getRequestDispatcher("Maintenance/Mantenimiento.jsp");
                view.forward(request, response);
                break;
            case "formCrear":
                request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                view = request.getRequestDispatcher("Maintenance/registrarMantenimiento.jsp");
                view.forward(request, response);
                break;
            case "editar":
                int idMantenimiento = Integer.parseInt(request.getParameter("id"));
                Mantenimiento mantenimiento = mantenimientoDao.obtenerMantenimiento(idMantenimiento);
                if (mantenimiento == null) {
                    response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                } else {
                    request.setAttribute("mantenimiento", mantenimiento);
                    request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                    view = request.getRequestDispatcher("Maintenance/editarMantenimiento.jsp");
                    view.forward(request, response);
                }
                break;
            case "borrar":
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                if (mantenimientoDao.obtenerMantenimiento(idBorrar) != null) {
                    mantenimientoDao.borrarMantenimiento(idBorrar);
                }
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        MantenimientoDao mantenimientoDao = new MantenimientoDao();

        switch (action) {
            case "crear":
                String nombre = request.getParameter("nombreId");
                String descripcion = request.getParameter("descripcion");
                String tipo = request.getParameter("tipoMantenimiento");
                String estado = request.getParameter("estado");
                String fechaRegistrada = request.getParameter("fecha");
                int duracionHoras = Integer.parseInt(request.getParameter("duracion"));
                int idLandingStation = Integer.parseInt(request.getParameter("idLandingStation"));
                mantenimientoDao.crearMantenimiento(nombre, descripcion, tipo, estado, fechaRegistrada, duracionHoras, idLandingStation);
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
            case "actualizar":
                int idMantenimiento = Integer.parseInt(request.getParameter("id"));
                String nombreEditado = request.getParameter("nombreId");
                String estadoEditado = request.getParameter("estado");
                String actividadesRealizadas = request.getParameter("actividades");
                mantenimientoDao.actualizarMantenimiento(idMantenimiento, nombreEditado, estadoEditado, actividadesRealizadas);
                response.sendRedirect(request.getContextPath() + "/MantenimientoServlet");
                break;
        }
    }
}