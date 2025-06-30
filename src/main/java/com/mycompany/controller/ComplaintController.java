package com.mycompany.controller;

import jakarta.persistence.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import com.mycompany.model.ComplaintDTO;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/complaints")
public class ComplaintController {

    @PersistenceContext
    private EntityManager entityManager;

    // ✅ API 1: Lấy danh sách khiếu nại
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
            dto.setCreatedAt(row[10] != null ? ((Timestamp) row[10]).toLocalDateTime() : null);
            dto.setUpdatedAt(row[11] != null ? ((Timestamp) row[11]).toLocalDateTime() : null);
            complaints.add(dto);
        }

        return complaints;
    }

    // ✅ API 2: Cập nhật khiếu nại
    @PutMapping(path = "/{code}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> updateComplaint(
            @PathVariable("code") String complaintCode,
            @RequestBody Map<String, Object> payload) {

        try {
            String status = (String) payload.get("status");
            String solution = (String) payload.get("solution");
            String staffResponse = (String) payload.get("staffResponse");

            String sql = "UPDATE complaints SET status = ?, solution = ?, staff_response = ?, updated_at = ? WHERE complaint_code = ?";
            Query query = entityManager.createNativeQuery(sql);
            query.setParameter(1, status);
            query.setParameter(2, solution);
            query.setParameter(3, staffResponse);
            query.setParameter(4, Timestamp.valueOf(LocalDateTime.now()));
            query.setParameter(5, complaintCode);

            int updatedRows = query.executeUpdate();
            if (updatedRows == 0) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Không tìm thấy khiếu nại.");
            }

            return ResponseEntity.ok("Cập nhật khiếu nại thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi cập nhật: " + e.getMessage());
        }
    }

    // ✅ API 3: Gửi khiếu nại mới
    @PostMapping(path = "/create", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public ResponseEntity<?> createComplaint(
            HttpServletRequest request,
            @RequestBody Map<String, String> payload) {

        Map<String, Object> resp = new HashMap<>();
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "Bạn chưa đăng nhập!");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
        }

        try {
            Long orderId = Long.valueOf(payload.get("orderId"));
            String category = payload.getOrDefault("category", "").trim();
            String content = payload.getOrDefault("content", "").trim();

            if (content.isEmpty()) {
                resp.put("success", false);
                resp.put("message", "Nội dung khiếu nại không được để trống!");
                return ResponseEntity.badRequest().body(resp);
            }

            String checkSql = "SELECT COUNT(*) FROM orders WHERE id = ? AND user_id = ? AND status = 'DELIVERED'";
            Object result = entityManager.createNativeQuery(checkSql)
                    .setParameter(1, orderId)
                    .setParameter(2, userId)
                    .getSingleResult();

            if (result == null || ((Number) result).intValue() == 0) {
                resp.put("success", false);
                resp.put("message", "Chỉ có thể khiếu nại đơn hàng đã giao và thuộc về bạn.");
                return ResponseEntity.ok(resp);
            }

            String complaintCode = "CP" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
            String insertSql = "INSERT INTO complaints (complaint_code, user_id, order_id, category, content, status, created_at, updated_at) "
                    +
                    "VALUES (?, ?, ?, ?, ?, 'PENDING', ?, ?)";

            entityManager.createNativeQuery(insertSql)
                    .setParameter(1, complaintCode)
                    .setParameter(2, userId)
                    .setParameter(3, orderId)
                    .setParameter(4, category)
                    .setParameter(5, content)
                    .setParameter(6, Timestamp.valueOf(LocalDateTime.now()))
                    .setParameter(7, Timestamp.valueOf(LocalDateTime.now()))
                    .executeUpdate();

            resp.put("success", true);
            resp.put("message", "Gửi khiếu nại thành công!");
            return ResponseEntity.ok(resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.put("success", false);
            resp.put("message", "Lỗi máy chủ: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(resp);
        }
    }

    // ✅ API 4: Lấy khiếu nại của chính user
    @GetMapping(path = "/my", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getMyComplaints(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Long userId = (session != null) ? (Long) session.getAttribute("userId") : null;

        System.out.println("===> [GET /api/complaints/my] userId in session = " + userId);

        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Collections.singletonMap("message", "Bạn chưa đăng nhập!"));
        }

        try {
            String sql = "SELECT c.complaint_code, " +
                    "       o.order_number, " +
                    "       c.category, " +
                    "       c.content, " +
                    "       c.status, " +
                    "       c.staff_response, " +
                    "       c.created_at, " +
                    "       (SELECT TOP 1 p.name FROM order_items oi2 " +
                    "        INNER JOIN products p ON oi2.product_id = p.id " +
                    "        WHERE oi2.order_id = o.id) as product_name, " +
                    "       (SELECT TOP 1 p.image_url FROM order_items oi2 " +
                    "        INNER JOIN products p ON oi2.product_id = p.id " +
                    "        WHERE oi2.order_id = o.id) as product_image, " +
                    "       (SELECT COUNT(*) FROM order_items oi2 WHERE oi2.order_id = o.id) as total_items " +
                    "FROM complaints c " +
                    "INNER JOIN orders o ON c.order_id = o.id " +
                    "WHERE c.user_id = ? " +
                    "ORDER BY c.created_at DESC";

            List<Object[]> rows = entityManager.createNativeQuery(sql)
                    .setParameter(1, userId)
                    .getResultList();

            List<Map<String, Object>> result = new ArrayList<>();
            for (Object[] row : rows) {
                Map<String, Object> item = new HashMap<>();
                item.put("complaintCode", row[0]);
                item.put("orderNumber", row[1]);
                item.put("category", row[2]);
                item.put("content", row[3]);
                item.put("status", row[4]);
                item.put("staffResponse", row[5]);
                item.put("createdAt", row[6] != null ? row[6].toString() : null);
                item.put("productName", row[7] != null ? row[7].toString() : "N/A");
                item.put("productImage", row[8] != null ? row[8].toString() : "");
                item.put("totalItems", row[9] != null ? row[9].toString() : "1");
                result.add(item);
            }

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("message", "Lỗi máy chủ: " + e.getMessage()));
        }
    }
}