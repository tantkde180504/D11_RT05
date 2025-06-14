package service;

import entity.Staff;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class FakeStaffService implements StaffService {

    private final List<Staff> staffList = new ArrayList<>();
    private Long nextId = 1L; // Tạo ID tự động giả lập

    @Override
    public void saveStaff(Staff staff) {
        staff.setId(nextId++); // Gán ID tăng dần
        staffList.add(staff);
        System.out.println("✔ Thêm thành công: " + staff.getFullName());
    }

    @Override
    public List<Staff> getAllStaff() {
        return staffList;
    }
}
