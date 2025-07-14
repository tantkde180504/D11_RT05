package com.mycompany.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "users")
@DynamicUpdate
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    private String phone;

    private LocalDate dateOfBirth;

    private String gender;

    private String address;

    @Builder.Default
    @Column(nullable = false)
    private String role = "CUSTOMER"; // Đổi default từ STAFF thành CUSTOMER

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();
    
    // Enum cho Role (để hỗ trợ chat system)
    public enum Role {
        CUSTOMER, STAFF, ADMIN
    }
    
    // Enum cho Gender
    public enum Gender {
        MALE, FEMALE, OTHER
    }
    
    // Helper method để lấy tên đầy đủ
    public String getFullName() {
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        } else if (firstName != null) {
            return firstName;
        } else if (lastName != null) {
            return lastName;
        }
        return email; // Fallback to email
    }
    
    // Helper method để kiểm tra role
    public boolean isCustomer() {
        return "CUSTOMER".equals(role);
    }
    
    public boolean isStaff() {
        return "STAFF".equals(role);
    }
    
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;
}
