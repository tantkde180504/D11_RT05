package com.mycompany.repository;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.mycompany.controller.ReturnController;
import com.mycompany.model.Return;

@Repository
public interface ReturnRepository extends JpaRepository<Return, Long> {

    // ✅ Hoàn tất return
    @Modifying
    @Transactional
    @Query("UPDATE Return r SET r.status = 'COMPLETED', r.updatedAt = CURRENT_TIMESTAMP WHERE r.id = :returnId")
    int completeReturn(@Param("returnId") Long returnId);

    // ✅ Trả tất cả return JOIN user + product + order_number (sản phẩm x số lượng)
    @Query(value =
        "SELECT r.id, r.return_code, r.complaint_code, r.order_id, " +
        "o.order_number, " +
        "u.first_name + ' ' + u.last_name AS customer_name, " +
        "p.name + ' x' + CAST(oi.quantity AS NVARCHAR) AS product_name, " +
        "r.reason, r.request_type, r.status, " +
        "FORMAT(r.created_at, 'yyyy-MM-dd HH:mm:ss') AS created_at, " +
        "FORMAT(r.updated_at, 'yyyy-MM-dd HH:mm:ss') AS updated_at " +
        "FROM returns r " +
        "JOIN users u ON r.user_id = u.id " +
        "JOIN products p ON r.product_id = p.id " +
        "JOIN order_items oi ON r.order_id = oi.order_id AND r.product_id = oi.product_id " +
        "JOIN orders o ON r.order_id = o.id " +
        "ORDER BY r.created_at DESC",
        nativeQuery = true)
    List<Object[]> getAllReturnDetailsRaw();

    // ✅ Trả return theo trạng thái
    @Query(value =
        "SELECT r.id, r.return_code, r.complaint_code, r.order_id, " +
        "o.order_number, " +
        "u.first_name + ' ' + u.last_name AS customer_name, " +
        "p.name + ' x' + CAST(oi.quantity AS NVARCHAR) AS product_name, " +
        "r.reason, r.request_type, r.status, " +
        "FORMAT(r.created_at, 'yyyy-MM-dd HH:mm:ss') AS created_at, " +
        "FORMAT(r.updated_at, 'yyyy-MM-dd HH:mm:ss') AS updated_at " +
        "FROM returns r " +
        "JOIN users u ON r.user_id = u.id " +
        "JOIN products p ON r.product_id = p.id " +
        "JOIN order_items oi ON r.order_id = oi.order_id AND r.product_id = oi.product_id " +
        "JOIN orders o ON r.order_id = o.id " +
        "WHERE r.status = :status " +
        "ORDER BY r.created_at DESC",
        nativeQuery = true)
    List<Object[]> getReturnDetailsByStatusRaw(@Param("status") String status);

    // ✅ Chuyển về DTO - static mapper để tránh lỗi private method trong interface
    static ReturnController.ReturnDTO mapRowToDTO(Object[] row) {
        ReturnController.ReturnDTO dto = new ReturnController.ReturnDTO();
        dto.id = ((Number) row[0]).longValue();
        dto.returnCode = (String) row[1];
        dto.complaintCode = (String) row[2];
        dto.orderId = ((Number) row[3]).longValue();
        dto.orderNumber = (String) row[4];
        dto.customerName = (String) row[5];
        dto.productName = (String) row[6];
        dto.reason = (String) row[7];
        dto.requestType = (String) row[8];
        dto.status = (String) row[9];
        dto.createdAt = (String) row[10];
        dto.updatedAt = (String) row[11];
        return dto;
    }

    // ✅ API công khai trả về DTO
    default List<ReturnController.ReturnDTO> getAllReturnDetails() {
        return getAllReturnDetailsRaw().stream()
            .map(ReturnRepository::mapRowToDTO)
            .collect(Collectors.toList());
    }

    default List<ReturnController.ReturnDTO> getReturnDetailsByStatus(String status) {
        return getReturnDetailsByStatusRaw(status).stream()
            .map(ReturnRepository::mapRowToDTO)
            .collect(Collectors.toList());
    }
}
