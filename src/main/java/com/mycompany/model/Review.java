package com.mycompany.model;

import java.time.LocalDateTime;

public class Review {
    
    private Long id;
    private Long productId;
    private Long userId;
    private String reviewerName;
    private String reviewerEmail;
    private String title;
    private String content;
    private Integer rating; // 1-5 stars
    private Boolean isVerified = false;
    private Boolean isApproved = true;
    private Integer helpfulCount = 0;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    
    // Default constructor
    public Review() {
        this.createdDate = LocalDateTime.now();
        this.isVerified = false;
        this.isApproved = true;
        this.helpfulCount = 0;
    }
    
    // Constructor with essential fields
    public Review(Long productId, String reviewerName, String reviewerEmail, 
                  String title, String content, Integer rating) {
        this();
        this.productId = productId;
        this.reviewerName = reviewerName;
        this.reviewerEmail = reviewerEmail;
        this.title = title;
        this.content = content;
        this.rating = rating;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getReviewerName() {
        return reviewerName;
    }
    
    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }
    
    public String getReviewerEmail() {
        return reviewerEmail;
    }
    
    public void setReviewerEmail(String reviewerEmail) {
        this.reviewerEmail = reviewerEmail;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Integer getRating() {
        return rating;
    }
    
    public void setRating(Integer rating) {
        if (rating != null && (rating < 1 || rating > 5)) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating;
    }
    
    public Boolean getIsVerified() {
        return isVerified;
    }
    
    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }
    
    public Boolean getIsApproved() {
        return isApproved;
    }
    
    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }
    
    public Integer getHelpfulCount() {
        return helpfulCount;
    }
    
    public void setHelpfulCount(Integer helpfulCount) {
        this.helpfulCount = helpfulCount;
    }
    
    public LocalDateTime getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }
    
    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }
    
    // Utility methods
    public String getFormattedRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public String getTimeAgo() {
        if (createdDate == null) return "";
        
        LocalDateTime now = LocalDateTime.now();
        long minutes = java.time.Duration.between(createdDate, now).toMinutes();
        
        if (minutes < 60) {
            return minutes + " phút trước";
        } else if (minutes < 1440) { // 24 hours
            return (minutes / 60) + " giờ trước";
        } else if (minutes < 10080) { // 7 days
            return (minutes / 1440) + " ngày trước";
        } else {
            return createdDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
    }
    
    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", productId=" + productId +
                ", reviewerName='" + reviewerName + '\'' +
                ", rating=" + rating +
                ", title='" + title + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}
