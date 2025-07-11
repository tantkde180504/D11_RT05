package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycompany.model.User;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.UserRepository;
import com.mycompany.dto.CustomerDTO;
import com.mycompany.dto.StaffDTO;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Override
    public User createStaffAccount(User user) {
        // Validate all required fields
        if (user == null ||
            user.getEmail() == null || user.getEmail().trim().isEmpty() ||
            user.getPassword() == null || user.getPassword().trim().isEmpty() ||
            user.getFirstName() == null || user.getFirstName().trim().isEmpty() ||
            user.getLastName() == null || user.getLastName().trim().isEmpty() ||
            user.getPhone() == null || user.getPhone().trim().isEmpty() ||
            user.getDateOfBirth() == null ||
            user.getGender() == null || user.getGender().trim().isEmpty() ||
            user.getAddress() == null || user.getAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ tất cả các trường bắt buộc.");
        }

        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email đã tồn tại. Vui lòng dùng email khác.");
        }
        if (userRepository.existsByPhone(user.getPhone())) {
            throw new RuntimeException("Số điện thoại đã tồn tại. Vui lòng dùng số khác.");
        }
        // Nếu vừa trùng tên vừa trùng email hoặc vừa trùng tên vừa trùng số điện thoại
        if (userRepository.existsByFirstNameAndLastNameAndEmail(user.getFirstName(), user.getLastName(), user.getEmail())) {
            throw new RuntimeException("Tên và email đã tồn tại cùng nhau. Vui lòng đổi email hoặc tên.");
        }
        if (userRepository.existsByFirstNameAndLastNameAndPhone(user.getFirstName(), user.getLastName(), user.getPhone())) {
            throw new RuntimeException("Tên và số điện thoại đã tồn tại cùng nhau. Vui lòng đổi số hoặc tên.");
        }

        // Đã bỏ mã hóa mật khẩu, không cần PasswordEncoder nữa
        // user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole("STAFF");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    @Override
    public List<User> getAllStaffs() {
        return userRepository.findByRole("STAFF");
    }

    @Override
    public List<User> searchStaffs(String keyword, String role) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return userRepository.findByRoleAndFirstNameContainingIgnoreCaseOrRoleAndLastNameContainingIgnoreCaseOrRoleAndEmailContainingIgnoreCase(
                "STAFF", keyword, "STAFF", keyword, "STAFF", keyword);
        }
        return userRepository.findByRole("STAFF");
    }

    @Override
    public List<CustomerDTO> getAllCustomers() {
        System.out.println("DEBUG: Bắt đầu lấy danh sách khách hàng");
        List<User> customers = userRepository.findByRole("CUSTOMER");
        if (customers == null || customers.isEmpty()) {
            System.out.println("❌ Không tìm thấy khách hàng nào trong cơ sở dữ liệu.");
            return new java.util.ArrayList<>();
        }
        System.out.println("DEBUG: Tổng số khách hàng tìm thấy: " + customers.size());
        for (User user : customers) {
            System.out.println("DEBUG: Khách hàng ID: " + user.getId() + ", Email: " + user.getEmail());
        }

        List<CustomerDTO> dtos = new java.util.ArrayList<>();
        for (User user : customers) {
            CustomerDTO dto = new CustomerDTO();
            dto.setId(user.getId());
            dto.setFirstName(user.getFirstName());
            dto.setLastName(user.getLastName());
            dto.setEmail(user.getEmail());
            dto.setPhone(user.getPhone());
            dto.setDateOfBirth(user.getDateOfBirth() != null ? user.getDateOfBirth().toString() : null);
            dto.setGender(user.getGender());
            dto.setAddress(user.getAddress());
            if (user.getCreatedAt() != null) {
                dto.setCreatedAt(java.util.Date.from(user.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).toInstant()));
            }
            // Thêm tổng số đơn hàng
            try {
                int totalOrders = orderRepository.countByCustomerId(user.getId());
                System.out.println("DEBUG: Tổng số đơn hàng cho khách hàng ID " + user.getId() + " = " + totalOrders);
                dto.setTotalOrders(totalOrders);
            } catch (Exception e) {
                System.out.println("❌ Lỗi khi tính tổng số đơn hàng cho khách hàng ID: " + user.getId() + " - " + e.getMessage());
                dto.setTotalOrders(0);
            }
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @Override
    public boolean updateStaff(Long id, StaffDTO dto) {
        try {
            System.out.println("[DEBUG] UserService.updateStaff - Tìm nhân viên ID: " + id);
            User user = userRepository.findById(id).orElse(null);
            if (user == null) {
                System.out.println("[DEBUG] Không tìm thấy nhân viên ID: " + id);
                return false;
            }

            // Kiểm tra email trùng lặp (trừ chính user đang update)
            if (!user.getEmail().equals(dto.getEmail()) && userRepository.existsByEmail(dto.getEmail())) {
                throw new RuntimeException("Email đã tồn tại. Vui lòng sử dụng email khác.");
            }

            // Kiểm tra phone trùng lặp (trừ chính user đang update)
            if (dto.getPhone() != null && !dto.getPhone().equals(user.getPhone()) && userRepository.existsByPhone(dto.getPhone())) {
                throw new RuntimeException("Số điện thoại đã tồn tại. Vui lòng sử dụng số khác.");
            }

            System.out.println("[DEBUG] Tìm thấy nhân viên, đang cập nhật thông tin...");
            System.out.println("[DEBUG] Current user data: email=" + user.getEmail() + ", password=" + user.getPassword() + ", role=" + user.getRole());

            System.out.println("[DEBUG] Đang lưu vào database bằng custom update...");
            
            // Parse dateOfBirth an toàn
            LocalDate dateOfBirth = null;
            if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().trim().isEmpty()) {
                try {
                    dateOfBirth = LocalDate.parse(dto.getDateOfBirth());
                    System.out.println("[DEBUG] Parsed dateOfBirth: " + dateOfBirth);
                } catch (Exception e) {
                    System.out.println("[ERROR] Lỗi parse dateOfBirth: " + dto.getDateOfBirth() + " - " + e.getMessage());
                    // dateOfBirth sẽ là null
                }
            }
            
            // Validate gender
            String validGender = null;
            if (dto.getGender() != null && !dto.getGender().trim().isEmpty()) {
                String gender = dto.getGender().toUpperCase();
                if ("MALE".equals(gender) || "FEMALE".equals(gender) || "OTHER".equals(gender)) {
                    validGender = gender;
                    System.out.println("[DEBUG] Valid gender: " + validGender);
                } else {
                    System.out.println("[DEBUG] Invalid gender value: " + dto.getGender() + ", using null");
                    validGender = null;
                }
            }
            
            // Sử dụng custom update method để tránh update password/role
            int updatedRows = userRepository.updateStaffInfo(
                id,
                dto.getFirstName(),
                dto.getLastName(),
                dto.getEmail(),
                dto.getPhone(),
                dateOfBirth,
                validGender,
                dto.getAddress(),
                LocalDateTime.now()
            );
            
            System.out.println("[DEBUG] Số dòng đã cập nhật: " + updatedRows);
            return updatedRows > 0;
        } catch (RuntimeException ex) {
            System.out.println("[ERROR] Lỗi validation trong UserService.updateStaff: " + ex.getMessage());
            throw ex; // Re-throw để UserController bắt được
        } catch (Exception ex) {
            System.out.println("[ERROR] Lỗi trong UserService.updateStaff: " + ex.getMessage());
            ex.printStackTrace();
            return false; // Đổi từ throw exception thành return false
        }
    }

    @Override
    public boolean deleteStaff(Long id) {
        System.out.println("\uD83D\uDDD1 Gọi xóa nhân viên ID = " + id);

        // Kiểm tra tồn tại và đúng role STAFF
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            System.out.println("\u26A0\uFE0F Nhân viên không tồn tại trong DB!");
            return false;
        }
        if (!"STAFF".equalsIgnoreCase(user.getRole())) {
            System.out.println("\u26A0\uFE0F Không phải nhân viên STAFF, không được phép xoá!");
            return false;
        }

        try {
            userRepository.deleteById(id);
            System.out.println("\u2705 Đã xoá nhân viên ID = " + id);
            return true;
        } catch (Exception e) {
            System.out.println("\u274C Lỗi khi xoá nhân viên: " + e.getMessage());
            e.printStackTrace(); // Thêm log chi tiết lỗi
            return false;
        }
    }

    @Override
    public boolean updateCustomer(Long id, CustomerDTO dto) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null || !"CUSTOMER".equalsIgnoreCase(user.getRole())) return false;

        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        // Chuyển String yyyy-MM-dd sang LocalDate
        if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().isEmpty()) {
            user.setDateOfBirth(java.time.LocalDate.parse(dto.getDateOfBirth()));
        } else {
            user.setDateOfBirth(null);
        }
        user.setGender(dto.getGender());
        user.setAddress(dto.getAddress());
        user.setUpdatedAt(java.time.LocalDateTime.now());

        userRepository.save(user);
        return true;
    }
}
