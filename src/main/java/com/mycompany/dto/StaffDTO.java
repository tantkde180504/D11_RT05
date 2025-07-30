package com.mycompany.dto;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Pattern;

public class StaffDTO {
    private Long id;
    @NotBlank(message = "Họ không được để trống")
    @Size(max = 50, message = "Họ tối đa 50 ký tự")
    @Pattern(regexp = "^[A-Za-zÀ-ỹ ]+$", message = "Họ chỉ được chứa chữ và khoảng trắng")
    private String firstName;

    @NotBlank(message = "Tên không được để trống")
    @Size(max = 50, message = "Tên tối đa 50 ký tự")
    @Pattern(regexp = "^[A-Za-zÀ-ỹ ]+$", message = "Tên chỉ được chứa chữ và khoảng trắng")
    private String lastName;
    @NotBlank(message = "Email không được để trống")
    @jakarta.validation.constraints.Email(message = "Email không đúng định dạng")
    private String email;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Pattern(regexp = "^[0-9]{10}$", message = "Số điện thoại phải đúng 10 chữ số")
    private String phone;
    // Chỉ bắt buộc khi tạo mới, không bắt buộc khi cập nhật
    @Size(min = 6, max = 100, message = "Mật khẩu phải từ 6-100 ký tự")
    private String password;
    private String dateOfBirth; // Thay đổi từ LocalDate sang String để tránh lỗi JSON serialize
    private String gender;
    private String address;
    private String role;
    private Date createdAt;
    private Boolean isActive;

    // ✅ Trường hiển thị ngày định dạng sẵn (fix Locale deprecated)
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.forLanguageTag("vi-VN"));
        return sdf.format(createdAt);
    }

    // --- Getters & Setters chuẩn ---
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
}
