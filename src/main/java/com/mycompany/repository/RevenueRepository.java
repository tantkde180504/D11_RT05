package com.mycompany.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RevenueRepository {

    @PersistenceContext
    private EntityManager em;

    @SuppressWarnings("unchecked")
    public List<Object[]> queryBySql(String sql) {
        return (List<Object[]>) em.createNativeQuery(sql).getResultList();
    }
}
