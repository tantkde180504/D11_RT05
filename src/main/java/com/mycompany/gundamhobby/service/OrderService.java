package com.mycompany.gundamhobby.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.mycompany.gundamhobby.model.Order;

@Service
public class OrderService {

    // Dữ liệu mẫu
    private final List<Order> list = new ArrayList<>();

    public OrderService() {
        // Khởi tạo dữ liệu mẫu nếu chưa có
        if (list.isEmpty()) {
            Order o1 = new Order();
            o1.setOrderId(1);
            o1.setUserId(1001);
            o1.setStatusId(2);
            o1.setOrderDate(new Date());
            o1.setTotalAmount(500000);

            Order o2 = new Order();
            o2.setOrderId(2);
            o2.setUserId(1002);
            o2.setStatusId(1);
            o2.setOrderDate(new Date());
            o2.setTotalAmount(700000);

            list.add(o1);
            list.add(o2);
        }
    }

    // Trả về toàn bộ đơn hàng
    public List<Order> getAllOrders() {
        return list;
    }

    // Lấy đơn hàng theo ID
    public Order getOrderById(int orderId) {
        for (Order order : list) {
            if (order.getOrderId() == orderId) {
                return order;
            }
        }
        return null;
    }

    // Hủy đơn hàng (chuyển statusId = 3)
    public void cancelOrder(int orderId) {
        Order order = getOrderById(orderId);
        if (order != null && order.getStatusId() != 3) {
            order.setStatusId(3); // 3 = Đã hủy
        }
    }

    // Xử lý đổi trả đơn hàng (chuyển statusId = 4)
    public void returnOrder(int orderId) {
        Order order = getOrderById(orderId);
        if (order != null && order.getStatusId() != 4) {
            order.setStatusId(4); // 4 = Đang xử lý đổi trả
        }
    }

    // Tạo nội dung hóa đơn đơn giản
    public String generateInvoice(int orderId) {
        Order order = getOrderById(orderId);
        if (order == null)
            return "Không tìm thấy đơn hàng.";

        StringBuilder invoice = new StringBuilder();
        invoice.append("===== HÓA ĐƠN MUA HÀNG =====\n");
        invoice.append("Mã đơn: #ORD").append(order.getOrderId()).append("\n");
        invoice.append("Ngày đặt: ").append(order.getOrderDate()).append("\n");
        invoice.append("Tổng tiền: ").append(order.getTotalAmount()).append(" VND\n");
        invoice.append("Tình trạng: ").append(getStatusText(order.getStatusId())).append("\n");
        invoice.append("============================");

        return invoice.toString();
    }

    public String getStatusText(int statusId) {
        switch (statusId) {
            case 1:
                return "Chờ xác nhận";
            case 2:
                return "Đã xác nhận";
            case 3:
                return "Đã hủy";
            case 4:
                return "Đang xử lý đổi trả";
            default:
                return "Không xác định";
        }
    }
}
