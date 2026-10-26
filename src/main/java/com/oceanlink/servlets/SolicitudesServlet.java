package com.oceanlink.servlets;

import com.oceanlink.beans.Cliente;
import com.oceanlink.beans.Segmento;
import com.oceanlink.beans.Solicitudes;
import com.oceanlink.daos.ClienteDao;
import com.oceanlink.daos.SegmentoDao;
import com.oceanlink.daos.SolicitudesDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "SolicitudesServlet", value = "/SolicitudesServlet")
public class SolicitudesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SolicitudesDao solicitudesDao = new SolicitudesDao();
        ClienteDao clienteDao = new ClienteDao();
        SegmentoDao segmentoDao = new SegmentoDao();
        RequestDispatcher view;

        switch (action) {
            case "lista":
                String textoBuscar = request.getParameter("buscar");
                ArrayList<Solicitudes> lista;

                if (textoBuscar != null && !textoBuscar.trim().isEmpty()) {
                    lista = solicitudesDao.buscarSolicitudes(textoBuscar);
                } else {
                    lista = solicitudesDao.listarSolicitudes();
                }

                // Guardamos en el request las solicitudes y clientes para los comboboxes
                request.setAttribute("listaSolicitudes", lista);
                request.setAttribute("listaClientes", clienteDao.listarClientes());
                request.setAttribute("listaSegmentos", segmentoDao.listarSegmentos());

                view = request.getRequestDispatcher("CapacityPlanner/solicitudes.jsp");
                view.forward(request, response);
                break;

            case "borrar":
                int idBorrar = Integer.parseInt(request.getParameter("id"));
                solicitudesDao.borrarSolicitud(idBorrar);
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action") == null ? "lista" : request.getParameter("action");
        SolicitudesDao solicitudesDao = new SolicitudesDao();

        switch (action) {
            case "crear":
                int idCliente = Integer.parseInt(request.getParameter("idCliente"));
                double capacidad = Double.parseDouble(request.getParameter("capacidad"));
                String origen = request.getParameter("origen");
                String destino = request.getParameter("destino");
                int duracionMeses = Integer.parseInt(request.getParameter("duracionMeses"));
                String observaciones = request.getParameter("observaciones");

                // Estado inicial 'Registrado' según la regla 1 del flujo de Miro
                solicitudesDao.crearSolicitud(capacidad, origen, destino, "Registrado", observaciones, duracionMeses, idCliente);
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;

            case "actualizar":
                int idSolicitud = Integer.parseInt(request.getParameter("idSolicitudCapacidad"));
                int idClienteEdit = Integer.parseInt(request.getParameter("idCliente"));
                double capacidadEdit = Double.parseDouble(request.getParameter("capacidad"));
                String origenEdit = request.getParameter("origen");
                String destinoEdit = request.getParameter("destino");
                String estadoEdit = request.getParameter("estado");
                int duracionEdit = Integer.parseInt(request.getParameter("duracionMeses"));
                String observacionesEdit = request.getParameter("observaciones");

                String strSegmento = request.getParameter("idSegmento");
                Integer idSegmentoEdit = null;
                if (strSegmento != null && !strSegmento.equals("0") && !strSegmento.trim().isEmpty()) {
                    idSegmentoEdit = Integer.parseInt(strSegmento);
                }

                if ("Provisionado".equalsIgnoreCase(estadoEdit) && idSegmentoEdit != null && idSegmentoEdit != 0) {
                    SegmentoDao segDao = new SegmentoDao();
                    Segmento seg = segDao.obtenerSegmento(idSegmentoEdit);
                    double reservada = (seg != null && seg.getCapacidadReservada() != null) ? seg.getCapacidadReservada().doubleValue() : 0.0;
                    if (capacidadEdit > reservada) {
                        response.sendRedirect(request.getContextPath() + "/SolicitudesServlet?error=sinReserva");
                        break;
                    }
                }

                solicitudesDao.actualizarSolicitud(idSolicitud, capacidadEdit, origenEdit, destinoEdit,
                        estadoEdit, observacionesEdit, duracionEdit, idSegmentoEdit, idClienteEdit);
                response.sendRedirect(request.getContextPath() + "/SolicitudesServlet");
                break;
        }
    }
}