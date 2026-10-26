package com.oceanlink.servlets;

import com.oceanlink.beans.Segmento;
import com.oceanlink.daos.SegmentoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "ReservaServlet", value = "/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    // Listar reservas
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Segmento> lista;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    lista = segmentoDao.buscarSegmentos(textoBuscar);
                } else {
                    lista = segmentoDao.listarSegmentos();
                }

                request.setAttribute("listaSegmentos", lista);
                view = request.getRequestDispatcher("CapacityPlanner/reservas.jsp");
                view.forward(request, response);
                break;
        }
    }

    // Actualizar reserva
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();

        switch (action) {
            case "actualizar":
                int idSegmento = Integer.parseInt(request.getParameter("idSegmento"));
                double nuevaReserva = Double.parseDouble(request.getParameter("capacidadReservada"));

                Segmento seg = segmentoDao.obtenerSegmento(idSegmento);
                if (seg != null) {
                    double total = seg.getCapacidadTotal().doubleValue();
                    double usada = seg.getCapacidadUsada().doubleValue();

                    if (nuevaReserva >= 0 && (nuevaReserva + usada) <= total) {
                        segmentoDao.actualizarCapacidadReservada(idSegmento, nuevaReserva);
                        response.sendRedirect(request.getContextPath() + "/ReservaServlet");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/ReservaServlet?error=excede");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/ReservaServlet");
                }
                break;
        }
    }
}