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

@WebServlet(name = "CapacidadServlet", value = "/CapacidadServlet")
public class CapacidadServlet extends HttpServlet {

    // Listar capacidad de red
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SegmentoDao segmentoDao = new SegmentoDao();
        ArrayList<Segmento> todosSegmentos = segmentoDao.listarSegmentos();

        // Calcular metricas globales de red
        int totalRed = 0;
        int usadaRed = 0;
        int reservadaRed = 0;

        for (Segmento s : todosSegmentos) {
            int tot = s.getCapacidadTotal() != null ? s.getCapacidadTotal().intValue() : 0;
            int usd = s.getCapacidadUsada() != null ? s.getCapacidadUsada().intValue() : 0;
            int res = s.getCapacidadReservada() != null ? s.getCapacidadReservada().intValue() : 0;

            totalRed += tot;
            usadaRed += usd;
            reservadaRed += res;
        }

        int disponibleRed = Math.max(0, totalRed - usadaRed - reservadaRed);

        request.setAttribute("totalRed", totalRed);
        request.setAttribute("usadaRed", usadaRed);
        request.setAttribute("reservadaRed", reservadaRed);
        request.setAttribute("disponibleRed", disponibleRed);
        request.setAttribute("listaSegmentos", todosSegmentos);

        RequestDispatcher view = request.getRequestDispatcher("CapacityPlanner/capacidad.jsp");
        view.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }
}