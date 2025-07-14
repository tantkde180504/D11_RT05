package com.mycompany.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.mycompany.model.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Kiểm tra email đã tồn tại hay chưa
     */
    boolean existsByEmail(String email);

    /**
     * Tìm user theo email
     */
    Optional<User> findByEmail(String email);

    /**
     * Kiểm tra số điện thoại đã tồn tại hay chưa
     */
    boolean existsByPhone(String phone);

    /**
     * Kiểm tra trùng tên, email
     */
    boolean existsByFirstNameAndLastNameAndEmail(String firstName, String lastName, String email);

    /**
     * Kiểm tra trùng tên, số điện thoại
     */
    boolean existsByFirstNameAndLastNameAndPhone(String firstName, String lastName, String phone);

    /**
     * Lấy danh sách người dùng theo vai trò
     */
    List<User> findByRole(String role);

    /**
     * Tìm kiếm nhân viên theo từ khóa (tên, họ, email)
     */
    List<User> findByRoleAndFirstNameContainingIgnoreCaseOrRoleAndLastNameContainingIgnoreCaseOrRoleAndEmailContainingIgnoreCase(
        String role1, String firstName, String role2, String lastName, String role3, String email);

    /**
     * Custom update method - chỉ update những trường cần thiết, không touch password và role
     */
    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.firstName = :firstName, u.lastName = :lastName, u.email = :email, " +
           "u.phone = :phone, u.dateOfBirth = :dateOfBirth, u.gender = :gender, u.address = :address, " +
           "u.updatedAt = :updatedAt WHERE u.id = :id")
    int updateStaffInfo(@Param("id") Long id,
                        @Param("firstName") String firstName,
                        @Param("lastName") String lastName,
                        @Param("email") String email,
                        @Param("phone") String phone,
                        @Param("dateOfBirth") LocalDate dateOfBirth,
                        @Param("gender") String gender,
                        @Param("address") String address,
                        @Param("updatedAt") LocalDateTime updatedAt);

    /**
     * Tìm tất cả staff cho chat system
     */
    @Query("SELECT u FROM User u WHERE u.role = 'STAFF'")
    List<User> findAllStaffForChat();
    
    /**
     * Tìm tất cả customer cho chat system
     */
    @Query("SELECT u FROM User u WHERE u.role = 'CUSTOMER'")
    List<User> findAllCustomersForChat();
    
    /**
     * Tìm user info theo danh sách IDs (cho chat)
     */
    @Query("SELECT u.id, u.firstName, u.lastName, u.email FROM User u WHERE u.id IN :userIds")
    List<Object[]> findUserInfoByIds(@Param("userIds") List<Long> userIds);
    
    /**
     * Lấy danh sách user theo role, sắp xếp theo firstName và lastName
     */
    @Query("SELECT u FROM User u WHERE u.role = :role ORDER BY u.firstName ASC, u.lastName ASC")
    List<User> findByRoleOrderByFullNameAsc(@Param("role") String role);
}
