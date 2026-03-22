package util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {
    // Cấu hình Gmail SMTP - thay bằng email thực của bạn
    private static final String SENDER_EMAIL = "your_email@gmail.com";
    private static final String SENDER_PASSWORD = "your_app_password"; // App password (không phải mật khẩu Gmail)

    /**
     * Gửi email đơn giản
     */
    public static boolean sendEmail(String toEmail, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Gửi mật khẩu mới cho user */
    public static boolean sendNewPassword(String toEmail, String fullName, String newPassword) {
        String subject = "PolyCoffee - Mật khẩu mới của bạn";
        String body = "<h3>Xin chào " + fullName + ",</h3>"
                + "<p>Mật khẩu mới của bạn là: <strong>" + newPassword + "</strong></p>"
                + "<p>Vui lòng đăng nhập và đổi mật khẩu ngay sau khi nhận được email này.</p>"
                + "<p>Trân trọng,<br/>PolyCoffee</p>";
        return sendEmail(toEmail, subject, body);
    }

    /** Gửi thông tin tài khoản khi quên */
    public static boolean sendAccountInfo(String toEmail, String fullName) {
        String subject = "PolyCoffee - Thông tin tài khoản";
        String body = "<h3>Xin chào " + fullName + ",</h3>"
                + "<p>Email đăng nhập của bạn là: <strong>" + toEmail + "</strong></p>"
                + "<p>Trân trọng,<br/>PolyCoffee</p>";
        return sendEmail(toEmail, subject, body);
    }
}
