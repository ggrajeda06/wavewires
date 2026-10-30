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

@WebServlet(name = "ReservaServlet", value = "/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    // Listar reservas
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SegmentoDao segmentoDao = new SegmentoDao();
        request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
        RequestDispatcher view = request.getRequestDispatcher("CapacityPlanner/reservas.jsp");
        view.forward(request, response);
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
                Segmento seg = segmentoDao.obtenerSegmento(numero(request.getParameter("idSegmento")));
                double nuevaReserva = decimal(request.getParameter("capacidadReservada"));

                if (seg == null) {
                    response.sendRedirect(request.getContextPath() + "/ReservaServlet");
                    break;
                }
                double total = seg.getCapacidadTotal().doubleValue();
                double usada = seg.getCapacidadUsada().doubleValue();

                // la reserva no puede ser negativa ni pasar lo que queda libre (RN1)
                if (nuevaReserva < 0 || nuevaReserva + usada > total) {
                    response.sendRedirect(request.getContextPath() + "/ReservaServlet?error=excede");
                    break;
                }
                segmentoDao.actualizarCapacidadReservada(seg.getIdSegmento(), nuevaReserva);
                response.sendRedirect(request.getContextPath() + "/ReservaServlet");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/ReservaServlet");
                break;
        }
    }

    private int numero(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    // si no es numero devuelve -1 para que la validacion lo rechace (aqui 0 si es un valor valido)
    private double decimal(String valor) {
        try {
            double d = Double.parseDouble(valor);
            return Double.isNaN(d) ? -1 : d;
        } catch (NumberFormatException | NullPointerException e) {
            return -1;
        }
    }
}