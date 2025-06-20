package com.mycompany.controller;

import com.mycompany.model.Product;
import com.mycompany.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class InventoryController {

    @Autowired
    private ProductService productService;

    @GetMapping("/staff/inventory")
    public String showInventory(Model model) {
        List<Product> products = productService.getAllProducts();

        System.out.println("Tổng sản phẩm: " + products.size());
        products.forEach(p -> System.out.println(" - " + p.getName()));

        model.addAttribute("products", products);
        return "staffsc";
    }

    @PostMapping("/staff/inventory/update")
    public String updateInventory(@RequestParam("id") Long id,
                                  @RequestParam("quantity") int quantity,
                                  RedirectAttributes redirectAttributes) {
        try {
            productService.updateStock(id, quantity);
            redirectAttributes.addFlashAttribute("message", "Cập nhật thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        return "redirect:/staff/inventory#inventory";
    }
}
