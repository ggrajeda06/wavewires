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

        // Filtrar tabla por segmento, ruta o estado
        String textoBuscar = request.getParameter("buscar");
        ArrayList<Segmento> listaFiltrada = new ArrayList<>();

        if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
            String query = textoBuscar.trim().toLowerCase();
            for (Segmento s : todosSegmentos) {
                int tot = s.getCapacidadTotal() != null ? s.getCapacidadTotal().intValue() : 0;
                int usd = s.getCapacidadUsada() != null ? s.getCapacidadUsada().intValue() : 0;
                int res = s.getCapacidadReservada() != null ? s.getCapacidadReservada().intValue() : 0;
                int ocupada = usd + res;
                double pct = (tot > 0) ? ((double) ocupada / tot) * 100.0 : 0.0;

                String estadoUso = "";
                if (pct < 80.0) {
                    estadoUso = "normal < 80%";
                } else if (pct <= 95.0) {
                    estadoUso = "alto uso 80% - 95%";
                } else {
                    estadoUso = "uso critico uso crítico > 95%";
                }

                String nombreSeg = ("Segmento " + s.getIdSegmento()).toLowerCase();
                String ruta = (s.getNombreOrigen() + " - " + s.getNombreDestino()).toLowerCase();
                String estadoBd = s.getEstado() != null ? s.getEstado().toLowerCase() : "";

                if (nombreSeg.contains(query) || ruta.contains(query) || estadoUso.contains(query) || estadoBd.contains(query)) {
                    listaFiltrada.add(s);
                }
            }
        } else {
            listaFiltrada = todosSegmentos;
        }

        request.setAttribute("totalRed", totalRed);
        request.setAttribute("usadaRed", usadaRed);
        request.setAttribute("reservadaRed", reservadaRed);
        request.setAttribute("disponibleRed", disponibleRed);
        request.setAttribute("listaSegmentos", listaFiltrada);

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