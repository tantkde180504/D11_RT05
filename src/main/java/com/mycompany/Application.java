package com.mycompany;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@SpringBootApplication
@EnableJpaRepositories(basePackages = "com.mycompany") // ✅ FIX quan trọng
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        System.out.println("DEBUG: Đang cấu hình SpringApplicationBuilder");
        return application.sources(Application.class);
    }

    @Bean
    public InternalResourceViewResolver setupViewResolver() {
        System.out.println("DEBUG: Đang cấu hình InternalResourceViewResolver");
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        return resolver;
    }

    public static void main(String[] args) {
        System.out.println("DEBUG: Đang khởi chạy ứng dụng Spring Boot");
        SpringApplication.run(Application.class, args);
    }
}
