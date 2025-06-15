package com.mycompany.gundamhobby.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.mycompany.gundamhobby.model.Order;
import com.mycompany.gundamhobby.service.OrderService;

@Controller
public class OrderController {

    @Autowired
    private OrderService service;

    // ✅ Hiển thị danh sách đơn hàng
    @GetMapping("/staff/orders")
    public String showOrders(Model model) {
        List<Order> orders = service.getAllOrders();
        model.addAttribute("orders", orders);
        return "staffsc"; // staffsc.jsp
    }

    // ✅ Xem chi tiết hóa đơn
    @GetMapping("/staff/invoice/{orderId}")
    public String printInvoice(@PathVariable int orderId, Model model) {
        Order order = service.getOrderById(orderId);
        model.addAttribute("order", order);
        return "invoice"; // invoice.jsp
    }

    // ✅ Hủy đơn hàng
    @PostMapping("/staff/orders/cancel/{orderId}")
    public String cancelOrder(@PathVariable int orderId) {
        service.cancelOrder(orderId);
        return "redirect:/staff/orders";
    }

    // ✅ Xử lý đổi trả đơn hàng
    @PostMapping("/staff/orders/return/{orderId}")
    public String returnOrder(@PathVariable int orderId) {
        service.returnOrder(orderId);
        return "redirect:/staff/orders";
    }
}
