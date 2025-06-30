package com.mycompany;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class RevenueRepository {

    @PersistenceContext
    private EntityManager em;

    public List<Object[]> queryBySql(String sql) {
        return em.createNativeQuery(sql).getResultList();
    }
}
