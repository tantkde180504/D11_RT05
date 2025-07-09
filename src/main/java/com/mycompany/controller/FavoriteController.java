package com.mycompany.controller;

import com.mycompany.service.FavoriteService;
import com.mycompany.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {
    
    @Autowired
    private FavoriteService favoriteService;
    
    // GET /api/favorites/check?productId=X
    @GetMapping(value = "/check", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> checkFavorite(
            @RequestParam("productId") Long productId,
            HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            boolean isFavorite = favoriteService.isFavorite(userId, productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("inWishlist", isFavorite);
            result.put("isFavorite", isFavorite);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // GET /api/favorites/list
    @GetMapping(value = {"/", "/list"}, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getFavorites(HttpServletRequest request) {
        
        System.out.println("=== GET FAVORITES LIST ===");
        
        HttpSession session = request.getSession(false);
        System.out.println("Session: " + session);
        
        if (session != null) {
            System.out.println("Session ID: " + session.getId());
            System.out.println("isLoggedIn: " + session.getAttribute("isLoggedIn"));
            System.out.println("userId: " + session.getAttribute("userId"));
            System.out.println("userId type: " + (session.getAttribute("userId") != null ? 
                session.getAttribute("userId").getClass().getName() : "null"));
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            System.out.println("User not logged in - returning 401");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            System.out.println("UserId is null - returning 401");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        System.out.println("Getting favorites for userId: " + userId);
        
        try {
            List<Product> favoriteProducts = favoriteService.getFavoriteProducts(userId);
            System.out.println("Found " + favoriteProducts.size() + " favorite products");
            return ResponseEntity.ok(favoriteProducts);
            
        } catch (Exception e) {
            System.out.println("Error getting favorites: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // GET /api/favorites/count
    @GetMapping(value = "/count", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getFavoriteCount(HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            long count = favoriteService.getFavoriteCount(userId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("count", count);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // POST /api/favorites/add
    @PostMapping(value = "/add", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> addToFavorites(
            @RequestBody Map<String, Object> payload,
            HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            Long productId = Long.valueOf(payload.get("productId").toString());
            
            boolean success = favoriteService.addToFavorites(userId, productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Đã thêm vào danh sách yêu thích" : "Sản phẩm đã có trong danh sách yêu thích");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra");
            return ResponseEntity.ok(result);
        }
    }
    
    // POST /api/favorites/remove
    @PostMapping(value = "/remove", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> removeFromFavorites(
            @RequestBody Map<String, Object> payload,
            HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            Long productId = Long.valueOf(payload.get("productId").toString());
            
            boolean success = favoriteService.removeFromFavorites(userId, productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Đã xóa khỏi danh sách yêu thích" : "Có lỗi xảy ra");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra");
            return ResponseEntity.ok(result);
        }
    }
    
    // POST /api/favorites/toggle/{productId}
    @PostMapping(value = "/toggle/{productId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> toggleFavorite(
            @PathVariable Long productId,
            HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            boolean isNowFavorite = favoriteService.toggleFavorite(userId, productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("isFavorite", isNowFavorite);
            result.put("message", isNowFavorite ? "Đã thêm vào danh sách yêu thích" : "Đã xóa khỏi danh sách yêu thích");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra");
            return ResponseEntity.ok(result);
        }
    }
}
