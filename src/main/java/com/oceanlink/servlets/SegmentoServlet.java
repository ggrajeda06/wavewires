package com.oceanlink.servlets;

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
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                if (segmentoDao.borrarSegmento(idBorrar)) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=enUso");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();

        switch (action) {
            case "crear":
                int idOrigen = Integer.parseInt(request.getParameter("idOrigen"));
                int idDestino = Integer.parseInt(request.getParameter("idDestino"));
                double capacidadTotal = Double.parseDouble(request.getParameter("capacidadTotal"));
                String estado = request.getParameter("estado");

                if (idOrigen == idDestino) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=ruta");
                    break;
                }

                segmentoDao.registrarSegmento(idOrigen, idDestino, capacidadTotal, estado);
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;

            case "actualizar":
                int idSegmento = Integer.parseInt(request.getParameter("idSegmento"));
                int idOrigenEdit = Integer.parseInt(request.getParameter("idOrigen"));
                int idDestinoEdit = Integer.parseInt(request.getParameter("idDestino"));
                double capacidadEdit = Double.parseDouble(request.getParameter("capacidadTotal"));
                String estadoEdit = request.getParameter("estado");

                if (idOrigenEdit == idDestinoEdit) {
                    response.sendRedirect(request.getContextPath() + "/SegmentoServlet?error=ruta");
                    break;
                }

                segmentoDao.actualizarSegmento(idSegmento, idOrigenEdit, idDestinoEdit, capacidadEdit, estadoEdit);
                response.sendRedirect(request.getContextPath() + "/SegmentoServlet");
                break;
        }
    }
}
