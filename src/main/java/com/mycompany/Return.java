package com.mycompany;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "returns")
public class Return {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "return_code", nullable = false, unique = true)
    private String returnCode;

    @Column(name = "order_id", nullable = false)
    private Long orderId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(name = "complaint_code")
    private String complaintCode;

    @Column(name = "reason", columnDefinition = "NVARCHAR(MAX)")
    private String reason;

    @Column(name = "request_type")
    private String requestType; // ví dụ: "Đổi sản phẩm" hoặc "Trả tiền"

    @Column(name = "status")
    private String status; // PROCESSING, COMPLETED, REJECTED

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "processed_by")
    private Long processedBy;

    // === GETTERS ===
    public Long getId() {
        return id;
    }

    public String getReturnCode() {
        return returnCode;
    }

    public Long getOrderId() {
        return orderId;
    }

    public Long getUserId() {
        return userId;
    }

    public Long getProductId() {
        return productId;
    }

    public String getComplaintCode() {
        return complaintCode;
    }

    public String getReason() {
        return reason;
    }

    public String getRequestType() {
        return requestType;
    }

    public String getStatus() {
        return status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public Long getProcessedBy() {
        return processedBy;
    }

    // === SETTERS ===
    public void setId(Long id) {
        this.id = id;
    }

    public void setReturnCode(String returnCode) {
        this.returnCode = returnCode;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public void setComplaintCode(String complaintCode) {
        this.complaintCode = complaintCode;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setProcessedBy(Long processedBy) {
        this.processedBy = processedBy;
    }
}
