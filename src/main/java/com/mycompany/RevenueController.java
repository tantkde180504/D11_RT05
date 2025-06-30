package com.mycompany;

import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class RevenueController {

    private final RevenueRepository repo;

    public RevenueController(RevenueRepository repo) {
        this.repo = repo;
    }

    // 1. Doanh thu theo ngày/tháng/quý/năm
    @GetMapping("/revenue")
    public List<Revenue> getRevenue(@RequestParam(defaultValue = "monthly") String type) {
        String sql;
        switch (type.toLowerCase()) {
            case "daily":
                sql = "SELECT CAST([day] AS VARCHAR), total_orders, total_revenue FROM vw_revenue_by_day ORDER BY [day]";
                break;
            case "monthly":
                sql = "SELECT [month], total_orders, total_revenue FROM vw_revenue_by_month ORDER BY [month]";
                break;
            case "quarterly":
                sql = "SELECT quarter, total_orders, total_revenue FROM vw_revenue_by_quarter ORDER BY quarter";
                break;
            case "yearly":
                sql = "SELECT CAST([year] AS VARCHAR), total_orders, total_revenue FROM vw_revenue_by_year ORDER BY [year]";
                break;
            default:
                throw new IllegalArgumentException("Loại báo cáo không hợp lệ: " + type);
        }

        List<Object[]> rows = repo.queryBySql(sql);
        List<Revenue> result = new ArrayList<>();
        for (Object[] row : rows) {
            result.add(new Revenue(
                    (String) row[0],
                    ((Number) row[1]).intValue(),
                    row[2] != null ? (BigDecimal) row[2] : BigDecimal.ZERO));
        }
        return result;
    }

    // 2. Thống kê số đơn hàng theo trạng thái
    @GetMapping("/orders")
    public List<OrderStats> getOrderStats() {
        String sql = "SELECT status, COUNT(*) AS total FROM orders GROUP BY status";
        List<Object[]> rows = repo.queryBySql(sql);
        List<OrderStats> result = new ArrayList<>();
        for (Object[] row : rows) {
            result.add(new OrderStats((String) row[0], ((Number) row[1]).intValue()));
        }
        return result;
    }

    // 3. Sản phẩm bán chạy
    @GetMapping("/bestsellers")
    public List<BestsellerProduct> getBestSellers() {
        String sql = "SELECT p.name, SUM(oi.quantity) AS total_sold " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id " +
                "GROUP BY p.name " +
                "ORDER BY total_sold DESC";

        List<Object[]> rows = repo.queryBySql(sql);
        List<BestsellerProduct> result = new ArrayList<>();
        for (Object[] row : rows) {
            result.add(new BestsellerProduct((String) row[0], ((Number) row[1]).intValue()));
        }
        return result;
    }

}
