package com.oceanlink.util;

public class Html {

    // para escribir texto de usuario dentro de un value="..." o de un textarea sin romper el HTML
    public static String esc(String texto) {
        if (texto == null) {
            return "";
        }
        return texto.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
