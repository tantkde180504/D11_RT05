package com.mycompany.service;

import com.mycompany.model.Review;
import com.mycompany.repository.ReviewRepository;
import com.mycompany.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private OrderRepository orderRepository;

    /**
     * Kiểm tra xem người dùng đã mua sản phẩm chưa
     */
    private boolean hasUserPurchasedProduct(Long userId, Long productId) {
        return orderRepository.existsByUserIdAndProductId(userId, productId);
    }

    /**
     * Lấy tất cả đánh giá của một sản phẩm
     */
    public List<Review> getReviewsByProductId(Long productId) {
        return reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);
    }

    /**
     * Thêm đánh giá mới
     */
    public Review addReview(Review review) {
        // Validate product ID
        if (review.getProductId() == null) {
            throw new IllegalArgumentException("Product ID is required");
        }

        // Validate user ID
        if (review.getUserId() == null) {
            throw new IllegalArgumentException("User ID is required");
        }

        // Kiểm tra xem người dùng đã mua sản phẩm chưa
        if (!hasUserPurchasedProduct(review.getUserId(), review.getProductId())) {
            throw new IllegalArgumentException("Bạn chỉ có thể đánh giá sản phẩm đã mua");
        }

        // Validate rating
        if (review.getRating() == null || review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }

        // Validate comment
        if (review.getComment() == null || review.getComment().trim().isEmpty()) {
            throw new IllegalArgumentException("Review content is required");
        }

        // Trim comment to remove extra whitespace
        review.setComment(review.getComment().trim());

        // Set metadata
        review.setCreatedAt(LocalDateTime.now());
        review.setIsVerified(false);

        return reviewRepository.save(review);
    }

    /**
     * Lấy thống kê đánh giá cho sản phẩm
     */
    public Map<String, Object> getReviewStatistics(Long productId) {
        List<Review> reviews = getReviewsByProductId(productId);

        Map<String, Object> stats = new HashMap<>();

        if (reviews.isEmpty()) {
            stats.put("totalReviews", 0);
            stats.put("averageRating", 0.0);
            stats.put("ratingBreakdown", createEmptyRatingBreakdown());
            return stats;
        }

        double averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);

        Map<Integer, Long> ratingCounts = reviews.stream()
                .collect(Collectors.groupingBy(Review::getRating, Collectors.counting()));

        Map<String, Object> ratingBreakdown = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            long count = ratingCounts.getOrDefault(i, 0L);
            double percentage = reviews.size() > 0 ? (count * 100.0 / reviews.size()) : 0.0;

            Map<String, Object> breakdown = new HashMap<>();
            breakdown.put("count", count);
            breakdown.put("percentage", Math.round(percentage));

            ratingBreakdown.put(i + "_star", breakdown);
        }

        stats.put("totalReviews", reviews.size());
        stats.put("averageRating", Math.round(averageRating * 10.0) / 10.0);
        stats.put("ratingBreakdown", ratingBreakdown);

        return stats;
    }

    /**
     * Tạo rating breakdown rỗng
     */
    private Map<String, Object> createEmptyRatingBreakdown() {
        Map<String, Object> breakdown = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            Map<String, Object> ratingData = new HashMap<>();
            ratingData.put("count", 0);
            ratingData.put("percentage", 0);
            breakdown.put(i + "_star", ratingData);
        }
        return breakdown;
    }

    /**
     * Lấy đánh giá theo rating
     */
    public List<Review> getReviewsByRating(Long productId, Integer rating) {
        return reviewRepository.findByProductIdAndRating(productId, rating);
    }

    /**
     * Tìm đánh giá theo userId và productId (chống trùng đánh giá)
     */
    public Optional<Review> findByUserIdAndProductId(Long userId, Long productId) {
        return reviewRepository.findByUserIdAndProductId(userId, productId);
    }
}
