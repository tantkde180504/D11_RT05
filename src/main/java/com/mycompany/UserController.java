package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/staffs")
public class UserController {

    @Autowired
    private UserService userService;

    // ✅ 1. Tạo nhân viên mới
    @PostMapping("/create")
    public ResponseEntity<?> createStaff(@RequestBody User user) {
        try {
            System.out.println("[DEBUG] Dữ liệu nhận được khi tạo nhân viên:");
            System.out.println("  Họ: " + user.getFirstName());
            System.out.println("  Tên: " + user.getLastName());
            System.out.println("  Email: " + user.getEmail());
            System.out.println("  Ngày sinh (dateOfBirth): " + user.getDateOfBirth());
            System.out.println("  Số điện thoại: " + user.getPhone());
            System.out.println("  Giới tính: " + user.getGender());
            System.out.println("  Địa chỉ: " + user.getAddress());
            System.out.println("  Ngày tạo (createdAt): " + user.getCreatedAt());

            User created = userService.createStaffAccount(user);
            return ResponseEntity.ok(created);
        } catch (RuntimeException ex) {
            return ResponseEntity.badRequest().body(java.util.Collections.singletonMap("message", ex.getMessage()));
        } catch (Exception ex) {
            return ResponseEntity.status(500).body(java.util.Collections.singletonMap("message", "Lỗi hệ thống: " + ex.getMessage()));
        }
    }

    // ✅ 2. Lấy danh sách nhân viên
    @GetMapping("/list")
    public ResponseEntity<List<StaffDTO>> getAllStaffs() {
        List<User> staffs = userService.getAllStaffs();
        List<StaffDTO> dtos = staffs.stream().map(user -> mapToDTO(user)).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // ✅ 3. Lấy chi tiết 1 nhân viên theo ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getStaffById(@PathVariable("id") Long id) {
        User user = userService.findById(id);
        if (user == null) {
            System.out.println("❌ Không tìm thấy nhân viên ID: " + id);
            // Trả về JSON message thay vì chỉ 404
            return ResponseEntity.status(404).body(java.util.Collections.singletonMap("message", "Không tìm thấy nhân viên với ID: " + id));
        }

        StaffDTO dto = mapToDTO(user);
        return ResponseEntity.ok(dto);
    }

    // ✅ 4. Cập nhật nhân viên
    @PutMapping("/{id}")
    public ResponseEntity<?> updateStaff(@PathVariable("id") Long id, @RequestBody StaffDTO dto) {
        boolean updated = userService.updateStaff(id, dto);
        return updated ? ResponseEntity.ok().build() : ResponseEntity.status(500).build();
    }

    // ✅ 5. Xoá nhân viên
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteStaff(@PathVariable("id") Long id) {
        System.out.println("[DEBUG] DELETE /api/staffs/" + id + " được gọi");
        boolean deleted = userService.deleteStaff(id);
        if (deleted) {
            System.out.println("[DEBUG] Xoá thành công nhân viên id=" + id);
            return ResponseEntity.ok().build();
        } else {
            System.out.println("[DEBUG] Xoá thất bại nhân viên id=" + id);
            return ResponseEntity.status(500).build();
        }
    }

    // Thêm API lấy danh sách khách hàng (role = CUSTOMER)
    @GetMapping("/customers")
    public ResponseEntity<?> getAllCustomers() {
        try {
            List<CustomerDTO> customers = userService.getAllCustomers();
            return ResponseEntity.ok(customers);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(java.util.Collections.singletonMap("message", "Lỗi khi lấy danh sách khách hàng: " + ex.getMessage()));
        }
    }

    // Thêm API cập nhật thông tin khách hàng
    @PutMapping("/customers/{id}")
    public ResponseEntity<?> updateCustomer(@PathVariable("id") Long id, @RequestBody CustomerDTO dto) {
        try {
            boolean updated = userService.updateCustomer(id, dto);
            if (updated) return ResponseEntity.ok().build();
            return ResponseEntity.status(404).body(java.util.Collections.singletonMap("message", "Không tìm thấy khách hàng"));
        } catch (Exception ex) {
            return ResponseEntity.status(500).body(java.util.Collections.singletonMap("message", "Lỗi cập nhật: " + ex.getMessage()));
        }
    }

    // ✅ Hàm dùng chung để map User → DTO
    private StaffDTO mapToDTO(User user) {
        StaffDTO dto = new StaffDTO();
        dto.setId(user.getId());
        dto.setFirstName(user.getFirstName());
        dto.setLastName(user.getLastName());
        dto.setEmail(user.getEmail());
        dto.setRole(user.getRole());

        if (user.getCreatedAt() != null) {
            dto.setCreatedAt(Date.from(user.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant()));
        }

        return dto;
    }
}
