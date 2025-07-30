// ...existing code...

package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

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
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    // Ban or unban customer by status
    @Override
    public boolean updateCustomerStatus(Long id, String status, String banReason) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null || !"CUSTOMER".equalsIgnoreCase(user.getRole())) return false;
        user.setStatus(status);
        user.setUpdatedAt(LocalDateTime.now());
        if ("banned".equalsIgnoreCase(status)) {
            user.setBanReason(banReason);
        } else {
            user.setBanReason(null);
        }
        userRepository.save(user);
        return true;
    }
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
        try {
            // Đã dùng @Valid ở controller, nhưng vẫn kiểm tra thủ công để báo lỗi rõ ràng nếu thiếu trường
            if (dto.getFirstName() == null || dto.getFirstName().trim().isEmpty())
                throw new RuntimeException("Họ không được để trống");
            if (dto.getLastName() == null || dto.getLastName().trim().isEmpty())
                throw new RuntimeException("Tên không được để trống");
            if (dto.getEmail() == null || dto.getEmail().trim().isEmpty())
                throw new RuntimeException("Email không được để trống");
            if (dto.getPhone() == null || dto.getPhone().trim().isEmpty())
                throw new RuntimeException("Số điện thoại không được để trống");
            if (dto.getPassword() == null || dto.getPassword().trim().isEmpty())
                throw new RuntimeException("Mật khẩu không được để trống");
            String password = dto.getPassword();
            if (password.length() < 8 || password.length() > 20)
                throw new RuntimeException("Mật khẩu phải từ 8 đến 20 ký tự");
            if (!password.matches(".*[A-Z].*"))
                throw new RuntimeException("Mật khẩu phải chứa ít nhất 1 chữ hoa (A-Z)");
            if (!password.matches(".*[a-z].*"))
                throw new RuntimeException("Mật khẩu phải chứa ít nhất 1 chữ thường (a-z)");
            if (!password.matches(".*[0-9].*"))
                throw new RuntimeException("Mật khẩu phải chứa ít nhất 1 chữ số (0-9)");
            // Nếu vẫn lỗi, dùng regex này:
            if (!password.matches(".*[!@#$%^&*()_\\-+=].*"))
                throw new RuntimeException("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (!@#$%^&*()_+-=)");
            if (dto.getAddress() == null || dto.getAddress().trim().isEmpty())
                throw new RuntimeException("Địa chỉ không được để trống");
            if (dto.getGender() == null || dto.getGender().trim().isEmpty())
                throw new RuntimeException("Giới tính không được để trống");
            if (dto.getDateOfBirth() == null || dto.getDateOfBirth().trim().isEmpty())
                throw new RuntimeException("Ngày sinh không được để trống");

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
            // Parse dateOfBirth: hỗ trợ cả "MM/dd/yyyy" và "yyyy-MM-dd"
            if (dto.getDateOfBirth() != null && !dto.getDateOfBirth().isEmpty()) {
                String dob = dto.getDateOfBirth();
                java.time.format.DateTimeFormatter fmt1 = java.time.format.DateTimeFormatter.ofPattern("MM/dd/yyyy");
                java.time.format.DateTimeFormatter fmt2 = java.time.format.DateTimeFormatter.ISO_LOCAL_DATE;
                try {
                    if (dob.contains("/")) {
                        user.setDateOfBirth(java.time.LocalDate.parse(dob, fmt1));
                    } else {
                        user.setDateOfBirth(java.time.LocalDate.parse(dob, fmt2));
                    }
                } catch (Exception ex) {
                    System.err.println("[ERROR] Lỗi parse ngày sinh: " + ex.getMessage());
                    throw new RuntimeException("Ngày sinh không hợp lệ. Định dạng hợp lệ: MM/dd/yyyy hoặc yyyy-MM-dd");
                }
            }
            // Chỉ cho phép gender là MALE hoặc FEMALE, mặc định MALE nếu không hợp lệ
            String validGender = "MALE";
            if (dto.getGender() != null) {
                String gender = dto.getGender().trim().toLowerCase();
                if (gender.equals("nữ") || gender.equals("nu") || gender.equals("female")) {
                    validGender = "FEMALE";
                } else if (gender.equals("nam") || gender.equals("male")) {
                    validGender = "MALE";
                }
            }
            user.setGender(validGender);
            user.setAddress(dto.getAddress());
            user.setRole("STAFF");
            user.setCreatedAt(java.time.LocalDateTime.now());
            user.setUpdatedAt(java.time.LocalDateTime.now());
            // Lưu mật khẩu dạng plain text (KHÔNG AN TOÀN, chỉ dùng cho demo)
            user.setPassword(dto.getPassword());
            return userRepository.save(user);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Lỗi tạo tài khoản nhân viên: " + ex.getMessage());
        }
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
            dto.setStatus(user.getStatus()); // Truyền trạng thái tài khoản

            if (user.getCreatedAt() != null) {
                dto.setCreatedAt(java.util.Date.from(user.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).toInstant()));
            }

            try {
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
