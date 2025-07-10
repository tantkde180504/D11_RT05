package com.mycompany;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DashboardRepository extends JpaRepository<Order, Long> {
    @Query(value = "SELECT COALESCE(SUM(CAST(total_amount AS FLOAT)), 0) AS revenue, COALESCE(COUNT(*), 0) AS order_count FROM orders WHERE status IN ('DELIVERED', 'SHIPPING') AND order_date IS NOT NULL AND DATEPART(month, order_date) = DATEPART(month, GETDATE()) AND DATEPART(year, order_date) = DATEPART(year, GETDATE())", nativeQuery = true)
    List<Object[]> getOrderStats();

    @Query(value = "SELECT COALESCE(COUNT(*), 0) FROM users WHERE role = 'CUSTOMER' AND created_at IS NOT NULL AND DATEPART(month, created_at) = DATEPART(month, GETDATE()) AND DATEPART(year, created_at) = DATEPART(year, GETDATE())", nativeQuery = true)
    Long getNewCustomersThisMonth();

    @Query(value = "SELECT COALESCE(COUNT(*), 0) FROM products", nativeQuery = true)
    Long getTotalProducts();

    @Query(value = "SELECT COALESCE(COUNT(*), 0) FROM products WHERE stock_quantity < 5", nativeQuery = true)
    Long getLowStockProducts();
} 