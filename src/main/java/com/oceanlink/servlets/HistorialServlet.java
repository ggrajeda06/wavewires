package com.oceanlink.servlets;

import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.ServicioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "HistorialServlet", value = "/HistorialServlet")
public class HistorialServlet extends HttpServlet {

    // Listar historial de segmentos y caducados
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SegmentoDao segmentoDao = new SegmentoDao();
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());
                request.setAttribute("listaServiciosCaducados", servicioDao.listarServiciosCaducados());

                view = request.getRequestDispatcher("CapacityPlanner/historial.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                if (servicioDao.eliminarServicioPermanente(numero(request.getParameter("id")))) {
                    response.sendRedirect(request.getContextPath() + "/HistorialServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/HistorialServlet?error=enUso");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/HistorialServlet");
                break;
        }
    }

    // Procesar peticiones POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    private int numero(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}