package com.mycompany.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.context.event.ContextRefreshedEvent;

@Configuration
public class DatabaseMonitorConfig {
    
    @Bean
    public ApplicationListener<ContextRefreshedEvent> startupListener() {
        return event -> {
            System.out.println("🚀 APPLICATION STARTED - Database should be intact");
            System.out.println("⏰ Startup time: " + new java.util.Date());
        };
    }
    
    @Bean
    public ApplicationListener<ContextClosedEvent> shutdownListener() {
        return event -> {
            System.out.println("🛑 APPLICATION SHUTTING DOWN");
            System.out.println("⏰ Shutdown time: " + new java.util.Date());
        };
    }
}
