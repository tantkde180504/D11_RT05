package com.mycompany.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.mycompany.model.Review;

@Service
public class ReviewService {
    
    // Temporary in-memory storage for reviews (replace with database later)
    private final Map<Long, List<Review>> reviewsByProduct = new HashMap<>();
    private Long nextId = 1L;
    
    public ReviewService() {
        // Initialize with some sample data
        initializeSampleData();
    }
    
    /**
     * Lấy tất cả đánh giá của một sản phẩm
     */
    public List<Review> getReviewsByProductId(Long productId) {
        return reviewsByProduct.getOrDefault(productId, new ArrayList<>())
                .stream()
                .filter(Review::getIsApproved)
                .sorted((r1, r2) -> r2.getCreatedDate().compareTo(r1.getCreatedDate()))
                .collect(Collectors.toList());
    }
    
    /**
     * Thêm đánh giá mới
     */
    public Review addReview(Review review) {
        if (review.getProductId() == null) {
            throw new IllegalArgumentException("Product ID is required");
        }
        
        if (review.getRating() == null || review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        
        if (review.getReviewerName() == null || review.getReviewerName().trim().isEmpty()) {
            throw new IllegalArgumentException("Reviewer name is required");
        }
        
        if (review.getContent() == null || review.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Review content is required");
        }
        
        // Set default values
        review.setId(nextId++);
        review.setCreatedDate(LocalDateTime.now());
        review.setIsApproved(true);
        review.setIsVerified(false);
        review.setHelpfulCount(0);
        
        // Store review
        reviewsByProduct.computeIfAbsent(review.getProductId(), k -> new ArrayList<>()).add(review);
        
        return review;
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
        
        // Calculate average rating
        double averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
        
        // Calculate rating breakdown
        Map<Integer, Long> ratingCounts = reviews.stream()
                .collect(Collectors.groupingBy(Review::getRating, Collectors.counting()));
        
        Map<String, Object> ratingBreakdown = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            long count = ratingCounts.getOrDefault(i, 0L);
            double percentage = !reviews.isEmpty() ? (count * 100.0 / reviews.size()) : 0.0;
            
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
     * Lấy đánh giá theo rating
     */
    public List<Review> getReviewsByRating(Long productId, Integer rating) {
        return getReviewsByProductId(productId).stream()
                .filter(review -> review.getRating().equals(rating))
                .collect(Collectors.toList());
    }
    
    /**
     * Đánh dấu đánh giá hữu ích
     */
    public void markReviewHelpful(Long reviewId) {
        // Find and update review helpful count
        for (List<Review> reviews : reviewsByProduct.values()) {
            for (Review review : reviews) {
                if (review.getId().equals(reviewId)) {
                    review.setHelpfulCount(review.getHelpfulCount() + 1);
                    review.setUpdatedDate(LocalDateTime.now());
                    return;
                }
            }
        }
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
     * Khởi tạo dữ liệu mẫu
     */
    private void initializeSampleData() {
        // Sample reviews for product ID 1
        List<Review> product1Reviews = new ArrayList<>();
        
        Review review1 = new Review(1L, "Nguyễn Minh Tuấn", "tuan@email.com", 
                "Tuyệt vời!", "Sản phẩm chất lượng rất tốt, đóng gói cẩn thận. Mình rất hài lòng với chất lượng mô hình.", 5);
        review1.setId(1L);
        review1.setCreatedDate(LocalDateTime.now().minusDays(2));
        review1.setIsVerified(true);
        review1.setHelpfulCount(5);
        
        Review review2 = new Review(1L, "Trần Văn Hòa", "hoa@email.com", 
                "Đáng mua", "Giá cả hợp lý, chất lượng ổn. Ship nhanh.", 4);
        review2.setId(2L);
        review2.setCreatedDate(LocalDateTime.now().minusDays(5));
        review2.setHelpfulCount(3);
        
        Review review3 = new Review(1L, "Lê Thị Mai", "mai@email.com", 
                "Bình thường", "Sản phẩm không có gì đặc biệt lắm nhưng cũng không tệ.", 3);
        review3.setId(3L);
        review3.setCreatedDate(LocalDateTime.now().minusDays(7));
        review3.setHelpfulCount(1);
        
        Review review4 = new Review(1L, "Phạm Đức Anh", "anh@email.com", 
                "Rất hài lòng", "Mô hình đẹp, chi tiết tốt. Đúng như mô tả.", 5);
        review4.setId(4L);
        review4.setCreatedDate(LocalDateTime.now().minusDays(10));
        review4.setIsVerified(true);
        review4.setHelpfulCount(8);
        
        Review review5 = new Review(1L, "Võ Thanh Sơn", "son@email.com", 
                "Tốt", "Giao hàng nhanh, sản phẩm đúng mô tả.", 4);
        review5.setId(5L);
        review5.setCreatedDate(LocalDateTime.now().minusDays(15));
        review5.setHelpfulCount(2);
        
        product1Reviews.addAll(Arrays.asList(review1, review2, review3, review4, review5));
        reviewsByProduct.put(1L, product1Reviews);
        
        nextId = 6L; // Next available ID
        
        // Add sample reviews for other products
        initializeMoreSampleData();
    }
    
    private void initializeMoreSampleData() {
        // Sample reviews for product ID 2
        List<Review> product2Reviews = new ArrayList<>();
        
        Review review6 = new Review(2L, "Đặng Minh Quân", "quan@email.com", 
                "Xuất sắc!", "Chất lượng mô hình rất tốt, đáng đồng tiền bát gạo.", 5);
        review6.setId(nextId++);
        review6.setCreatedDate(LocalDateTime.now().minusDays(1));
        review6.setIsVerified(true);
        review6.setHelpfulCount(3);
        
        Review review7 = new Review(2L, "Bùi Văn Đức", "duc@email.com", 
                "Ổn", "Sản phẩm tạm được, nhưng có thể tốt hơn.", 3);
        review7.setId(nextId++);
        review7.setCreatedDate(LocalDateTime.now().minusDays(4));
        review7.setHelpfulCount(1);
        
        product2Reviews.addAll(Arrays.asList(review6, review7));
        reviewsByProduct.put(2L, product2Reviews);
    }
}
