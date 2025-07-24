package com.mycompany.controller;

import com.mycompany.dto.CustomerDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/test-validation")
@Validated
public class CustomerValidationTestController {
    @PostMapping("/customer")
    public ResponseEntity<?> testCustomerValidation(@Valid @RequestBody CustomerDTO dto) {
        return ResponseEntity.ok(dto);
    }
}
