package com.mycompany.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.mycompany.model.Product;
import com.mycompany.service.ProductService;

@Controller
public class ProductDetailController {
    
    @Autowired
    private ProductService productService;
    
    /**
     * Hiển thị trang chi tiết sản phẩm
     */
    @GetMapping("/product-detail")
    public String showProductDetail(@RequestParam(required = false) Long id,
                                   @SessionAttribute(name = "userId", required = false) Long userId,
                                   Model model) {
        System.out.println("=== API /cart REQUEST ===");
        System.out.println("userId in session: " + userId);
        try {
            if (id == null) {
                // Redirect về trang all-products nếu không có ID
                return "redirect:/all-products.jsp";
            }
            
            // Lấy thông tin sản phẩm
            Optional<Product> productOpt = productService.getProductById(id);
            
            if (!productOpt.isPresent()) {
                // Sản phẩm không tồn tại
                model.addAttribute("error", "Không tìm thấy sản phẩm với ID: " + id);
                return "error";
            }
            
            Product product = productOpt.get();
            
            // Kiểm tra sản phẩm có active không
            if (!product.getIsActive()) {
                model.addAttribute("error", "Sản phẩm này hiện không khả dụng");
                return "error";
            }
            
            // Thêm sản phẩm vào model
            model.addAttribute("product", product);
            model.addAttribute("inStock", productService.isInStock(id));
            
            // Lấy sản phẩm liên quan (cùng category hoặc grade)
            List<Product> relatedProducts = getRelatedProducts(product);
            model.addAttribute("relatedProducts", relatedProducts);
            
            // Thêm thông tin meta cho SEO
            model.addAttribute("pageTitle", product.getName() + " - 43 Gundam Hobby");
            model.addAttribute("pageDescription", product.getDescription());
            model.addAttribute("pageKeywords", generateKeywords(product));
            
            return "product-detail";
            
        } catch (Exception e) {
            System.err.println("Error loading product detail: " + e.getMessage());
            model.addAttribute("error", "Có lỗi xảy ra khi tải thông tin sản phẩm");
            return "error";
        }
    }
    
    /**
     * Hiển thị trang chi tiết sản phẩm với đường dẫn SEO-friendly
     */
    @GetMapping("/product/{id}")
    public String showProductDetailSEO(@PathVariable Long id, 
                                      @SessionAttribute(name = "userId", required = false) Long userId,
                                      Model model) {
        System.out.println("=== API /cart REQUEST ===");
        System.out.println("userId in session: " + userId);
        return showProductDetail(id, userId, model);
    }
    
    /**
     * Lấy sản phẩm liên quan
     */
    private List<Product> getRelatedProducts(Product product) {
        try {
            // Ưu tiên lấy sản phẩm cùng category
            List<Product> relatedProducts = productService.getProductsByCategory(product.getCategory());
            
            // Loại bỏ sản phẩm hiện tại khỏi danh sách
            relatedProducts.removeIf(p -> p.getId().equals(product.getId()));
            
            // Giới hạn 8 sản phẩm
            if (relatedProducts.size() > 8) {
                relatedProducts = relatedProducts.subList(0, 8);
            }
            
            // Nếu không đủ 8 sản phẩm, lấy thêm từ cùng grade
            if (relatedProducts.size() < 8 && product.getGrade() != null) {
                List<Product> gradeProducts = productService.getProductsByGrade(product.getGrade());
                gradeProducts.removeIf(p -> p.getId().equals(product.getId()));
                
                for (Product gradeProduct : gradeProducts) {
                    if (relatedProducts.size() >= 8) break;
                    if (!relatedProducts.contains(gradeProduct)) {
                        relatedProducts.add(gradeProduct);
                    }
                }
            }
            
            return relatedProducts;
            
        } catch (Exception e) {
            System.err.println("Error getting related products: " + e.getMessage());
            return List.of(); // Trả về danh sách rỗng nếu có lỗi
        }
    }
    
    /**
     * Tạo keywords cho SEO
     */
    private String generateKeywords(Product product) {
        StringBuilder keywords = new StringBuilder();
        keywords.append(product.getName()).append(", ");
        keywords.append("gundam, ").append("mô hình, ");
        
        if (product.getCategory() != null) {
            keywords.append(product.getCategory().toString().toLowerCase()).append(", ");
        }
        
        if (product.getGrade() != null) {
            keywords.append(product.getGrade().toString().toLowerCase()).append(", ");
        }
        
        if (product.getBrand() != null) {
            keywords.append(product.getBrand().toLowerCase()).append(", ");
        }
        
        keywords.append("43 gundam hobby, bandai");
        
        return keywords.toString();
    }
}