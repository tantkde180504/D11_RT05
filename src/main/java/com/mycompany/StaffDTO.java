package com.mycompany;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class StaffDTO {

    private long id;
    private String firstName;
    private String lastName;
    private String email;
    private String role;
    private Date createdAt;

    // ✅ Trường hiển thị ngày định dạng sẵn
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", new Locale("vi", "VN"));
        return sdf.format(createdAt);
    }

    // --- Getters & Setters chuẩn ---
    public long getId() {
        return id;
    }

    // ✅ Sửa lại cho đúng kiểu long
    public void setId(long id) {
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
