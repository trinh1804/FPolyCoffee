package com.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Mailer {

    // Thông tin email gửi đi
    private static final String FROM_EMAIL = "phamthuytrinh1804@gmail.com";
    private static final String APP_PASSWORD = "swou oavx bgju iznc";

    public static int send(String to, String subject, String body) {
        return send(FROM_EMAIL, to, subject, body);
    }

    public static int send(String from, String to, String subject, String body) {
        try {
            // Cấu hình properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            // Tạo session với authenticator
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            });

            // Tạo message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");
            message.setContent(body, "text/html; charset=UTF-8");

            // Gửi mail
            Transport.send(message);

            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
}