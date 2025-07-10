package com.mycompany.repository;

import com.mycompany.model.Favorite;
import com.mycompany.model.Product;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class FavoriteRepository {
    
    @PersistenceContext
    private EntityManager entityManager;
    
    public void save(Favorite favorite) {
        if (favorite.getId() == null) {
            entityManager.persist(favorite);
        } else {
            entityManager.merge(favorite);
        }
        entityManager.flush();
    }
    
    public Optional<Favorite> findByUserIdAndProductId(Long userId, Long productId) {
        TypedQuery<Favorite> query = entityManager.createQuery(
            "SELECT f FROM Favorite f WHERE f.userId = :userId AND f.productId = :productId",
            Favorite.class
        );
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        
        List<Favorite> results = query.getResultList();
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }
    
    public List<Favorite> findByUserId(Long userId) {
        TypedQuery<Favorite> query = entityManager.createQuery(
            "SELECT f FROM Favorite f WHERE f.userId = :userId ORDER BY f.createdAt DESC",
            Favorite.class
        );
        query.setParameter("userId", userId);
        return query.getResultList();
    }
    
    public List<Product> findProductsByUserId(Long userId) {
        TypedQuery<Product> query = entityManager.createQuery(
            "SELECT p FROM Product p JOIN Favorite f ON p.id = f.productId " +
            "WHERE f.userId = :userId ORDER BY f.createdAt DESC",
            Product.class
        );
        query.setParameter("userId", userId);
        return query.getResultList();
    }
    
    public void deleteByUserIdAndProductId(Long userId, Long productId) {
        entityManager.createQuery(
            "DELETE FROM Favorite f WHERE f.userId = :userId AND f.productId = :productId"
        )
        .setParameter("userId", userId)
        .setParameter("productId", productId)
        .executeUpdate();
        entityManager.flush();
    }
    
    public void deleteById(Long id) {
        Favorite favorite = entityManager.find(Favorite.class, id);
        if (favorite != null) {
            entityManager.remove(favorite);
            entityManager.flush();
        }
    }
    
    public boolean existsByUserIdAndProductId(Long userId, Long productId) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(f) FROM Favorite f WHERE f.userId = :userId AND f.productId = :productId",
            Long.class
        );
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        return query.getSingleResult() > 0;
    }
    
    public long countByUserId(Long userId) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(f) FROM Favorite f WHERE f.userId = :userId",
            Long.class
        );
        query.setParameter("userId", userId);
        return query.getSingleResult();
    }
    
    public long countByProductId(Long productId) {
        TypedQuery<Long> query = entityManager.createQuery(
            "SELECT COUNT(f) FROM Favorite f WHERE f.productId = :productId",
            Long.class
        );
        query.setParameter("productId", productId);
        return query.getSingleResult();
    }
}
