package com.mycompany.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.model.Review;
import com.mycompany.service.ReviewService;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;
    
    /**
     * Lấy tất cả đánh giá của một sản phẩm
     */
    @GetMapping("/product/{productId}")
    public ResponseEntity<Map<String, Object>> getProductReviews(@PathVariable Long productId) {
        try {
            List<Review> reviews = reviewService.getReviewsByProductId(productId);
            Map<String, Object> statistics = reviewService.getReviewStatistics(productId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("reviews", reviews);
            response.put("statistics", statistics);
            response.put("total", reviews.size());
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy đánh giá: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    /**
     * Thêm đánh giá mới
     */
    @PostMapping("/product/{productId}")
    public ResponseEntity<Map<String, Object>> addReview(
            @PathVariable Long productId,
            @RequestBody Review review) {
        try {
            review.setProductId(productId);
            Review savedReview = reviewService.addReview(review);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("review", savedReview);
            response.put("message", "Đánh giá đã được thêm thành công");
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi thêm đánh giá: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    /**
     * Lấy thống kê đánh giá cho sản phẩm
     */
    @GetMapping("/product/{productId}/statistics")
    public ResponseEntity<Map<String, Object>> getReviewStatistics(@PathVariable Long productId) {
        try {
            Map<String, Object> statistics = reviewService.getReviewStatistics(productId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("statistics", statistics);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy thống kê đánh giá: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
}