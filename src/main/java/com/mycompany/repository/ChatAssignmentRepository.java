package com.mycompany.repository;

import com.mycompany.entity.ChatAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ChatAssignmentRepository extends JpaRepository<ChatAssignment, Long> {
    
    // Tìm staff được assign cho customer
    @Query("SELECT ca.staffId FROM ChatAssignment ca WHERE ca.customerId = :customerId AND ca.isActive = true")
    Optional<Long> findStaffByCustomerId(@Param("customerId") Long customerId);
    
    // Tìm tất cả customer được assign cho staff
    @Query("SELECT ca.customerId FROM ChatAssignment ca WHERE ca.staffId = :staffId AND ca.isActive = true")
    List<Long> findCustomersByStaffId(@Param("staffId") Long staffId);
    
    // Kiểm tra customer đã được assign chưa
    boolean existsByCustomerIdAndIsActiveTrue(Long customerId);
    
    // Tìm assignment active theo customer
    Optional<ChatAssignment> findByCustomerIdAndIsActiveTrue(Long customerId);
    
    // Đếm số customer được assign cho staff
    @Query("SELECT COUNT(ca) FROM ChatAssignment ca WHERE ca.staffId = :staffId AND ca.isActive = true")
    Long countActiveCustomersByStaff(@Param("staffId") Long staffId);
}
