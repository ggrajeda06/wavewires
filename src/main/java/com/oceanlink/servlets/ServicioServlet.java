package com.oceanlink.servlets;

import com.oceanlink.daos.ServicioDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ServicioServlet", value = "/ServicioServlet")
public class ServicioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        ServicioDao servicioDao = new ServicioDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                request.setAttribute("listaServicios", servicioDao.listarServicios());
                view = request.getRequestDispatcher("CapacityPlanner/servicios.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                if (servicioDao.eliminarServicio(numero(request.getParameter("id")))) {
                    response.sendRedirect(request.getContextPath() + "/ServicioServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ServicioServlet?error=enUso");
                }
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/ServicioServlet");
                break;
        }
    }

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