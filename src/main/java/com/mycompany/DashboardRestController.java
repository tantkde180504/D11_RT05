package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DashboardRestController {
    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/api/dashboard")
    public DashboardDTO getDashboard() {
        return dashboardService.getDashboardStats();
    }
} 