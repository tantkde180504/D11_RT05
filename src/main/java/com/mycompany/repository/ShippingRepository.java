package com.mycompany.repository;

import com.mycompany.model.Shipping;
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class ShippingRepository {
    @PersistenceContext
    private EntityManager em;

    public List<Shipping> findAll(String status) {
        String sql =
            "SELECT o.id AS orderId, o.order_number AS orderNumber, " +
            "o.shipping_name AS customerName, " +
            "o.total_amount AS totalAmount, " +
            "o.status AS status, " +
            "o.order_date AS orderDate " +
            "FROM shipping s " +
            "JOIN orders o ON o.id = s.order_id " +
            "WHERE (:status = 'ALL' OR s.status = :status) " +
            "ORDER BY o.order_date DESC";

        @SuppressWarnings("unchecked")
        List<Object[]> result = em.createNativeQuery(sql)
                .setParameter("status", status)
                .getResultList();

        java.util.List<Shipping> shippingList = new java.util.ArrayList<>();
        for (Object[] row : result) {
            Shipping dto = new Shipping();
            // Sửa lỗi ép kiểu: dùng Number để lấy longValue()
            dto.setOrderId(row[0] != null ? ((Number) row[0]).longValue() : null);
            dto.setOrderNumber((String) row[1]);
            dto.setCustomerName((String) row[2]);
            dto.setTotalAmount((BigDecimal) row[3]);
            dto.setStatus((String) row[4]);
            dto.setOrderDate(row[5] != null ? ((Timestamp) row[5]).toLocalDateTime() : null);
            dto.setProducts(findProductsByOrderId(dto.getOrderId()));
            shippingList.add(dto);
        }
        return shippingList;
    }

    private List<String> findProductsByOrderId(Long orderId) {
        @SuppressWarnings("unchecked")
        List<String> result = em.createNativeQuery(
            "SELECT p.name FROM order_items oi " +
            "JOIN products p ON p.id = oi.product_id " +
            "WHERE oi.order_id = :orderId"
        ).setParameter("orderId", orderId).getResultList();
        return result;
    }

    public void updateStatus(Long orderId, String status) {
        em.createNativeQuery("UPDATE shipping SET status = :status WHERE order_id = :orderId")
                .setParameter("status", status)
                .setParameter("orderId", orderId)
                .executeUpdate();
    }
}

