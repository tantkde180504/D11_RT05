package com.mycompany.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.mycompany.dto.CategoryDTO;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Types;
import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class CategoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public CategoryDTO updateCategory(CategoryDTO category) {
        String sql = "UPDATE categories SET name=?, description=?, parent_id=?, is_active=? WHERE id=?";
        try {
            jdbcTemplate.update(sql,
                category.getName(),
                category.getDescription(),
                category.getParentId(),
                category.getIsActive(),
                category.getId()
            );
            return category;
        } catch (DataAccessException e) {
            // Xử lý lỗi DB nếu cần
            throw new RuntimeException("Lỗi cập nhật danh mục: " + e.getMessage(), e);
        }
    }

    public CategoryDTO addCategory(CategoryDTO category) {
        String sql = "INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        try {
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, category.getName());
                // Nếu description null thì set ""
                ps.setString(2, category.getDescription() != null ? category.getDescription() : "");
                if (category.getParentId() != null) {
                    ps.setLong(3, category.getParentId());
                } else {
                    ps.setNull(3, Types.BIGINT);
                }
                // Nếu isActive null thì set true
                ps.setBoolean(4, category.getIsActive() != null ? category.getIsActive() : true);
                return ps;
            }, keyHolder);
            Number key = keyHolder.getKey();
            if (key != null) {
                category.setId(key.longValue());
            }
            return category;
        } catch (DataAccessException e) {
            e.printStackTrace(); // Log lỗi chi tiết ra console
            throw new RuntimeException("Lỗi thêm danh mục: " + e.getMessage(), e);
        }
    }

    public List<CategoryDTO> findAll() {
        String sql = "SELECT c.id, c.name, c.description, c.parent_id, c.is_active, c.created_at, " +
                     "(SELECT COUNT(p.id) FROM products p WHERE p.category_id = c.id) as product_count " +
                     "FROM categories c ORDER BY c.id";
        List<CategoryDTO> list = jdbcTemplate.query(sql, (rs, rowNum) -> {
            CategoryDTO dto = mapRowToCategoryDTO(rs);
            dto.setProductCount(rs.getInt("product_count"));
            return dto;
        });
        System.out.println("DEBUG: Số lượng danh mục lấy được = " + list.size());
        return list;
    }

    public void deleteCategory(Long id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    private CategoryDTO mapRowToCategoryDTO(ResultSet rs) throws SQLException {
        CategoryDTO cat = new CategoryDTO();
        cat.setId(rs.getLong("id"));
        cat.setName(rs.getString("name"));
        cat.setDescription(rs.getString("description"));
        long parentId = rs.getLong("parent_id");
        cat.setParentId(rs.wasNull() ? null : parentId);
        boolean isActive = rs.getBoolean("is_active");
        cat.setIsActive(rs.wasNull() ? null : isActive);
        java.sql.Timestamp ts = rs.getTimestamp("created_at");
        cat.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return cat;
    }
}
