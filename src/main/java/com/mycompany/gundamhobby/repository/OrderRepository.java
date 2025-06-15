package com.mycompany.gundamhobby.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mycompany.gundamhobby.model.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
}
