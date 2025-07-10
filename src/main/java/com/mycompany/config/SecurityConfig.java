package com.mycompany.config;

import com.mycompany.service.OAuthUserService;
import com.mycompany.model.OAuthUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.core.Authentication;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private OAuthUserService oAuthUserService;
    
    // Initialize OAuth setup when Spring context loads
    @Autowired
    public void initOAuthSetup() {
        try {
            System.out.println("=== Initializing OAuth Setup ===");
            oAuthUserService.createOAuthUsersTableIfNotExists();
            oAuthUserService.migrateOAuthUsersToMainTable();
            System.out.println("=== OAuth Setup Complete ===");
        } catch (Exception e) {
            System.err.println("Error initializing OAuth setup: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/", "/login.jsp", "/index.jsp", "/profile.jsp", "/css/**", "/js/**", "/img/**", 
                               "/api/login", "/api/login-test", "/demo-login.html", "/test-login.html", 
                               "/test-login-simple.html", "/test-flow.html", "/oauth-redirect-test.html", 
                               "/google-oauth-test.jsp", "/oauth-login-test.jsp", "/oauth-success", "/oauth-success.html").permitAll()
                .anyRequest().permitAll()).oauth2Login(oauth2 -> oauth2
                .loginPage("/login.jsp")
                .defaultSuccessUrl("/", true)
                .successHandler(oAuth2AuthenticationSuccessHandler())
                .failureHandler(oAuth2AuthenticationFailureHandler())
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/")
                .permitAll()
            );
        
        return http.build();
    }    @Bean
    public AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                    Authentication authentication) throws IOException, ServletException {
                
                OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
                  // Lấy thông tin người dùng từ Google
                String email = oAuth2User.getAttribute("email");
                String name = oAuth2User.getAttribute("name");
                String picture = oAuth2User.getAttribute("picture");
                String sub = oAuth2User.getAttribute("sub"); // Google ID
                
                // Lưu hoặc cập nhật user trong database
                OAuthUser user = oAuthUserService.saveOrUpdateOAuthUser(email, name, picture, "google", sub);
                  // Lưu thông tin vào session
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", name);
                session.setAttribute("userPicture", picture);
                session.setAttribute("userId", user != null ? user.getId() : null);
                session.setAttribute("userRole", user != null ? user.getRole() : "CUSTOMER");
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("loginType", "google");                System.out.println("=== OAUTH SUCCESS HANDLER START ===");
                System.out.println("Google OAuth Login Success:");
                System.out.println("Email: " + email);
                System.out.println("Name: " + name);
                System.out.println("Picture: " + picture);
                System.out.println("Role: " + (user != null ? user.getRole() : "CUSTOMER"));
                  // FORCE REDIRECT - sử dụng controller để handle redirect
                String redirectUrl = request.getContextPath() + "/";
                System.out.println("=== FORCING REDIRECT TO CONTROLLER ===");
                System.out.println("Context path: " + request.getContextPath());
                System.out.println("Target URL: " + redirectUrl);
                System.out.println("Current session: " + session.getId());
                System.out.println("User stored in session: " + session.getAttribute("userName"));
                
                // Xóa bất kỳ header nào có thể conflict
                response.sendRedirect(redirectUrl);
                
                System.out.println("=== REDIRECT HEADERS SET TO CONTROLLER ===");
                System.out.println("Status: " + response.getStatus());
                System.out.println("Location: " + response.getHeader("Location"));
                System.out.println("=== OAUTH SUCCESS HANDLER END ===");
            }
        };
    }

    @Bean
    public AuthenticationFailureHandler oAuth2AuthenticationFailureHandler() {
        return new AuthenticationFailureHandler() {
            @Override
            public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                    org.springframework.security.core.AuthenticationException exception) throws IOException, ServletException {
                
                System.out.println("Google OAuth Login Failed: " + exception.getMessage());
                response.sendRedirect("/login.jsp?error=oauth_failed");
            }
        };
    }
}
