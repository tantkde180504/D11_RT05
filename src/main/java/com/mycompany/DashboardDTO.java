package com.mycompany;

public class DashboardDTO {
    private double revenueThisMonth;
    private long orderCountThisMonth;
    private long newCustomersThisMonth;
    private long totalProducts;
    private long lowStockProducts;

    public double getRevenueThisMonth() {
        return revenueThisMonth;
    }
    public void setRevenueThisMonth(double revenueThisMonth) {
        this.revenueThisMonth = revenueThisMonth;
    }
    public long getOrderCountThisMonth() {
        return orderCountThisMonth;
    }
    public void setOrderCountThisMonth(long orderCountThisMonth) {
        this.orderCountThisMonth = orderCountThisMonth;
    }
    public long getNewCustomersThisMonth() {
        return newCustomersThisMonth;
    }
    public void setNewCustomersThisMonth(long newCustomersThisMonth) {
        this.newCustomersThisMonth = newCustomersThisMonth;
    }
    public long getTotalProducts() {
        return totalProducts;
    }
    public void setTotalProducts(long totalProducts) {
        this.totalProducts = totalProducts;
    }
    public long getLowStockProducts() {
        return lowStockProducts;
    }
    public void setLowStockProducts(long lowStockProducts) {
        this.lowStockProducts = lowStockProducts;
    }
} 