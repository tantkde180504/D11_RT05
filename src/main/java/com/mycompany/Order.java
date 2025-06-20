package com.mycompany;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_number", nullable = false, unique = true)
    private String orderNumber;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "total_amount", nullable = false)
    private BigDecimal totalAmount;

    @Column(nullable = false)
    private String status;

    @Column(name = "shipping_address", nullable = false)
    private String shippingAddress;

    @Column(name = "shipping_phone")
    private String shippingPhone;

    @Column(name = "shipping_name")
    private String shippingName;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "order_date")
    private LocalDateTime orderDate;

    @Column(name = "shipped_date")
    private LocalDateTime shippedDate;

    @Column(name = "delivered_date")
    private LocalDateTime deliveredDate;

    @Column(name = "notes")
    private String notes;

    // Getter & Setter cho tất cả các trường

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getShippingPhone() { return shippingPhone; }
    public void setShippingPhone(String shippingPhone) { this.shippingPhone = shippingPhone; }

    public String getShippingName() { return shippingName; }
    public void setShippingName(String shippingName) { this.shippingName = shippingName; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public LocalDateTime getShippedDate() { return shippedDate; }
    public void setShippedDate(LocalDateTime shippedDate) { this.shippedDate = shippedDate; }

    public LocalDateTime getDeliveredDate() { return deliveredDate; }
    public void setDeliveredDate(LocalDateTime deliveredDate) { this.deliveredDate = deliveredDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
