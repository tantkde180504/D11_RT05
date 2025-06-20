package com.mycompany;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    public boolean confirmOrder(Long orderId) {
        return orderRepository.confirmOrder(orderId) > 0;
    }

    public boolean updateOrderStatus(Long orderId, String status) {
        return orderRepository.updateOrderStatus(orderId, status) > 0;
    }

    public boolean cancelOrder(Long orderId) {
        return orderRepository.cancelOrder(orderId) > 0;
    }

    public boolean cancelOrderByOrderNumber(String orderNumber) {
        return orderRepository.cancelOrderByOrderNumber(orderNumber) > 0;
    }

    public String printInvoice(Long orderId) {
        Map<String, Object> order = orderRepository.getOrderById(orderId);
        if (order == null) return null;
        return "HÓA ĐƠN\nMã đơn: " + order.get("id") + "\nTrạng thái: " + order.get("status");
    }

    public String printInvoiceByOrderNumber(String orderNumber) {
        Map<String, Object> order = orderRepository.getOrderByOrderNumber(orderNumber);
        if (order == null) return null;
        return "HÓA ĐƠN\nMã đơn: " + order.get("order_number") +
               "\nKhách hàng: " + order.get("shipping_name") +
               "\nTổng tiền: " + order.get("total_amount") +
               "\nTrạng thái: " + order.get("status");
    }
}