package com.mycompany.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.dto.DashboardDTO;
import com.mycompany.service.DashboardService;

@RestController
public class DashboardRestController {
    @Autowired
    private DashboardService dashboardService;

    @GetMapping(value = "/api/dashboard", produces = "application/json")
    public DashboardDTO getDashboard() {
        return dashboardService.getDashboardStats();
    }
}