package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class ReportsService {

    @Autowired
    private ReportsRepository reportsRepository;

    public Map<String, Object> getRevenueReportByPeriod(String startDate, String endDate, String periodType) {
        return reportsRepository.getRevenueReportByPeriod(startDate, endDate, periodType);
    }

    public Map<String, Object> getTopProductsReport(String startDate, String endDate) {
        return reportsRepository.getTopProductsReport(startDate, endDate);
    }

    public Map<String, Object> getProductCategoryReport(String startDate, String endDate) {
        return reportsRepository.getProductCategoryReport(startDate, endDate);
    }

    // Helper method để validate dates
    public boolean isValidDateRange(String startDate, String endDate) {
        try {
            java.time.LocalDate start = java.time.LocalDate.parse(startDate);
            java.time.LocalDate end = java.time.LocalDate.parse(endDate);
            return !start.isAfter(end);
        } catch (Exception e) {
            return false;
        }
    }

    // Helper method để tính số ngày
    public long getDaysBetween(String startDate, String endDate) {
        try {
            java.time.LocalDate start = java.time.LocalDate.parse(startDate);
            java.time.LocalDate end = java.time.LocalDate.parse(endDate);
            return java.time.temporal.ChronoUnit.DAYS.between(start, end);
        } catch (Exception e) {
            return 0;
        }
    }

    // Auto-suggest period type based on date range
    public String getSuggestedPeriodType(String startDate, String endDate) {
        long days = getDaysBetween(startDate, endDate);
        
        if (days <= 31) {
            return "day";
        } else if (days <= 365) {
            return "month";
        } else {
            return "year";
        }
    }
}