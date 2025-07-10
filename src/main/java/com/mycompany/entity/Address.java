package com.mycompany.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_addresses")
public class Address {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "user_email", nullable = false, length = 255)
    private String userEmail;
    
    @Column(name = "recipient_name", nullable = false, length = 255)
    private String recipientName;
    
    @Column(name = "phone", nullable = false, length = 20)
    private String phone;
    
    @Column(name = "house_number", nullable = false, length = 500)
    private String houseNumber;
    
    @Column(name = "ward", nullable = false, length = 255)
    private String ward;
    
    @Column(name = "district", nullable = false, length = 255)
    private String district;
    
    @Column(name = "province", nullable = false, length = 255)
    private String province;
    
    @Column(name = "is_default", nullable = true)
    private Boolean isDefault = false;
    
    @Column(name = "created_at", nullable = true)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = true)
    private LocalDateTime updatedAt;
    
    // Constructors
    public Address() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public Address(String userEmail, String recipientName, String phone, String houseNumber, String ward, String district, String province, Boolean isDefault) {
        this();
        this.userEmail = userEmail;
        this.recipientName = recipientName;
        this.phone = phone;
        this.houseNumber = houseNumber;
        this.ward = ward;
        this.district = district;
        this.province = province;
        this.isDefault = isDefault;
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public String getRecipientName() {
        return recipientName;
    }
    
    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getHouseNumber() {
        return houseNumber;
    }
    
    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }
    
    public String getWard() {
        return ward;
    }
    
    public void setWard(String ward) {
        this.ward = ward;
    }
    
    public String getDistrict() {
        return district;
    }
    
    public void setDistrict(String district) {
        this.district = district;
    }
    
    public String getProvince() {
        return province;
    }
    
    public void setProvince(String province) {
        this.province = province;
    }
    
    public Boolean getIsDefault() {
        return isDefault;
    }
    
    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // Utility method to get full address
    public String getFullAddress() {
        return houseNumber + ", " + ward + ", " + district + ", " + province;
    }
    
    @Override
    public String toString() {
        return "Address{" +
                "id=" + id +
                ", userEmail='" + userEmail + '\'' +
                ", recipientName='" + recipientName + '\'' +
                ", phone='" + phone + '\'' +
                ", houseNumber='" + houseNumber + '\'' +
                ", ward='" + ward + '\'' +
                ", district='" + district + '\'' +
                ", province='" + province + '\'' +
                ", isDefault=" + isDefault +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
