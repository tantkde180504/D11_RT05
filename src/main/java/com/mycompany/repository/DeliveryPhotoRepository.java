package com.mycompany.repository;

import com.mycompany.model.DeliveryPhoto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DeliveryPhotoRepository extends JpaRepository<DeliveryPhoto, Long> {
    List<DeliveryPhoto> findByShippingIdOrderByUploadedAtDesc(Long shippingId);
    List<DeliveryPhoto> findByShippingId(Long shippingId);
    void deleteByShippingId(Long shippingId);
}