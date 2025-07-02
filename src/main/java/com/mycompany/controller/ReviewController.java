package com.mycompany.controller;

import com.mycompany.model.Review;
import com.mycompany.service.ReviewService;
import com.mycompany.service.OrderService;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private OrderService orderService;

    /**
     * Lấy tất cả đánh giá của một sản phẩm
     */
    @GetMapping("/product/{productId}")
    public ResponseEntity<Map<String, Object>> getProductReviews(
            @PathVariable Long productId,
            @SessionAttribute(name = "userId", required = false) Long userId) {
        System.out.println("=== API /reviews/product/{productId} REQUEST ===");
        System.out.println("productId: " + productId);
        System.out.println("userId in session: " + userId);
        try {
            List<Review> reviews = reviewService.getReviewsByProductId(productId);
            System.out.println("Found " + reviews.size() + " reviews in service for productId: " + productId);
            Map<String, Object> statistics = reviewService.getReviewStatistics(productId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("reviews", reviews);
            response.put("statistics", statistics);
            response.put("total", reviews.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy đánh giá: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    /**
     * Thêm đánh giá mới (URL alternative cho frontend hiện tại)
     */
    @PostMapping("/product/{productId}")
    public ResponseEntity<Map<String, Object>> addReviewAlternative(
            @PathVariable Long productId,
            @SessionAttribute(name = "userId", required = false) Long userId,
            @RequestBody Review review,
            HttpServletRequest request) {
        // Lấy userId từ session nếu @SessionAttribute không có
        if (userId == null && request.getSession(false) != null) {
            Object userIdObj = request.getSession().getAttribute("userId");
            if (userIdObj instanceof Long) {
                userId = (Long) userIdObj;
            } else if (userIdObj instanceof Integer) {
                userId = ((Integer) userIdObj).longValue();
            } else if (userIdObj instanceof String) {
                try {
                    userId = Long.parseLong((String) userIdObj);
                } catch (Exception ignored) {}
            }
        }
        // Log ra session ID và các attribute để debug
        System.out.println("=== ADD REVIEW ALTERNATIVE SESSION INFO ===");
        if (request.getSession(false) != null) {
            System.out.println("Session ID: " + request.getSession().getId());
            Object userIdObj = request.getSession().getAttribute("userId");
            System.out.println("userId from session (raw): " + userIdObj);
            System.out.println("userId from session (type): " + (userIdObj != null ? userIdObj.getClass().getName() : "null"));
            System.out.println("userId from @SessionAttribute: " + userId);
            System.out.println("isLoggedIn from session: " + request.getSession().getAttribute("isLoggedIn"));
            
            // Nếu userId từ @SessionAttribute là null nhưng có trong session
            if (userId == null && userIdObj != null) {
                try {
                    // Thử chuyển đổi từ Object sang Long
                    if (userIdObj instanceof Long) {
                        userId = (Long) userIdObj;
                    } else if (userIdObj instanceof Integer) {
                        userId = ((Integer) userIdObj).longValue();
                    } else if (userIdObj instanceof String) {
                        userId = Long.parseLong((String) userIdObj);
                    }
                    System.out.println("Extracted userId from session: " + userId);
                } catch (Exception e) {
                    System.out.println("Error converting userId from session: " + e.getMessage());
                }
            }
        } else {
            System.out.println("No session found");
        }
        // Nếu không có userId thì trả về lỗi
        if (userId == null) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Bạn cần đăng nhập để gửi đánh giá");
            return ResponseEntity.status(401).body(errorResponse);
        }
        return processReviewSubmission(productId, userId, review);
    }

    /**
     * Xử lý logic thêm đánh giá chung
     */
    private ResponseEntity<Map<String, Object>> processReviewSubmission(
            Long productId,
            Long userId,
            Review review) {
        try {
            System.out.println("=== REVIEW SUBMISSION ===");
            System.out.println("ProductID: " + productId);
            System.out.println("UserID from session: " + userId);
            System.out.println("Review data: " + review);

            // Nếu không có userId thì không cho gửi review
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Bạn cần đăng nhập để gửi đánh giá");
                return ResponseEntity.status(401).body(errorResponse);
            }

            // Kiểm tra đã mua hàng chưa
            boolean hasPurchased = orderService.hasUserPurchasedProduct(userId, productId);
            if (!hasPurchased) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Bạn chỉ có thể đánh giá sản phẩm đã mua.");
                return ResponseEntity.status(403).body(errorResponse);
            }

            // Gán userId từ session
            review.setUserId(userId);
            review.setProductId(productId);

            // Kiểm tra xem user đã đánh giá sản phẩm này chưa (JPA) đánh giá 1 lần/ 1sp
            Optional<Review> existing = reviewService.findByUserIdAndProductId(userId, productId);
            if (existing.isPresent()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Bạn đã đánh giá sản phẩm này rồi!");
                return ResponseEntity.badRequest().body(errorResponse);
            }

            review.setCreatedAt(java.time.LocalDateTime.now());
            Review savedReview = reviewService.addReview(review);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("review", savedReview);
            response.put("message", "Đánh giá đã được thêm thành công");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi thêm đánh giá: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    /**
     * Lấy thống kê đánh giá cho sản phẩm
     */
    @GetMapping("/product/{productId}/statistics")
    public ResponseEntity<Map<String, Object>> getProductReviewStatistics(
            @PathVariable Long productId,
            @SessionAttribute(name = "userId", required = false) Long userId) {
        System.out.println("=== API /reviews/product/{productId}/statistics REQUEST ===");
        System.out.println("userId in session: " + userId);
        try {
            Map<String, Object> statistics = reviewService.getReviewStatistics(productId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("statistics", statistics);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy thống kê đánh giá: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
}
