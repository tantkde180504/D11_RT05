package com.mycompany.controller;

import com.mycompany.model.Product;
import com.mycompany.service.FavoriteService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/favorites/*")
public class FavoriteController extends HttpServlet {
    
    @Inject
    private FavoriteService favoriteService;
    
    private ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                // Get all favorite products
                List<Product> favoriteProducts = favoriteService.getFavoriteProducts(userId);
                response.getWriter().write(objectMapper.writeValueAsString(favoriteProducts));
                
            } else if (pathInfo.startsWith("/check/")) {
                // Check if a product is in favorites
                String productIdStr = pathInfo.substring(7);
                Long productId = Long.parseLong(productIdStr);
                
                boolean isFavorite = favoriteService.isFavorite(userId, productId);
                
                ObjectNode result = objectMapper.createObjectNode();
                result.put("isFavorite", isFavorite);
                response.getWriter().write(result.toString());
                
            } else if (pathInfo.equals("/count")) {
                // Get favorite count
                long count = favoriteService.getFavoriteCount(userId);
                
                ObjectNode result = objectMapper.createObjectNode();
                result.put("count", count);
                response.getWriter().write(result.toString());
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if (pathInfo != null && pathInfo.startsWith("/toggle/")) {
                // Toggle favorite status
                String productIdStr = pathInfo.substring(8);
                Long productId = Long.parseLong(productIdStr);
                
                boolean isNowFavorite = favoriteService.toggleFavorite(userId, productId);
                
                ObjectNode result = objectMapper.createObjectNode();
                result.put("success", true);
                result.put("isFavorite", isNowFavorite);
                result.put("message", isNowFavorite ? "Đã thêm vào danh sách yêu thích" : "Đã xóa khỏi danh sách yêu thích");
                response.getWriter().write(result.toString());
                
            } else if (pathInfo != null && pathInfo.startsWith("/add/")) {
                // Add to favorites
                String productIdStr = pathInfo.substring(5);
                Long productId = Long.parseLong(productIdStr);
                
                boolean success = favoriteService.addToFavorites(userId, productId);
                
                ObjectNode result = objectMapper.createObjectNode();
                result.put("success", success);
                result.put("message", success ? "Đã thêm vào danh sách yêu thích" : "Sản phẩm đã có trong danh sách yêu thích");
                response.getWriter().write(result.toString());
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ObjectNode result = objectMapper.createObjectNode();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra");
            response.getWriter().write(result.toString());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("isLoggedIn") == null || 
            !(Boolean) session.getAttribute("isLoggedIn")) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            if (pathInfo != null && pathInfo.startsWith("/remove/")) {
                // Remove from favorites
                String productIdStr = pathInfo.substring(8);
                Long productId = Long.parseLong(productIdStr);
                
                boolean success = favoriteService.removeFromFavorites(userId, productId);
                
                ObjectNode result = objectMapper.createObjectNode();
                result.put("success", success);
                result.put("message", success ? "Đã xóa khỏi danh sách yêu thích" : "Có lỗi xảy ra");
                response.getWriter().write(result.toString());
                
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ObjectNode result = objectMapper.createObjectNode();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra");
            response.getWriter().write(result.toString());
        }
    }
}
