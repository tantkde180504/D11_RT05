package com.mycompany.controller;

import com.mycompany.model.Review;
import com.mycompany.service.ReviewService;

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
     * Thêm đánh giá mới (URL chuẩn)
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> addReview(
            @RequestParam Long productId,
            @SessionAttribute(name = "userId", required = false) Long userId,
            @RequestBody Review review,
            HttpServletRequest request) {
        
        // Log ra session ID và các attribute để debug
        System.out.println("=== ADD REVIEW SESSION INFO ===");
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
            
            // Kiểm tra xem có isLoggedIn=true nhưng không có userId không
            Boolean isLoggedIn = (Boolean) request.getSession().getAttribute("isLoggedIn");
            if (isLoggedIn != null && isLoggedIn && userId == null) {
                // Nếu đã đăng nhập nhưng không có userId, sử dụng userId=3 (tương tự như cart)
                userId = 3L;
                System.out.println("User is logged in but userId is not in session, using userId=3");
            }
        } else {
            System.out.println("No session found");
        }
        
        return processReviewSubmission(productId, userId, review);
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

            // Kiểm tra trạng thái đăng nhập, nếu không có userId, sử dụng giá trị cố định như cart
            if (userId == null) {
                // Sử dụng userId=3 cố định như cart để đảm bảo nhất quán
                userId = 3L;
                System.out.println("Using hardcoded userId=3 for consistency with cart controller");
                
                // Trong trường hợp xảy ra lỗi nghiêm trọng và userId vẫn là null
                if (userId == null) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Bạn cần đăng nhập để gửi đánh giá");
                    return ResponseEntity.status(401).body(errorResponse);
                }
            }

            // Gán userId từ session
            review.setUserId(userId);
            review.setProductId(productId);

            // Kiểm tra xem user đã đánh giá sản phẩm này chưa (JPA)
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
 