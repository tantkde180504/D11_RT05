package com.mycompany;

import jakarta.persistence.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/complaints")
public class ComplaintController {

    @PersistenceContext
    private EntityManager entityManager;

    // ===============================
    // API: Lấy danh sách khiếu nại
    // ===============================
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ComplaintDTO> getAllComplaints() {
        String sql =
            "SELECT c.complaint_code, " +
            "       u.first_name + ' ' + u.last_name AS customer_name, " +
            "       u.email, " +
            "       u.phone, " +
            "       o.order_number, " +
            "       c.status, " +
            "       c.category, " +
            "       c.content, " +
            "       c.solution, " +
            "       c.staff_response, " +
            "       c.created_at, " +
            "       c.updated_at " +
            "FROM complaints c " +
            "INNER JOIN users u ON c.user_id = u.id " +
            "INNER JOIN orders o ON c.order_id = o.id " +
            "ORDER BY c.created_at DESC";

        List<Object[]> results = entityManager.createNativeQuery(sql).getResultList();
        List<ComplaintDTO> complaints = new ArrayList<>();

        for (Object[] row : results) {
            ComplaintDTO dto = new ComplaintDTO();
            dto.setComplaintCode((String) row[0]);
            dto.setCustomerName((String) row[1]);
            dto.setCustomerEmail((String) row[2]);
            dto.setCustomerPhone((String) row[3]);
            dto.setOrderNumber((String) row[4]);
            dto.setStatus((String) row[5]);
            dto.setCategory((String) row[6]);
            dto.setContent((String) row[7]);
            dto.setSolution((String) row[8]);
            dto.setStaffResponse((String) row[9]);
            dto.setCreatedAt(row[10] != null ? ((java.sql.Timestamp) row[10]).toLocalDateTime() : null);
            dto.setUpdatedAt(row[11] != null ? ((java.sql.Timestamp) row[11]).toLocalDateTime() : null);
            complaints.add(dto);
        }

        return complaints;
    }

    // ========================================
    // API: Cập nhật khiếu nại (PUT /{code})
    // ========================================
    @PutMapping(path = "/{code}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> updateComplaint(
            @PathVariable("code") String complaintCode,
            @RequestBody Map<String, Object> payload) {

        try {
            String status = (String) payload.get("status");
            String solution = (String) payload.get("solution");
            String staffResponse = (String) payload.get("staffResponse");

            // Kiểm tra dữ liệu đầu vào
            if (status == null || solution == null || staffResponse == null) {
                return ResponseEntity.badRequest().body("Thiếu dữ liệu cập nhật.");
            }

            // Cập nhật bằng native SQL
            String sql = "UPDATE complaints " +
                         "SET status = ?, solution = ?, staff_response = ?, updated_at = ? " +
                         "WHERE complaint_code = ?";
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter(1, status);
            query.setParameter(2, solution);
            query.setParameter(3, staffResponse);
            query.setParameter(4, LocalDateTime.now());
            query.setParameter(5, complaintCode);

            int updatedRows = query.executeUpdate();
            if (updatedRows == 0) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("Không tìm thấy khiếu nại với mã: " + complaintCode);
            }

            return ResponseEntity.ok("Cập nhật khiếu nại thành công!");
        } catch (Exception e) {
            // In toàn bộ lỗi chi tiết ra console
            e.printStackTrace(); // ⚠️ Quan trọng để debug lỗi thực tế
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi cập nhật khiếu nại: " + e.getMessage());
        }
    }
}
