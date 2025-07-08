package com.mycompany.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Shipping {
    private Long orderId;
    private String orderNumber;
    private String customerName;
    private List<String> products;
    private BigDecimal totalAmount;
    private String status;
    private LocalDateTime orderDate;

    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public List<String> getProducts() { return products; }
    public void setProducts(List<String> products) { this.products = products; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }
}

