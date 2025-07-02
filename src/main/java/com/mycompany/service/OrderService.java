package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mycompany.repository.OrderRepository;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;

    /**
     * Kiểm tra user đã mua product chưa (đơn hàng đã giao thành công)
     */
    public boolean hasUserPurchasedProduct(Long userId, Long productId) {
        if (userId == null || productId == null) return false;
        return orderRepository.existsByUserIdAndProductId(userId, productId);
    }
}
