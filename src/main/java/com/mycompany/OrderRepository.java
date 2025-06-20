package com.mycompany;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OrderRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Xác nhận đơn hàng mới
    public int confirmOrder(Long orderId) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, "CONFIRMED", orderId);
    }

    // Cập nhật trạng thái đơn hàng
    public int updateOrderStatus(Long orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, orderId);
    }

    // Hủy đơn hàng
    public int cancelOrder(Long orderId) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, "Đã hủy", orderId);
    }

    // Hủy đơn hàng theo order_number
    public int cancelOrderByOrderNumber(String orderNumber) {
        String sql = "UPDATE orders SET status = ? WHERE order_number = ?";
        return jdbcTemplate.update(sql, "CANCELLED", orderNumber);
    }

    // Lấy thông tin đơn hàng (đơn giản, chỉ id và status)
    public Map<String, Object> getOrderById(Long orderId) {
        String sql = "SELECT id, status FROM orders WHERE id = ?";
        try {
            return jdbcTemplate.queryForMap(sql, orderId);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // Lấy thông tin đơn hàng theo order_number
    public Map<String, Object> getOrderByOrderNumber(String orderNumber) {
        String sql = "SELECT * FROM orders WHERE order_number = ?";
        try {
            return jdbcTemplate.queryForMap(sql, orderNumber);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }
}