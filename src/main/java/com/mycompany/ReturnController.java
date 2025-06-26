package com.mycompany;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/returns")
public class ReturnController {

    @Autowired
    private ReturnRepository returnRepository;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // ✅ API: Lấy danh sách returns (JOIN users + products + orders)
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ReturnDTO> getReturns(@RequestParam(value = "status", required = false) String status) {
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            return returnRepository.getReturnDetailsByStatus(status);
        }
        return returnRepository.getAllReturnDetails();
    }

    // ✅ API: Hoàn tất return
    @PostMapping("/complete")
    @Transactional
    public ResponseEntity<String> completeReturn(@RequestParam Long returnId) {
        int updated = returnRepository.completeReturn(returnId);
        if (updated > 0) {
            return ResponseEntity.ok("✅ Đã hoàn tất đơn trả hàng.");
        }
        return ResponseEntity.notFound().build();
    }

    // ✅ API: Xem chi tiết return
    @GetMapping(value = "/detail", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ReturnDTO> getReturnDetail(@RequestParam Long id) {
        List<ReturnDTO> list = returnRepository.getAllReturnDetails();
        return list.stream()
                .filter(dto -> dto.id.equals(id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // ✅ DTO dùng để trả dữ liệu ra frontend
    public static class ReturnDTO {
        public Long id;
        public String returnCode;
        public String complaintCode;
        public Long orderId;
        public String orderNumber;     // ✅ Mã đơn hàng (ORDxxxxxx)
        public String customerName;
        public String productName;
        public String reason;
        public String requestType;
        public String status;
        public String createdAt;
        public String updatedAt;
    }
}
