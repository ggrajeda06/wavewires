package com.oceanlink.servlets;

import com.oceanlink.beans.Servicio;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.ServicioDao;
import com.oceanlink.util.Listas;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

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
                String buscar = request.getParameter("buscar");
                ArrayList<Servicio> servicios = new ArrayList<>();
                for (Servicio sv : servicioDao.listarServiciosVigentes()) {
                    if (Listas.coincide(buscar, sv.getIdentificador(), sv.getRazonSocial(), "Segmento " + sv.getIdSegmento())) {
                        servicios.add(sv);
                    }
                }
                request.setAttribute("listaServicios", Listas.paginar(request, servicios));
                // con el estado de cada segmento el JSP muestra "En mantenimiento" en sus servicios
                request.setAttribute("listaSegmentos", new SegmentoDao().listarSegmentos());
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