package com.oceanlink.servlets;

import com.oceanlink.beans.Incidencia;
import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.IncidenciaDao;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.ServicioDao;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "IncidenciaServlet", value = "/IncidenciaServlet")
public class IncidenciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        LandingStationDao landingStationDao = new LandingStationDao();
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        try {
            switch (action) {
                case "lista":
                    ArrayList<Incidencia> listaIncidencias = incidenciaDao.listarIncidencias();
                    request.setAttribute("lista", listaIncidencias);
                    request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                    request.setAttribute("listaServicios", servicioDao.listarServicios());
                    view = request.getRequestDispatcher("NetworkOperator/incidencias.jsp");
                    view.forward(request, response);
                    break;

                case "formCrear":
                    request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                    request.setAttribute("listaServicios", servicioDao.listarServicios());
                    view = request.getRequestDispatcher("NetworkOperator/incidencias_form.jsp");
                    view.forward(request, response);
                    break;

                case "editar":
                    int idIncidencia = Integer.parseInt(request.getParameter("id"));
                    Incidencia incidencia = incidenciaDao.obtenerIncidencia(idIncidencia);
                    if (incidencia == null) {
                        response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    } else {
                        request.setAttribute("incidencia", incidencia);
                        request.setAttribute("listaLandings", landingStationDao.listarLandingStations());
                        request.setAttribute("listaServicios", servicioDao.listarServicios());
                        view = request.getRequestDispatcher("NetworkOperator/incidencias_form.jsp");
                        view.forward(request, response);
                    }
                    break;

                case "borrar":
                    int idBorrar = Integer.parseInt(request.getParameter("id"));
                    if (incidenciaDao.obtenerIncidencia(idBorrar) != null) {
                        incidenciaDao.eliminarIncidencia(idBorrar);
                    }
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        IncidenciaDao incidenciaDao = new IncidenciaDao();
        ServicioDao servicioDao = new ServicioDao();

        try {
            switch (action) {
                case "crear":
                    String identificador = request.getParameter("identificador");
                    String severidad = request.getParameter("severidad");
                    String estado = request.getParameter("estado");
                    String observaciones = request.getParameter("observaciones");
                    int idLandingStation = Integer.parseInt(request.getParameter("idLandingStation"));

                    List<Integer> idsServiciosList = new ArrayList<>();
                    for (Servicio sv : servicioDao.listarServiciosPorLanding(idLandingStation)) {
                        idsServiciosList.add(sv.getIdServicio());
                    }

                    Incidencia nuevaIncidencia = new Incidencia();
                    nuevaIncidencia.setIdentificador(identificador);
                    nuevaIncidencia.setSeveridad(severidad);
                    nuevaIncidencia.setEstado(estado);
                    nuevaIncidencia.setObservaciones(observaciones);
                    nuevaIncidencia.setIdLandingStation(idLandingStation);
                    nuevaIncidencia.setIdsServicios(idsServiciosList);

                    incidenciaDao.crearIncidencia(nuevaIncidencia);
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    break;

                case "actualizar":
                    int idIncidencia = Integer.parseInt(request.getParameter("id"));
                    String identificadorEdit = request.getParameter("identificador");
                    String severidadEdit = request.getParameter("severidad");
                    String estadoEdit = request.getParameter("estado");
                    String observacionesEdit = request.getParameter("observaciones");
                    int idLandingEdit = Integer.parseInt(request.getParameter("idLandingStation"));

                    List<Integer> idsServiciosEditList = new ArrayList<>();
                    for (Servicio sv : servicioDao.listarServiciosPorLanding(idLandingEdit)) {
                        idsServiciosEditList.add(sv.getIdServicio());
                    }

                    Incidencia incidenciaEditada = new Incidencia();
                    incidenciaEditada.setIdIncidencia(idIncidencia);
                    incidenciaEditada.setIdentificador(identificadorEdit);
                    incidenciaEditada.setSeveridad(severidadEdit);
                    incidenciaEditada.setEstado(estadoEdit);
                    incidenciaEditada.setObservaciones(observacionesEdit);
                    incidenciaEditada.setIdLandingStation(idLandingEdit);
                    incidenciaEditada.setIdsServicios(idsServiciosEditList);

                    incidenciaDao.editarIncidencia(incidenciaEditada);
                    response.sendRedirect(request.getContextPath() + "/IncidenciaServlet");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}