package com.mycompany;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "complaints")
public class Complaint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(nullable = false)
    private String status; // PENDING, PROCESSING, RESOLVED, REJECTED

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String response;

    @Column(length = 100)
    private String resolution;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Người gửi khiếu nại
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Đơn hàng liên quan (nếu có)
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;

    // Getters and Setters
    public Long getId() { return id; }

    public void setId(Long id) { this.id = id; }

    public String getContent() { return content; }

    public void setContent(String content) { this.content = content; }

    public String getStatus() { return status; }

    public void setStatus(String status) { this.status = status; }

    public String getResponse() { return response; }

    public void setResponse(String response) { this.response = response; }

    public String getResolution() { return resolution; }

    public void setResolution(String resolution) { this.resolution = resolution; }

    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public User getUser() { return user; }

    public void setUser(User user) { this.user = user; }

    public Order getOrder() { return order; }

    public void setOrder(Order order) { this.order = order; }
}
