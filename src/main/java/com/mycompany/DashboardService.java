package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class DashboardService {
    @Autowired
    private DashboardRepository dashboardRepository;

    public DashboardDTO getDashboardStats() {
        try {
            List<Object[]> stats = dashboardRepository.getOrderStats();
            Object[] orderStats = stats.get(0);
            double revenue = orderStats[0] != null ? ((Number)orderStats[0]).doubleValue() : 0;
            long orderCount = orderStats[1] != null ? ((Number)orderStats[1]).longValue() : 0;

            long newCustomers = dashboardRepository.getNewCustomersThisMonth();
            long totalProducts = dashboardRepository.getTotalProducts();
            long lowStock = dashboardRepository.getLowStockProducts();

            DashboardDTO dto = new DashboardDTO();
            dto.setRevenueThisMonth(revenue);
            dto.setOrderCountThisMonth(orderCount);
            dto.setNewCustomersThisMonth(newCustomers);
            dto.setTotalProducts(totalProducts);
            dto.setLowStockProducts(lowStock);
            return dto;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
} 