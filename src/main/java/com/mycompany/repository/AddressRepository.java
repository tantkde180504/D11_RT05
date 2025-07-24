package com.mycompany.repository;

import com.mycompany.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AddressRepository extends JpaRepository<Address, Integer> {
    
    /**
     * Tìm tất cả địa chỉ của user theo email
     */
    List<Address> findByUserEmailOrderByCreatedAtDesc(String userEmail);
    
    /**
     * Đếm số lượng địa chỉ của user theo email
     */
    long countByUserEmail(String userEmail);
    
    /**
     * Tìm địa chỉ theo ID và email user (để đảm bảo phân quyền)
     */
    Optional<Address> findByIdAndUserEmail(Integer id, String userEmail);
    
    /**
     * Tìm địa chỉ mặc định của user
     */
    Optional<Address> findByUserEmailAndIsDefaultTrue(String userEmail);
    
    /**
     * Đặt tất cả địa chỉ của user thành không mặc định
     */
    @Modifying
    @Query("UPDATE Address a SET a.isDefault = false WHERE a.userEmail = :userEmail")
    void updateAllToNotDefault(@Param("userEmail") String userEmail);
    
    /**
     * Xóa địa chỉ theo ID và email user
     */
    void deleteByIdAndUserEmail(Integer id, String userEmail);
    
    /**
     * Kiểm tra địa chỉ có tồn tại theo ID và email user
     */
    boolean existsByIdAndUserEmail(Integer id, String userEmail);
}
