package com.mycompany.repository;

import com.mycompany.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    
    // Lấy danh sách đánh giá theo productId (mới nhất trước)
    List<Review> findByProductIdOrderByCreatedAtDesc(Long productId);


    // Lọc đánh giá theo productId và rating
    List<Review> findByProductIdAndRating(Long productId, Integer rating);


    // Lấy review theo userId và productId (chống trùng đánh giá)
    java.util.Optional<Review> findByUserIdAndProductId(Long userId, Long productId);
}
