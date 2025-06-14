package service;

import entity.Staff;
import java.util.List;

public interface StaffService {
    
    // Lưu một nhân viên vào cơ sở dữ liệu
    void saveStaff(Staff staff);
    
    // Trả về danh sách tất cả nhân viên
    List<Staff> getAllStaff();
}
