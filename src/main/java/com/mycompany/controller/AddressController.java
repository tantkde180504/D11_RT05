package com.mycompany.controller;

import com.mycompany.entity.Address;
import com.mycompany.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/addresses")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class AddressController {
    
    @Autowired
    private AddressService addressService;
    
    /**
     * Test endpoint để kiểm tra API
     */
    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> testEndpoint(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            
            response.put("success", true);
            response.put("message", "Address API is working");
            response.put("userEmail", userEmail);
            response.put("sessionId", session.getId());
            response.put("timestamp", new java.util.Date());
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500)
                .header("Content-Type", "application/json")
                .body(response);
        }
    }
    
    /**
     * Simple POST test endpoint
     */
    @PostMapping("/test")
    public ResponseEntity<Map<String, Object>> testPostEndpoint(@RequestBody Map<String, Object> testData, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("=== TEST POST REQUEST ===");
            System.out.println("Received data: " + testData);
            
            String userEmail = getUserEmailFromSession(session);
            System.out.println("User email: " + userEmail);
            
            response.put("success", true);
            response.put("message", "POST test successful");
            response.put("receivedData", testData);
            response.put("userEmail", userEmail);
            response.put("timestamp", new java.util.Date());
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
            
        } catch (Exception e) {
            System.err.println("Error in test POST: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500)
                .header("Content-Type", "application/json")
                .body(response);
        }
    }
    
    /**
     * Simple test endpoint without session dependency
     */
    @GetMapping("/simple-test")
    public ResponseEntity<Map<String, Object>> simpleTest() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            response.put("success", true);
            response.put("message", "Simple test working");
            response.put("timestamp", new java.util.Date());
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500)
                .header("Content-Type", "application/json")
                .body(response);
        }
    }
    
    /**
     * Lấy tất cả địa chỉ của user hiện tại
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllAddresses(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("=== GET ALL ADDRESSES REQUEST ===");
            
            // Lấy user email từ session
            String userEmail = getUserEmailFromSession(session);
            System.out.println("User email from session: " + userEmail);
            
            if (userEmail == null) {
                System.out.println("No user email found in session");
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập để xem địa chỉ");
                return ResponseEntity.status(401)
                    .header("Content-Type", "application/json")
                    .body(response);
            }
            
            System.out.println("Loading addresses for user: " + userEmail);
            List<Address> addresses = addressService.getAllAddressesByUserEmail(userEmail);
            long count = addressService.countAddressesByUserEmail(userEmail);
            
            System.out.println("Found " + addresses.size() + " addresses");
            System.out.println("Address count: " + count);
            
            for (int i = 0; i < addresses.size(); i++) {
                Address addr = addresses.get(i);
                System.out.println("Address " + (i+1) + ": ID=" + addr.getId() + 
                    ", Name=" + addr.getRecipientName() + 
                    ", Default=" + addr.getIsDefault());
            }
            
            response.put("success", true);
            response.put("addresses", addresses);
            response.put("count", count);
            
            System.out.println("Returning response: " + response);
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
            
        } catch (Exception e) {
            System.err.println("=== ERROR GETTING ADDRESSES ===");
            System.err.println("Error type: " + e.getClass().getSimpleName());
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống khi lấy danh sách địa chỉ");
            return ResponseEntity.status(500)
                .header("Content-Type", "application/json")
                .body(response);
        }
    }
    
    /**
     * Lấy địa chỉ theo ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getAddressById(@PathVariable Integer id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }
            
            return addressService.getAddressById(id, userEmail)
                    .map(address -> {
                        response.put("success", true);
                        response.put("address", address);
                        return ResponseEntity.ok(response);
                    })
                    .orElseGet(() -> {
                        response.put("success", false);
                        response.put("message", "Không tìm thấy địa chỉ");
                        return ResponseEntity.status(404).body(response);
                    });
                    
        } catch (Exception e) {
            System.err.println("Error getting address: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * Tạo địa chỉ mới
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> createAddress(@RequestBody Address address, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("=== CREATE ADDRESS REQUEST ===");
            System.out.println("Received address data: " + address);
            
            String userEmail = getUserEmailFromSession(session);
            System.out.println("User email from session: " + userEmail);
            
            if (userEmail == null) {
                System.out.println("No user email found in session");
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401)
                    .header("Content-Type", "application/json")
                    .body(response);
            }
            
            // Set user email
            address.setUserEmail(userEmail);
            System.out.println("Address after setting user email: " + address);
            
            // Validate
            boolean isValid = addressService.validateAddress(address);
            System.out.println("Address validation result: " + isValid);
            
            if (!isValid) {
                System.out.println("Address validation failed");
                response.put("success", false);
                response.put("message", "Thông tin địa chỉ không hợp lệ");
                return ResponseEntity.status(400)
                    .header("Content-Type", "application/json")
                    .body(response);
            }
            
            System.out.println("Creating address...");
            Address savedAddress = addressService.createAddress(address);
            System.out.println("Address created successfully: " + savedAddress);
            
            response.put("success", true);
            response.put("message", "Đã thêm địa chỉ thành công");
            response.put("address", savedAddress);
            
            return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
            
        } catch (Exception e) {
            System.err.println("=== ERROR CREATING ADDRESS ===");
            System.err.println("Error type: " + e.getClass().getSimpleName());
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Stack trace:");
            e.printStackTrace();
            
            response.put("success", false);
            
            // Provide more specific error messages
            if (e.getMessage() != null) {
                if (e.getMessage().contains("duplicate") || e.getMessage().contains("UNIQUE")) {
                    response.put("message", "Địa chỉ này đã tồn tại");
                } else if (e.getMessage().contains("foreign key") || e.getMessage().contains("FOREIGN KEY")) {
                    response.put("message", "Lỗi liên kết dữ liệu người dùng");
                } else if (e.getMessage().contains("null") || e.getMessage().contains("NOT NULL")) {
                    response.put("message", "Thiếu thông tin bắt buộc");
                } else {
                    response.put("message", "Lỗi hệ thống: " + e.getMessage());
                }
            } else {
                response.put("message", "Lỗi hệ thống khi thêm địa chỉ");
            }
            
            return ResponseEntity.status(500)
                .header("Content-Type", "application/json")
                .body(response);
        }
    }
    
    /**
     * Cập nhật địa chỉ
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateAddress(@PathVariable Integer id, @RequestBody Address addressDetails, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }
            
            // Validate
            if (!addressService.validateAddress(addressDetails)) {
                response.put("success", false);
                response.put("message", "Thông tin địa chỉ không hợp lệ");
                return ResponseEntity.status(400).body(response);
            }
            
            return addressService.updateAddress(id, userEmail, addressDetails)
                    .map(address -> {
                        response.put("success", true);
                        response.put("message", "Đã cập nhật địa chỉ thành công");
                        response.put("address", address);
                        return ResponseEntity.ok(response);
                    })
                    .orElseGet(() -> {
                        response.put("success", false);
                        response.put("message", "Không tìm thấy địa chỉ");
                        return ResponseEntity.status(404).body(response);
                    });
                    
        } catch (Exception e) {
            System.err.println("Error updating address: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống khi cập nhật địa chỉ");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * Xóa địa chỉ
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteAddress(@PathVariable Integer id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }
            
            boolean deleted = addressService.deleteAddress(id, userEmail);
            
            if (deleted) {
                response.put("success", true);
                response.put("message", "Đã xóa địa chỉ thành công");
            } else {
                response.put("success", false);
                response.put("message", "Không tìm thấy địa chỉ");
            }
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("Error deleting address: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống khi xóa địa chỉ");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * Đặt địa chỉ làm mặc định
     */
    @PutMapping("/{id}/default")
    public ResponseEntity<Map<String, Object>> setDefaultAddress(@PathVariable Integer id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }
            
            return addressService.setDefaultAddress(id, userEmail)
                    .map(address -> {
                        response.put("success", true);
                        response.put("message", "Đã đặt làm địa chỉ mặc định");
                        response.put("address", address);
                        return ResponseEntity.ok(response);
                    })
                    .orElseGet(() -> {
                        response.put("success", false);
                        response.put("message", "Không tìm thấy địa chỉ");
                        return ResponseEntity.status(404).body(response);
                    });
                    
        } catch (Exception e) {
            System.err.println("Error setting default address: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * Lấy số lượng địa chỉ của user
     */
    @GetMapping("/count")
    public ResponseEntity<Map<String, Object>> getAddressCount(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = getUserEmailFromSession(session);
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }
            
            long count = addressService.countAddressesByUserEmail(userEmail);
            
            response.put("success", true);
            response.put("count", count);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.err.println("Error getting address count: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("message", "Lỗi hệ thống");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * Lấy user email từ session
     */
    private String getUserEmailFromSession(HttpSession session) {
        try {
            System.out.println("=== CHECKING SESSION ATTRIBUTES ===");
            
            // List all session attributes for debugging
            java.util.Enumeration<String> attributeNames = session.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String attributeName = attributeNames.nextElement();
                Object attributeValue = session.getAttribute(attributeName);
                System.out.println("Session attribute: " + attributeName + " = " + attributeValue);
            }
            
            // Try different attribute names for backward compatibility
            Object userEmailObj = session.getAttribute("userEmail");
            if (userEmailObj != null) {
                System.out.println("Found userEmail in session: " + userEmailObj);
                return (String) userEmailObj;
            }
            
            userEmailObj = session.getAttribute("email");
            if (userEmailObj != null) {
                System.out.println("Found email in session: " + userEmailObj);
                return (String) userEmailObj;
            }
            
            System.out.println("No email found in session");
            return null;
        } catch (Exception e) {
            System.err.println("Error getting user email from session: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
