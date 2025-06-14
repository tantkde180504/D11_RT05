package controller;

import entity.Staff;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import service.StaffService;

import java.util.List;

@Controller
@RequestMapping("/admin/staffs")
public class StaffController {

    @Autowired
    private StaffService staffService;

    // 👉 Hiển thị form thêm nhân viên
    @GetMapping("/create")
    public String showForm(Model model) {
        model.addAttribute("staff", new Staff());
        return "addStaff"; 
    }

    // 👉 Lưu nhân viên và chuyển về trang danh sách
    @PostMapping("/create")
    public String createStaff(@ModelAttribute("staff") Staff staff) {
        staffService.saveStaff(staff);
        return "redirect:/admin/staffs"; // chuyển về danh sách
    }

    // 👉 Hiển thị danh sách tất cả nhân viên
    @GetMapping("")
    public String listStaff(Model model) {
        List<Staff> staffList = staffService.getAllStaff();
        model.addAttribute("staffList", staffList);
        return "listStaff"; // tạo file listStaff.jsp tương ứng
    }
}
