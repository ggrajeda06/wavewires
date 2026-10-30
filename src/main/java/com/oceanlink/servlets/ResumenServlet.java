package com.oceanlink.servlets;

import com.oceanlink.beans.LandingStation;
import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Usuario;
import com.oceanlink.daos.LandingStationDao;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.UsuarioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

// RF06: resumen del Administrador con lo que el administra
@WebServlet(name = "ResumenServlet", value = "/ResumenServlet")
public class ResumenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Usuario> usuarios = new UsuarioDao().listarUsuarios();
        ArrayList<LandingStation> landings = new LandingStationDao().listarLandingStations();
        ArrayList<Segmento> segmentos = new SegmentoDao().listarSegmentos();

        int usuariosActivos = 0;
        for (Usuario u : usuarios) {
            if (u.getEstado().equals("Activo")) {
                usuariosActivos++;
            }
        }

        int landingsOperativas = 0;
        for (LandingStation ls : landings) {
            if (ls.getEstado().equals("Operativa")) {
                landingsOperativas++;
            }
        }

        int segmentosOperativos = 0;
        for (Segmento s : segmentos) {
            if (s.getEstado().equals("Operativo")) {
                segmentosOperativos++;
            }
        }

        request.setAttribute("totalUsuarios", usuarios.size());
        request.setAttribute("usuariosActivos", usuariosActivos);
        request.setAttribute("totalLandings", landings.size());
        request.setAttribute("landingsOperativas", landingsOperativas);
        request.setAttribute("totalSegmentos", segmentos.size());
        request.setAttribute("segmentosOperativos", segmentosOperativos);

        RequestDispatcher view = request.getRequestDispatcher("Administrador/admin_resumen.jsp");
        view.forward(request, response);
    }

    // el login todavia manda aqui con POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}