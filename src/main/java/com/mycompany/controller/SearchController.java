package com.mycompany.controller;

import com.mycompany.model.Product;
import com.mycompany.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/search")
public class SearchController {
    
    @Autowired
    private ProductService productService;
    
    /**
     * Test endpoint to verify controller is working
     */
    @GetMapping("/test")
    @ResponseBody
    public String testEndpoint() {
        return "SearchController is working!";
    }
    
    /**
     * Trang tìm kiếm chính
     */
    @GetMapping
    public String searchPage(@RequestParam(value = "q", required = false) String query,
                           @RequestParam(value = "category", required = false) String category,
                           @RequestParam(value = "minPrice", required = false) Double minPrice,
                           @RequestParam(value = "maxPrice", required = false) Double maxPrice,
                           @RequestParam(value = "sort", required = false, defaultValue = "name") String sort,
                           @RequestParam(value = "order", required = false, defaultValue = "asc") String order,
                           @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                           @RequestParam(value = "size", required = false, defaultValue = "12") int size,
                           Model model) {
        
        System.out.println("SearchController.searchPage called with query: " + query);
        
        // Thêm các tham số vào model để hiển thị lại trên form
        model.addAttribute("query", query != null ? query : "");
        model.addAttribute("category", category != null ? category : "");
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        
        // Thêm danh sách categories để hiển thị filter
        model.addAttribute("categories", getProductCategories());
        
        return "search-results";
    }
    
    /**
     * API tìm kiếm sản phẩm
     */
    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchProducts(
            @RequestParam(value = "q", required = false) String query,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "minPrice", required = false) Double minPrice,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice,
            @RequestParam(value = "sort", required = false, defaultValue = "name") String sort,
            @RequestParam(value = "order", required = false, defaultValue = "asc") String order,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            @RequestParam(value = "size", required = false, defaultValue = "12") int size) {
        
        try {
            // Lấy tất cả sản phẩm active
            List<Product> allProducts = productService.getAllActiveProducts();
            
            // Áp dụng filters
            List<Product> filteredProducts = filterProducts(allProducts, query, category, minPrice, maxPrice);
            
            // Sắp xếp
            filteredProducts = sortProducts(filteredProducts, sort, order);
            
            // Phân trang
            Map<String, Object> paginatedResult = paginateProducts(filteredProducts, page, size);
            
            // Tạo response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            
            @SuppressWarnings("unchecked")
            List<Product> productsToConvert = (List<Product>) paginatedResult.get("products");
            response.put("products", convertProductsToJson(productsToConvert));
            
            response.put("pagination", paginatedResult.get("pagination"));
            response.put("totalResults", filteredProducts.size());
            response.put("query", query);
            response.put("filters", createFiltersInfo(query, category, minPrice, maxPrice, sort, order));
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi tìm kiếm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    /**
     * API gợi ý tìm kiếm (autocomplete)
     */
    @GetMapping("/suggestions")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSearchSuggestions(
            @RequestParam("q") String query) {
        
        try {
            List<String> suggestions = new ArrayList<>();
            
            if (query != null && query.trim().length() >= 2) {
                List<Product> allProducts = productService.getAllActiveProducts();
                
                // Tìm gợi ý từ tên sản phẩm
                Set<String> productSuggestions = allProducts.stream()
                        .filter(p -> p.getName().toLowerCase().contains(query.toLowerCase()))
                        .map(Product::getName)
                        .limit(5)
                        .collect(Collectors.toSet());
                
                // Tìm gợi ý từ categories
                Set<String> categorySuggestions = allProducts.stream()
                        .filter(p -> p.getCategory() != null && 
                                   p.getCategory().toString().replace("_", " ").toLowerCase().contains(query.toLowerCase()))
                        .map(p -> p.getCategory().toString().replace("_", " "))
                        .distinct()
                        .limit(3)
                        .collect(Collectors.toSet());
                
                suggestions.addAll(productSuggestions);
                suggestions.addAll(categorySuggestions);
                
                // Thêm một số gợi ý phổ biến
                if (suggestions.size() < 5) {
                    List<String> popularSearches = Arrays.asList(
                        "Gundam", "RG", "MG", "HG", "PG", "Strike", "Freedom", "Barbatos", "Wing"
                    );
                    
                    for (String popular : popularSearches) {
                        if (popular.toLowerCase().contains(query.toLowerCase()) && 
                            !suggestions.contains(popular) && suggestions.size() < 8) {
                            suggestions.add(popular);
                        }
                    }
                }
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("suggestions", suggestions);
            response.put("query", query);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy gợi ý: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    /**
     * Lọc sản phẩm theo các tiêu chí
     */
    private List<Product> filterProducts(List<Product> products, String query, String category, 
                                       Double minPrice, Double maxPrice) {
        return products.stream()
                .filter(product -> {
                    // Filter by search query
                    if (query != null && !query.trim().isEmpty()) {
                        String searchTerm = query.toLowerCase().trim();
                        return product.getName().toLowerCase().contains(searchTerm) ||
                               (product.getDescription() != null && 
                                product.getDescription().toLowerCase().contains(searchTerm)) ||
                               (product.getCategory() != null && 
                                product.getCategory().toString().toLowerCase().contains(searchTerm)) ||
                               (product.getGrade() != null && 
                                product.getGrade().toString().toLowerCase().contains(searchTerm)) ||
                               (product.getBrand() != null && 
                                product.getBrand().toLowerCase().contains(searchTerm));
                    }
                    return true;
                })
                .filter(product -> {
                    // Filter by category
                    if (category != null && !category.trim().isEmpty()) {
                        try {
                            // Try to match enum value directly
                            Product.Category categoryEnum = Product.Category.valueOf(category.toUpperCase().replace(" ", "_"));
                            return product.getCategory() == categoryEnum;
                        } catch (IllegalArgumentException e) {
                            // If enum parsing fails, try string comparison
                            return product.getCategory() != null && 
                                   product.getCategory().toString().replace("_", " ").equalsIgnoreCase(category);
                        }
                    }
                    return true;
                })
                .filter(product -> {
                    // Filter by min price
                    if (minPrice != null && minPrice > 0) {
                        return product.getPrice().compareTo(BigDecimal.valueOf(minPrice)) >= 0;
                    }
                    return true;
                })
                .filter(product -> {
                    // Filter by max price
                    if (maxPrice != null && maxPrice > 0) {
                        return product.getPrice().compareTo(BigDecimal.valueOf(maxPrice)) <= 0;
                    }
                    return true;
                })
                .collect(Collectors.toList());
    }
    
    /**
     * Sắp xếp sản phẩm
     */
    private List<Product> sortProducts(List<Product> products, String sort, String order) {
        Comparator<Product> comparator;
        
        switch (sort.toLowerCase()) {
            case "price":
                comparator = Comparator.comparing(Product::getPrice);
                break;
            case "name":
                comparator = Comparator.comparing(Product::getName, String.CASE_INSENSITIVE_ORDER);
                break;
            case "category":
                comparator = Comparator.comparing((Product p) -> p.getCategory() != null ? p.getCategory().toString() : "", 
                                                String.CASE_INSENSITIVE_ORDER);
                break;
            case "id":
                comparator = Comparator.comparing(Product::getId);
                break;
            default:
                comparator = Comparator.comparing(Product::getName, String.CASE_INSENSITIVE_ORDER);
        }
        
        if ("desc".equalsIgnoreCase(order)) {
            comparator = comparator.reversed();
        }
        
        return products.stream()
                .sorted(comparator)
                .collect(Collectors.toList());
    }
    
    /**
     * Phân trang sản phẩm
     */
    private Map<String, Object> paginateProducts(List<Product> products, int page, int size) {
        int totalElements = products.size();
        int totalPages = (int) Math.ceil((double) totalElements / size);
        
        // Ensure page is within bounds
        page = Math.max(1, Math.min(page, totalPages));
        
        int startIndex = (page - 1) * size;
        int endIndex = Math.min(startIndex + size, totalElements);
        
        List<Product> pageProducts = products.subList(startIndex, endIndex);
        
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", page);
        pagination.put("totalPages", totalPages);
        pagination.put("totalElements", totalElements);
        pagination.put("pageSize", size);
        pagination.put("hasNext", page < totalPages);
        pagination.put("hasPrevious", page > 1);
        pagination.put("isFirst", page == 1);
        pagination.put("isLast", page == totalPages);
        
        Map<String, Object> result = new HashMap<>();
        result.put("products", pageProducts);
        result.put("pagination", pagination);
        
        return result;
    }
    
    /**
     * Tạo thông tin filters
     */
    private Map<String, Object> createFiltersInfo(String query, String category, 
                                                 Double minPrice, Double maxPrice, 
                                                 String sort, String order) {
        Map<String, Object> filters = new HashMap<>();
        filters.put("query", query);
        filters.put("category", category);
        filters.put("minPrice", minPrice);
        filters.put("maxPrice", maxPrice);
        filters.put("sort", sort);
        filters.put("order", order);
        
        return filters;
    }
    
    /**
     * Lấy danh sách categories từ sản phẩm
     */
    private List<String> getProductCategories() {
        try {
            List<Product> allProducts = productService.getAllActiveProducts();
            return allProducts.stream()
                    .map(Product::getCategory)
                    .filter(Objects::nonNull)
                    .map(category -> category.toString().replace("_", " "))
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList());
        } catch (Exception e) {
            // Return default categories if can't fetch from products
            return Arrays.asList("GUNDAM BANDAI", "PRE ORDER", "TOOLS ACCESSORIES");
        }
    }
    
    /**
     * Convert Product objects to JSON-friendly format
     */
    private List<Map<String, Object>> convertProductsToJson(List<Product> products) {
        return products.stream().map(product -> {
            Map<String, Object> productJson = new HashMap<>();
            productJson.put("id", product.getId());
            productJson.put("name", product.getName());
            productJson.put("price", product.getPrice());
            productJson.put("description", product.getDescription());
            productJson.put("imageUrl", product.getImageUrl());
            productJson.put("category", product.getCategory() != null ? product.getCategory().toString() : null);
            productJson.put("grade", product.getGrade() != null ? product.getGrade().toString() : null);
            productJson.put("brand", product.getBrand());
            productJson.put("stockQuantity", product.getStockQuantity());
            productJson.put("isActive", product.getIsActive());
            return productJson;
        }).collect(Collectors.toList());
    }
}