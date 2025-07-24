
package com.mycompany.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Pattern;

import lombok.Data;
import java.util.Date;

@Data
public class CustomerDTO {
    private Long id;
    @NotBlank(message = "Họ không được để trống")
    @Size(max = 50, message = "Họ tối đa 50 ký tự")
    @Pattern(regexp = "^[A-Za-zÀ-ỹ ]+$", message = "Họ chỉ được chứa chữ và khoảng trắng")
    private String firstName;

    @NotBlank(message = "Tên không được để trống")
    @Size(max = 50, message = "Tên tối đa 50 ký tự")
    @Pattern(regexp = "^[A-Za-zÀ-ỹ ]+$", message = "Tên chỉ được chứa chữ và khoảng trắng")
    private String lastName;
    private String email;
    @NotBlank(message = "Số điện thoại không được để trống")
@Pattern(regexp = "^0\\d{9}$", message = "Số điện thoại phải bắt đầu bằng 0 và đủ 10 số")
private String phone;
    private String dateOfBirth; // đổi sang String để nhận yyyy-MM-dd từ frontend
    private String gender;
    private String address;
    private Date createdAt;
    private int totalOrders; // Tổng số đơn hàng của khách hàng
    // Có thể bổ sung các trường khác nếu cần
    private String status; // Trạng thái tài khoản: active, banned, ...
    private String banReason; // Lý do bị ban
}
