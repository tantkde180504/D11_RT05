package com.mycompany.service;

import java.util.List;

import com.mycompany.dto.CustomerDTO;
import com.mycompany.dto.StaffDTO;
import com.mycompany.model.User;

public interface UserService {

    /**
     * Tạo tài khoản nhân viên mới
     */
    User createStaffAccount(User user);

    /**
     * Lấy danh sách tất cả nhân viên (có role là STAFF)
     */
    List<User> getAllStaffs();

    /**
     * Tìm kiếm nhân viên theo từ khóa và role
     */
    List<User> searchStaffs(String keyword, String role);

    /**
     * Tìm 1 nhân viên theo ID
     */
    User findById(Long id);

    /**
     * Cập nhật thông tin nhân viên
     */
    boolean updateStaff(Long id, StaffDTO dto);

    /**
     * Xoá nhân viên theo ID
     */
    boolean deleteStaff(Long id);

    /**
     * Lấy danh sách tất cả khách hàng (có role là CUSTOMER)
     */
    List<CustomerDTO> getAllCustomers();

    /**
     * Cập nhật thông tin khách hàng (role CUSTOMER)
     */
    boolean updateCustomer(Long id, CustomerDTO dto);
}
