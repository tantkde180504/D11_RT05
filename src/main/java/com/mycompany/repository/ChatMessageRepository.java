package com.mycompany.repository;

import com.mycompany.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    
    // Lấy tin nhắn giữa 2 user cụ thể
    @Query("SELECT cm FROM ChatMessage cm WHERE " +
           "(cm.senderId = :userId1 AND cm.receiverId = :userId2) OR " +
           "(cm.senderId = :userId2 AND cm.receiverId = :userId1) " +
           "ORDER BY cm.timestamp ASC")
    List<ChatMessage> findMessagesBetweenUsers(@Param("userId1") Long userId1, 
                                               @Param("userId2") Long userId2);
    
    // Lấy danh sách khách hàng đã chat với nhân viên
    @Query("SELECT DISTINCT cm.senderId FROM ChatMessage cm WHERE " +
           "cm.receiverId = :staffId AND cm.senderType = 'CUSTOMER'")
    List<Long> findCustomersChattedWithStaff(@Param("staffId") Long staffId);
    
    // Lấy nhân viên được assign cho khách hàng (customer chỉ chat với 1 staff)
    @Query("SELECT cm.receiverId FROM ChatMessage cm WHERE " +
           "cm.senderId = :customerId AND cm.senderType = 'CUSTOMER' AND cm.receiverType = 'STAFF' " +
           "ORDER BY cm.timestamp DESC")
    List<Long> findAssignedStaffForCustomerList(@Param("customerId") Long customerId);
    
    // Đếm tin nhắn chưa đọc
    @Query("SELECT COUNT(cm) FROM ChatMessage cm WHERE " +
           "cm.receiverId = :userId AND cm.isRead = false")
    Long countUnreadMessages(@Param("userId") Long userId);
    
    // Đếm tin nhắn chưa đọc từ user cụ thể
    @Query("SELECT COUNT(cm) FROM ChatMessage cm WHERE " +
           "cm.receiverId = :receiverId AND cm.senderId = :senderId AND cm.isRead = false")
    Long countUnreadMessagesFromUser(@Param("receiverId") Long receiverId, 
                                     @Param("senderId") Long senderId);
    
    // Lấy tất cả tin nhắn của customer (từ/đến bất kỳ staff nào)
    @Query("SELECT cm FROM ChatMessage cm WHERE " +
           "(cm.senderId = :customerId AND cm.senderType = 'CUSTOMER') OR " +
           "(cm.receiverId = :customerId AND cm.receiverType = 'CUSTOMER') " +
           "ORDER BY cm.timestamp ASC")
    List<ChatMessage> findAllByCustomerId(@Param("customerId") Long customerId);
}
