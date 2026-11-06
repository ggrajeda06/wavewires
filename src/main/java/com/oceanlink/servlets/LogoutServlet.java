package com.oceanlink.servlets;

import com.oceanlink.util.Seguridad;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        Seguridad.evitarCache(response);

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        // Nueva sesión anónima, solo para mostrar un mensaje.
        request.getSession(true).setAttribute(
                "mensajeFlash", "Sesión cerrada correctamente.");

        response.sendRedirect(
                request.getContextPath() + "/LoginServlet");
    }
}
