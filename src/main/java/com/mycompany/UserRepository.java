package com.mycompany;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Kiểm tra email đã tồn tại hay chưa
     */
    boolean existsByEmail(String email);

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
}
