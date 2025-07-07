package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/reports")
@CrossOrigin(origins = "*")
public class ReportsController {

    @Autowired
    private ReportsService reportsService;

    @GetMapping("/revenue")
    public ResponseEntity<?> getRevenueReport(
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(defaultValue = "day") String periodType) {
        try {
            Map<String, Object> reportData = reportsService.getRevenueReportByPeriod(startDate, endDate, periodType);
            return ResponseEntity.ok(reportData);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error generating revenue report: " + e.getMessage()));
        }
    }

    @GetMapping("/top-products")
    public ResponseEntity<?> getTopProductsReport(
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            Map<String, Object> reportData = reportsService.getTopProductsReport(startDate, endDate);
            return ResponseEntity.ok(reportData);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error generating top products report: " + e.getMessage()));
        }
    }

    @GetMapping("/category")
    public ResponseEntity<?> getProductCategoryReport(
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            Map<String, Object> reportData = reportsService.getProductCategoryReport(startDate, endDate);
            return ResponseEntity.ok(reportData);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error generating category report: " + e.getMessage()));
        }
    }

    // Endpoint tổng hợp - chỉ 3 báo cáo
    @GetMapping("/all")
    public ResponseEntity<?> getAllReports(
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(defaultValue = "day") String periodType) {
        try {
            Map<String, Object> allReports = Map.of(
                "revenue", reportsService.getRevenueReportByPeriod(startDate, endDate, periodType),
                "topProducts", reportsService.getTopProductsReport(startDate, endDate),
                "category", reportsService.getProductCategoryReport(startDate, endDate)
            );
            return ResponseEntity.ok(allReports);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error generating reports: " + e.getMessage()));
        }
    }

    // Export endpoints
    @GetMapping("/export/excel")
    public ResponseEntity<?> exportToExcel(
            @RequestParam String reportType,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(defaultValue = "day") String periodType) {
        try {
            // Get report data
            Map<String, Object> reportData = getReportData(reportType, startDate, endDate, periodType);
            
            // For now, return JSON data that can be converted to Excel on frontend
            Map<String, Object> response = Map.of(
                "success", true,
                "data", reportData,
                "filename", generateFilename(reportType, startDate, endDate),
                "message", "Dữ liệu báo cáo sẵn sàng xuất Excel"
            );
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error exporting to Excel: " + e.getMessage()));
        }
    }

    @GetMapping("/export/pdf")
    public ResponseEntity<?> exportToPDF(
            @RequestParam String reportType,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam(defaultValue = "day") String periodType) {
        try {
            // Get report data
            Map<String, Object> reportData = getReportData(reportType, startDate, endDate, periodType);
            
            // For now, return JSON data that can be converted to PDF on frontend
            Map<String, Object> response = Map.of(
                "success", true,
                "data", reportData,
                "filename", generateFilename(reportType, startDate, endDate),
                "message", "Dữ liệu báo cáo sẵn sàng xuất PDF"
            );
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error exporting to PDF: " + e.getMessage()));
        }
    }

    private Map<String, Object> getReportData(String reportType, String startDate, String endDate, String periodType) {
        switch (reportType) {
            case "revenue":
                return reportsService.getRevenueReportByPeriod(startDate, endDate, periodType);
            case "top-products":
                return reportsService.getTopProductsReport(startDate, endDate);
            case "category":
                return reportsService.getProductCategoryReport(startDate, endDate);
            default:
                throw new IllegalArgumentException("Invalid report type: " + reportType);
        }
    }

    private String generateFilename(String reportType, String startDate, String endDate) {
        String reportName;
        switch (reportType) {
            case "revenue":
                reportName = "BaoCaoDoanhThu";
                break;
            case "top-products":
                reportName = "BaoCaoSanPhamBanChay";
                break;
            case "category":
                reportName = "BaoCaoDanhMuc";
                break;
            default:
                reportName = "BaoCao";
                break;
        }
        
        return String.format("%s_%s_%s", reportName, startDate.replace("-", ""), endDate.replace("-", ""));
    }
}