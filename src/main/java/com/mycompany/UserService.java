package com.mycompany;

import java.util.List;

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
}
