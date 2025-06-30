package com.mycompany;

public class OrderStats {
    private String status;
    private int totalOrders;

    public OrderStats(String status, int totalOrders) {
        this.status = status;
        this.totalOrders = totalOrders;
    }

    public String getStatus() {
        return status;
    }

    public int getTotalOrders() {
        return totalOrders;
    }
}
