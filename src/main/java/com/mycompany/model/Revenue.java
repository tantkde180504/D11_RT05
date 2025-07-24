package com.mycompany.model;

import java.math.BigDecimal;

public class Revenue {
    private String label; // Ngày, Tháng, Quý hoặc Năm
    private int totalOrders;
    private BigDecimal totalRevenue;

    public Revenue(String label, int totalOrders, BigDecimal totalRevenue) {
        this.label = label;
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
    }

    public String getLabel() {
        return label;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
}
