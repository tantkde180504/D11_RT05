package com.mycompany;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class StaffDTO {

    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String role;
    private Date createdAt;

    // ✅ Trường hiển thị ngày định dạng sẵn (fix Locale deprecated)
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.forLanguageTag("vi-VN"));
        return sdf.format(createdAt);
    }

    // --- Getters & Setters chuẩn ---
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
