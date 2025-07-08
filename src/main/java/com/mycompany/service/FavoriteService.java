package com.mycompany.service;

import com.mycompany.model.Favorite;
import com.mycompany.model.Product;
import com.mycompany.repository.FavoriteRepository;
import jakarta.inject.Inject;
import java.util.List;

public class FavoriteService {
    
    @Inject
    private FavoriteRepository favoriteRepository;
    
    public boolean addToFavorites(Long userId, Long productId) {
        try {
            // Check if already exists
            if (favoriteRepository.existsByUserIdAndProductId(userId, productId)) {
                return false; // Already in favorites
            }
            
            Favorite favorite = new Favorite(userId, productId);
            favoriteRepository.save(favorite);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean removeFromFavorites(Long userId, Long productId) {
        try {
            favoriteRepository.deleteByUserIdAndProductId(userId, productId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean toggleFavorite(Long userId, Long productId) {
        try {
            if (favoriteRepository.existsByUserIdAndProductId(userId, productId)) {
                favoriteRepository.deleteByUserIdAndProductId(userId, productId);
                return false; // Removed from favorites
            } else {
                Favorite favorite = new Favorite(userId, productId);
                favoriteRepository.save(favorite);
                return true; // Added to favorites
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean isFavorite(Long userId, Long productId) {
        try {
            return favoriteRepository.existsByUserIdAndProductId(userId, productId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Product> getFavoriteProducts(Long userId) {
        try {
            return favoriteRepository.findProductsByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    public List<Favorite> getUserFavorites(Long userId) {
        try {
            return favoriteRepository.findByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    public long getFavoriteCount(Long userId) {
        try {
            return favoriteRepository.countByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    public long getProductFavoriteCount(Long productId) {
        try {
            return favoriteRepository.countByProductId(productId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
