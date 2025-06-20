package com.mycompany.service;

import com.mycompany.model.Product;
import com.mycompany.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public boolean updateStock(Long id, int quantity) {
        if (quantity < 0) {
            throw new IllegalArgumentException("Số lượng không thể âm.");
        }

        Product product = productRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm với ID " + id));
        product.setQuantity(quantity);
        productRepository.save(product);
        return true;
    }
}
