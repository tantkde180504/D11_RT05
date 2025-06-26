package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

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
    public List<CustomerDTO> getAllCustomers() {
        List<User> customers = userRepository.findByRole("CUSTOMER");
        List<CustomerDTO> dtos = new java.util.ArrayList<>();
        for (User user : customers) {
            CustomerDTO dto = new CustomerDTO();
            dto.setId(user.getId());
            dto.setFirstName(user.getFirstName());
            dto.setLastName(user.getLastName());
            dto.setEmail(user.getEmail());
            dto.setPhone(user.getPhone());
            // Bổ sung đầy đủ các trường cần thiết
            dto.setDateOfBirth(user.getDateOfBirth() != null ? user.getDateOfBirth().toString() : null);
            dto.setGender(user.getGender());
            dto.setAddress(user.getAddress());
            if (user.getCreatedAt() != null) {
                dto.setCreatedAt(java.util.Date.from(user.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).toInstant()));
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
        User user = userRepository.findById(id).orElse(null);
        if (user == null) return false;

        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setEmail(dto.getEmail());
        user.setUpdatedAt(LocalDateTime.now());

        userRepository.save(user);
        return true;
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
