package com.oceanlink.services;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class CorreoService {

    private String variable(String nombre) {
        String valor = System.getenv(nombre);
        if (valor == null || valor.isBlank()) {
            throw new IllegalStateException("Falta configurar " + nombre);
        }
        return valor;
    }

    public void enviar(String destino, String asunto, String cuerpo)
            throws MessagingException {

        String usuario = variable("SMTP_USER");
        String clave = variable("SMTP_PASSWORD");

        Properties propiedades = new Properties();
        propiedades.setProperty("mail.smtp.host", variable("SMTP_HOST"));
        propiedades.setProperty("mail.smtp.port", variable("SMTP_PORT"));
        propiedades.setProperty("mail.smtp.auth", "true");
        propiedades.setProperty("mail.smtp.starttls.enable", "true");
        propiedades.setProperty("mail.smtp.starttls.required", "true");
        propiedades.setProperty("mail.smtp.ssl.checkserveridentity", "true");
        propiedades.setProperty("mail.smtp.connectiontimeout", "8000");
        propiedades.setProperty("mail.smtp.timeout", "12000");
        propiedades.setProperty("mail.smtp.writetimeout", "12000");

        Session sesionCorreo = Session.getInstance(propiedades, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuario, clave);
            }
        });

        InternetAddress destinatario = new InternetAddress(destino, true);
        destinatario.validate();

        MimeMessage mensaje = new MimeMessage(sesionCorreo);
        mensaje.setFrom(new InternetAddress(variable("SMTP_FROM"), true));
        mensaje.setRecipient(Message.RecipientType.TO, destinatario);
        mensaje.setSubject(asunto, "UTF-8");
        mensaje.setText(cuerpo, "UTF-8");

        Transport.send(mensaje);
    }
}
