package com.oceanlink.util;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;

// Ayuda para escribir el PDF de un reporte del Supervisor con las columnas elegidas
public class ReportePdf {

    public static void escribir(OutputStream salida, String titulo, ArrayList<String> filtros, String[] columnas,
                         ArrayList<LinkedHashMap<String, String>> filas) throws IOException {

        Document documento = new Document(PageSize.A4.rotate(), 30, 30, 30, 30);
        try {
            PdfWriter.getInstance(documento, salida);
            documento.open();

            documento.add(new Paragraph("Reporte de " + titulo, new Font(Font.HELVETICA, 16, Font.BOLD)));
            documento.add(new Paragraph("Generado el " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date())
                    + "   |   Registros: " + filas.size(), new Font(Font.HELVETICA, 10)));
            documento.add(new Paragraph("Filtros: " + (filtros.isEmpty() ? "Ninguno" : String.join("   |   ", filtros)),
                    new Font(Font.HELVETICA, 10)));
            documento.add(new Paragraph(" "));

            Font fuenteCabecera = new Font(Font.HELVETICA, 9, Font.BOLD);
            Font fuenteNormal = new Font(Font.HELVETICA, 9);

            PdfPTable tabla = new PdfPTable(columnas.length);
            tabla.setWidthPercentage(100);
            tabla.setHeaderRows(1);

            for (String columna : columnas) {
                PdfPCell celda = new PdfPCell(new Phrase(columna, fuenteCabecera));
                celda.setGrayFill(0.9f);
                celda.setPadding(4);
                tabla.addCell(celda);
            }

            for (LinkedHashMap<String, String> fila : filas) {
                for (String columna : columnas) {
                    PdfPCell celda = new PdfPCell(new Phrase(valor(fila.get(columna)), fuenteNormal));
                    celda.setPadding(4);
                    tabla.addCell(celda);
                }
            }

            if (filas.isEmpty()) {
                PdfPCell vacia = new PdfPCell(new Phrase("No hay registros para este filtro.", fuenteNormal));
                vacia.setColspan(columnas.length);
                vacia.setPadding(4);
                tabla.addCell(vacia);
            }

            documento.add(tabla);
            documento.close();
        } catch (DocumentException e) {
            throw new IOException(e);
        }
    }

    private static String valor(String texto) {
        return texto == null || texto.isBlank() ? "-" : texto;
    }
}
