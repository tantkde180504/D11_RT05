
package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mycompany.dto.CustomerDTO;
import com.mycompany.dto.StaffDTO;
import com.mycompany.model.User;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.UserRepository;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class UserServiceImpl implements UserService {
    // ...existing code...

    @Override
    public boolean toggleStaffActive(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) return false;
        User user = userOpt.get();
        if (!"STAFF".equalsIgnoreCase(user.getRole())) return false;
        user.setIsActive(user.getIsActive() == null ? false : !user.getIsActive());
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
        return true;
    }
    // ...existing code...
    @Override
    public User createStaffAccountFromDTO(StaffDTO dto) {
        // Đã dùng @Valid ở controller, không cần kiểm tra thủ công các trường required nữa

        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new RuntimeException("Email đã tồn tại.");
        }
        if (userRepository.existsByPhone(dto.getPhone())) {
            throw new RuntimeException("Số điện thoại đã tồn tại.");
        }
        if (userRepository.existsByFirstNameAndLastNameAndEmail(dto.getFirstName(), dto.getLastName(), dto.getEmail())) {
            throw new RuntimeException("Tên và email đã tồn tại cùng nhau.");
        }
        if (userRepository.existsByFirstNameAndLastNameAndPhone(dto.getFirstName(), dto.getLastName(), dto.getPhone())) {
            throw new RuntimeException("Tên và số điện thoại đã tồn tại cùng nhau.");
        }

        User user = new User();
        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().isEmpty()) {
            try {
                user.setDateOfBirth(java.time.LocalDate.parse(dto.getDateOfBirth()));
            } catch (Exception ignored) {}
        }
        String validGender = null;
        if (dto.getGender() != null) {
            String gender = dto.getGender().toUpperCase();
            if ("MALE".equals(gender) || "FEMALE".equals(gender) || "OTHER".equals(gender)) {
                validGender = gender;
            }
        }
        user.setGender(validGender);
        user.setAddress(dto.getAddress());
        user.setRole("STAFF");
        user.setCreatedAt(java.time.LocalDateTime.now());
        user.setUpdatedAt(java.time.LocalDateTime.now());
        // Không set password vì StaffDTO không có trường này
        return userRepository.save(user);
    }

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderRepository orderRepository;

    // ========== STAFF FUNCTIONS ==========

    @Override
    public User createStaffAccount(User user) {
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
            throw new RuntimeException("Email đã tồn tại.");
        }
        if (userRepository.existsByPhone(user.getPhone())) {
            throw new RuntimeException("Số điện thoại đã tồn tại.");
        }
        if (userRepository.existsByFirstNameAndLastNameAndEmail(user.getFirstName(), user.getLastName(), user.getEmail())) {
            throw new RuntimeException("Tên và email đã tồn tại cùng nhau.");
        }
        if (userRepository.existsByFirstNameAndLastNameAndPhone(user.getFirstName(), user.getLastName(), user.getPhone())) {
            throw new RuntimeException("Tên và số điện thoại đã tồn tại cùng nhau.");
        }

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
    public boolean updateStaff(Long id, StaffDTO dto) {
        try {
            User user = userRepository.findById(id).orElse(null);
            if (user == null) return false;

            if (!user.getEmail().equals(dto.getEmail()) && userRepository.existsByEmail(dto.getEmail())) {
                throw new RuntimeException("Email đã tồn tại.");
            }

            if (dto.getPhone() != null && !dto.getPhone().equals(user.getPhone()) && userRepository.existsByPhone(dto.getPhone())) {
                throw new RuntimeException("Số điện thoại đã tồn tại.");
            }

            LocalDate dateOfBirth = null;
            try {
                if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().isEmpty()) {
                    dateOfBirth = LocalDate.parse(dto.getDateOfBirth());
                }
            } catch (Exception ignored) {}

            String validGender = null;
            if (dto.getGender() != null) {
                String gender = dto.getGender().toUpperCase();
                if ("MALE".equals(gender) || "FEMALE".equals(gender) || "OTHER".equals(gender)) {
                    validGender = gender;
                }
            }

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
            return updatedRows > 0;
        } catch (RuntimeException ex) {
            throw ex;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteStaff(Long id) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) return false;

        try {
            userRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== CUSTOMER FUNCTIONS ==========

    @Override
    public List<CustomerDTO> getAllCustomers() {
        List<User> customers = userRepository.findByRole("CUSTOMER");
        List<CustomerDTO> dtos = new ArrayList<>();

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

            try {
                // Sử dụng đúng tên hàm đã đồng bộ: countByUserId
                int totalOrders = orderRepository.countByUserId(user.getId());
                dto.setTotalOrders(totalOrders);
            } catch (Exception e) {
                dto.setTotalOrders(0);
            }

            dtos.add(dto);
        }

        return dtos;
    }

    @Override
    public boolean updateCustomer(Long id, CustomerDTO dto) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null || !"CUSTOMER".equalsIgnoreCase(user.getRole())) return false;

        user.setFirstName(dto.getFirstName());
        user.setLastName(dto.getLastName());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());

        if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().isEmpty()) {
            user.setDateOfBirth(LocalDate.parse(dto.getDateOfBirth()));
        } else {
            user.setDateOfBirth(null);
        }

        user.setGender(dto.getGender());
        user.setAddress(dto.getAddress());
        user.setUpdatedAt(LocalDateTime.now());

        userRepository.save(user);
        return true;
    }

    // ========== JDBC USER LOOKUP FUNCTIONS ==========

    private final String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private final String username = "admin43@43gundam";
    private final String password = "Se18d06.";

    @Override
    public String getUserFullName(Long userId) {
        if (userId == null) return "Khách";

        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String sql = "SELECT first_name, last_name FROM users WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setLong(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String fullName = (rs.getString("first_name") + " " + rs.getString("last_name")).trim();
                        return fullName.isEmpty() ? "Người dùng #" + userId : fullName;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("JDBC Error: " + e.getMessage());
        }
        return "Người dùng #" + userId;
    }

    @Override
    public Map<Long, String> getUserFullNames(List<Long> userIds) {
        Map<Long, String> userNames = new HashMap<>();
        if (userIds == null || userIds.isEmpty()) return userNames;

        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String placeholders = String.join(",", Collections.nCopies(userIds.size(), "?"));
            String sql = "SELECT id, first_name, last_name FROM users WHERE id IN (" + placeholders + ")";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                for (int i = 0; i < userIds.size(); i++) {
                    stmt.setLong(i + 1, userIds.get(i));
                }
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Long id = rs.getLong("id");
                        String fullName = (rs.getString("first_name") + " " + rs.getString("last_name")).trim();
                        userNames.put(id, fullName.isEmpty() ? "Người dùng #" + id : fullName);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("JDBC Error (bulk): " + e.getMessage());
        }

        for (Long id : userIds) {
            userNames.putIfAbsent(id, "Người dùng #" + id);
        }

        return userNames;
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
}
