package com.mycompany.controller;

import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import com.mycompany.model.ComplaintDTO;

import java.nio.charset.StandardCharsets;
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
        String sql = "SELECT c.complaint_code, " +
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

        @SuppressWarnings("unchecked")
        List<Object[]> results = (List<Object[]>) entityManager.createNativeQuery(sql).getResultList();

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
    @Transactional
    public ResponseEntity<String> updateComplaint(
            @PathVariable("code") String complaintCode,
            @RequestBody Map<String, Object> payload) {

        try {
            String status = (String) payload.get("status");
            String solution = (String) payload.get("solution");
            String staffResponse = (String) payload.get("staffResponse");

            // Kiểm tra dữ liệu đầu vào
            if (status == null || staffResponse == null || staffResponse.trim().isEmpty()) {
                return ResponseEntity
                        .badRequest()
                        .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                        .body("❌ Vui lòng nhập phản hồi của nhân viên.");
            }

            // Nếu phê duyệt thì phải có giải pháp
            if ("PROCESSING".equals(status) && (solution == null || solution.trim().isEmpty())) {
                return ResponseEntity
                        .badRequest()
                        .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                        .body("❌ Vui lòng chọn giải pháp khi phê duyệt khiếu nại.");
            }

            // Nếu từ chối mà không có solution thì gán rỗng
            if ("REJECTED".equals(status) && (solution == null || solution.trim().isEmpty())) {
                solution = ""; // để không gây lỗi khi insert/update
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
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                        .body("❌ Không tìm thấy khiếu nại với mã: " + complaintCode);
            }

            return ResponseEntity
                    .ok()
                    .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                    .body("✅ Cập nhật khiếu nại thành công!");
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi cập nhật complaint: " + complaintCode);
            System.err.println("==> Status: " + payload.get("status"));
            System.err.println("==> Solution: " + payload.get("solution"));
            System.err.println("==> StaffResponse: " + payload.get("staffResponse"));
            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                    .body("❌ Lỗi cập nhật khiếu nại: " + e.getMessage());
        }
    }
}
