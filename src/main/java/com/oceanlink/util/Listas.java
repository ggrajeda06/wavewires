package com.oceanlink.util;

import jakarta.servlet.http.HttpServletRequest;

import java.text.Normalizer;
import java.util.ArrayList;

public class Listas {

    private static final int FILAS_POR_PAGINA = 10;

    // true si lo buscado aparece en alguno de los campos, sin distinguir mayusculas ni tildes
    public static boolean coincide(String buscar, String... campos) {
        if (buscar == null || buscar.trim().isEmpty()) {
            return true;
        }
        String texto = normalizar(buscar.trim());
        for (String campo : campos) {
            if (campo != null && normalizar(campo).contains(texto)) {
                return true;
            }
        }
        return false;
    }

    private static String normalizar(String texto) {
        return Normalizer.normalize(texto, Normalizer.Form.NFD).replaceAll("\\p{M}", "").toLowerCase();
    }

    // devuelve solo la pagina pedida y deja en el request los datos que usa paginacion.jsp
    public static <T> ArrayList<T> paginar(HttpServletRequest request, ArrayList<T> lista) {
        int totalPaginas = Math.max(1, (lista.size() + FILAS_POR_PAGINA - 1) / FILAS_POR_PAGINA);
        int pagina = 1;
        try {
            pagina = Integer.parseInt(request.getParameter("pagina"));
        } catch (NumberFormatException e) {
            // sin pagina o con un valor raro se muestra la primera
        }
        pagina = Math.max(1, Math.min(pagina, totalPaginas));

        request.setAttribute("pagina", pagina);
        request.setAttribute("totalPaginas", totalPaginas);

        int desde = (pagina - 1) * FILAS_POR_PAGINA;
        int hasta = Math.min(desde + FILAS_POR_PAGINA, lista.size());
        return new ArrayList<>(lista.subList(desde, hasta));
    }
}
