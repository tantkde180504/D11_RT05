package com.mycompany.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import java.util.Random;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    public String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 6-digit OTP
        return String.valueOf(otp);
    }
    
    public boolean sendOTPEmail(String toEmail, String otp, String firstName, String lastName) {
        try {
            var message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom("43gundamhobby@gmail.com", "43 Gundam Hobby");
            helper.setTo(toEmail);
            helper.setSubject("🤖 Xác thực tài khoản 43 Gundam Hobby");
            
            String htmlContent = createOTPEmailTemplate(otp, firstName, lastName);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
            System.out.println("OTP email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error sending OTP email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private String createOTPEmailTemplate(String otp, String firstName, String lastName) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
                "<meta charset=\"UTF-8\">" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">" +
                "<title>Xác thực tài khoản</title>" +
                "<style>" +
                    "body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 0; background-color: #f5f5f5; }" +
                    ".container { max-width: 600px; margin: 0 auto; background-color: white; }" +
                    ".header { background: linear-gradient(135deg, #FF6600, #FF8533); padding: 30px; text-align: center; }" +
                    ".header h1 { color: white; margin: 0; font-size: 28px; }" +
                    ".content { padding: 40px 30px; }" +
                    ".otp-box { background: #f8f9fa; border: 2px dashed #FF6600; padding: 20px; text-align: center; margin: 20px 0; border-radius: 10px; }" +
                    ".otp-code { font-size: 36px; font-weight: bold; color: #FF6600; letter-spacing: 5px; margin: 10px 0; }" +
                    ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 14px; }" +
                    ".warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }" +
                "</style>" +
            "</head>" +
            "<body>" +
                "<div class=\"container\">" +
                    "<div class=\"header\">" +
                        "<h1>🤖 43 Gundam Hobby</h1>" +
                        "<p style=\"color: white; margin: 5px 0;\">Xác thực tài khoản của bạn</p>" +
                    "</div>" +
                    
                    "<div class=\"content\">" +
                        "<h2>Chào " + firstName + " " + lastName + "!</h2>" +
                        "<p>Cảm ơn bạn đã đăng ký tài khoản tại <strong>43 Gundam Hobby</strong>. Để hoàn tất quá trình đăng ký, vui lòng sử dụng mã OTP bên dưới:</p>" +
                        
                        "<div class=\"otp-box\">" +
                            "<p style=\"margin: 0; font-size: 18px; color: #333;\">Mã xác thực của bạn:</p>" +
                            "<div class=\"otp-code\">" + otp + "</div>" +
                            "<p style=\"margin: 0; font-size: 14px; color: #666;\">Mã có hiệu lực trong 10 phút</p>" +
                        "</div>" +
                        
                        "<div class=\"warning\">" +
                            "<strong>⚠️ Lưu ý quan trọng:</strong>" +
                            "<ul style=\"margin: 10px 0; padding-left: 20px;\">" +
                                "<li>Mã OTP chỉ có hiệu lực trong 10 phút</li>" +
                                "<li>Không chia sẻ mã này với bất kỳ ai</li>" +
                                "<li>Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này</li>" +
                            "</ul>" +
                        "</div>" +
                        
                        "<p>Sau khi xác thực thành công, bạn sẽ có thể đăng nhập và khám phá thế giới mô hình Gundam tuyệt vời!</p>" +
                        
                        "<p style=\"color: #666; font-size: 14px; margin-top: 30px;\">" +
                            "Trân trọng,<br>" +
                            "<strong>Đội ngũ 43 Gundam Hobby</strong>" +
                        "</p>" +
                    "</div>" +
                    
                    "<div class=\"footer\">" +
                        "<p>© 2025 43 Gundam Hobby - Mô hình Gundam chính hãng</p>" +
                        "<p>📍 59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng | 📞 0385 546 145</p>" +
                    "</div>" +
                "</div>" +
            "</body>" +
            "</html>";
    }
}
