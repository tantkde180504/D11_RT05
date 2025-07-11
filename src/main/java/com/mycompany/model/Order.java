package com.mycompany.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // --- Unified fields (gộp cả 2 version) ---
    @Column(name = "order_number", unique = true, nullable = false)
    private String orderNumber; // dùng chung cho orderNumber/orderCode

    @Column(name = "user_id", nullable = false)
    private Long userId; // dùng chung cho userId/customerId

    @Column(name = "total_amount", nullable = false)
    private BigDecimal totalAmount; // dùng chung cho totalAmount/total

    @Column(name = "status", nullable = false)
    private String status;

    @Column(name = "shipping_address")
    private String shippingAddress;

    @Column(name = "shipping_phone")
    private String shippingPhone;

    @Column(name = "shipping_name")
    private String shippingName;

    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "order_date", nullable = false)
    private LocalDateTime orderDate; // dùng chung cho orderDate/createdAt

    @Column(name = "shipped_date")
    private LocalDateTime shippedDate;

    @Column(name = "delivered_date")
    private LocalDateTime deliveredDate;

    @Column(name = "notes")
    private String notes;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<com.mycompany.model.OrderItem> orderItems;

    // --- Getters and setters ---
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
    public List<com.mycompany.model.OrderItem> getOrderItems() { return orderItems; }
    public void setOrderItems(List<com.mycompany.model.OrderItem> orderItems) { this.orderItems = orderItems; }
}
