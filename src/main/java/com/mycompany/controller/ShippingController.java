package com.mycompany.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.model.Shipping;
import com.mycompany.repository.ShippingRepository;

@RestController
@RequestMapping("/api/shipping")
public class ShippingController {
    @Autowired
    private ShippingRepository repo;

    @GetMapping
    public List<Shipping> getShipping(@RequestParam(defaultValue = "ALL") String status) {
        return repo.findAll(status);
    }

    @PostMapping("/confirm")
    public ResponseEntity<?> confirm(@RequestParam Long orderId) {
        repo.updateStatus(orderId, "CONFIRMED");
        return ResponseEntity.ok().build();
    }

    @PostMapping("/cancel")
    public ResponseEntity<?> cancel(@RequestParam Long orderId) {
        repo.updateStatus(orderId, "CANCELLED");
        return ResponseEntity.ok().build();
    }
}

