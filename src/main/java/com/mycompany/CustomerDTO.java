package com.mycompany;

import lombok.Data;
import java.util.Date;

@Data
public class CustomerDTO {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String dateOfBirth; // đổi sang String để nhận yyyy-MM-dd từ frontend
    private String gender;
    private String address;
    private Date createdAt;
    // Có thể bổ sung các trường khác nếu cần, ví dụ: tổng số đơn hàng
}
