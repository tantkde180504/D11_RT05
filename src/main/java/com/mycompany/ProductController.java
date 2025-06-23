    package com.mycompany;

    import jakarta.persistence.*;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.*;
    import org.springframework.web.bind.annotation.*;
    import org.springframework.http.MediaType;


    import java.util.List;

    @RestController
    @RequestMapping("/api/products")
    public class ProductController {

        @Autowired
        private ProductRepository productRepository;

        @PersistenceContext
        private EntityManager entityManager;

        // API: Lấy danh sách sản phẩm tồn kho
        @GetMapping(value = "/inventory", produces = MediaType.APPLICATION_JSON_VALUE)
        public List<Product> getInventoryList() {
            return productRepository.findByIsActiveTrueOrderByUpdatedAtDesc();
        }

        // API: Cập nhật tồn kho thông qua stored procedure
        @PostMapping("/update-stock")
        public ResponseEntity<?> updateStock(@RequestParam Long productId,
                                            @RequestParam int quantity,
                                            @RequestParam String type) {
            try {
                StoredProcedureQuery query = entityManager.createStoredProcedureQuery("sp_update_product_stock");
                query.registerStoredProcedureParameter("product_id", Long.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("quantity", Integer.class, ParameterMode.IN);
                query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);

                query.setParameter("product_id", productId);
                query.setParameter("quantity", quantity);
                query.setParameter("type", type);
                query.execute();

                return ResponseEntity.ok("✅ Cập nhật tồn kho thành công");
            } catch (Exception e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("❌ Lỗi cập nhật tồn kho: " + e.getMessage());
            }
        }
    }
