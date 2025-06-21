package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/staffs")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/create")
    public ResponseEntity<?> createStaff(@RequestBody User user) {
        User created = userService.createStaffAccount(user);
        return ResponseEntity.ok(created);
    }

    @GetMapping("/list")
    public ResponseEntity<List<StaffDTO>> getAllStaffs() {
        List<User> staffs = userService.getAllStaffs();
        List<StaffDTO> dtos = staffs.stream().map(user -> {
            StaffDTO dto = new StaffDTO();
            dto.setId(user.getId());  // Đảm bảo getId() trả về long
            dto.setFirstName(user.getFirstName());
            dto.setLastName(user.getLastName());
            dto.setEmail(user.getEmail());
            dto.setRole(user.getRole());

            // Chuyển LocalDateTime → Date nếu cần
            if (user.getCreatedAt() != null) {
                dto.setCreatedAt(Date.from(user.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant()));
            }

            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }
}
