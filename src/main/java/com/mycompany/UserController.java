package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
}
