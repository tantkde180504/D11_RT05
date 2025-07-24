// ...existing code...
package com.mycompany.service;

import java.util.List;
import java.util.Map;
import com.mycompany.dto.CustomerDTO;
import com.mycompany.dto.StaffDTO;
import com.mycompany.model.User;

public interface UserService {

    // === Staff Management ===
    User createStaffAccount(User user);
    User createStaffAccountFromDTO(StaffDTO dto);
    List<User> getAllStaffs();
    List<User> searchStaffs(String keyword, String role);
    User findById(Long id);
    boolean updateStaff(Long id, StaffDTO dto);
    boolean deleteStaff(Long id);
    boolean toggleStaffActive(Long id);

    // === Customer Management ===
    List<CustomerDTO> getAllCustomers();
    boolean updateCustomer(Long id, CustomerDTO dto);
    boolean updateCustomerStatus(Long id, String status, String banReason);

    // === User Lookup via JDBC ===
    String getUserFullName(Long userId);
    Map<Long, String> getUserFullNames(List<Long> userIds);
}
