package com.oceanlink.servlets;

import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.ResumenDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import com.oceanlink.util.Seguridad;

// RF06: resumen del Administrador. Cada dato lo trae un metodo de ResumenDao (un SELECT cada uno).
@WebServlet(name = "ResumenServlet", value = "/ResumenServlet")
public class ResumenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN)) {
            return;
        }

        ResumenDao resumenDao = new ResumenDao();

        // tarjetas de arriba
        request.setAttribute("totalUsuarios", resumenDao.contarUsuarios());
        request.setAttribute("usuariosActivos", resumenDao.contarUsuariosActivos());
        request.setAttribute("totalLandings", resumenDao.contarLandings());
        request.setAttribute("totalSegmentos", resumenDao.contarSegmentos());
        request.setAttribute("segmentosOperativos", resumenDao.contarSegmentosOperativos());
        request.setAttribute("incidenciasAbiertas", resumenDao.contarIncidenciasAbiertas());

        // tablas
        request.setAttribute("cuentasPorRol", resumenDao.listarCuentasActivasPorRol());
        request.setAttribute("segmentosNoOperativos", resumenDao.listarSegmentosNoOperativos());
        request.setAttribute("ultimasIncidencias", resumenDao.listarUltimasIncidencias());
        request.setAttribute("proximosMantenimientos", resumenDao.listarProximosMantenimientos());

        // para mostrar el nombre de la landing en los mantenimientos que son sobre una landing
        request.setAttribute("listaLandings", new LandingStationDao().listarLandingStations());

        RequestDispatcher view = request.getRequestDispatcher("/WEB-INF/views/Administrador/admin_resumen.jsp");
        view.forward(request, response);
    }

    // el login todavia manda aqui con POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!Seguridad.permitir(
                request,
                response,
                Seguridad.ADMIN)) {
            return;
        }
        doGet(request, response);
    }
}