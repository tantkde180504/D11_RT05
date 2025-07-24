package com.mycompany.service;

import com.mycompany.entity.ChatMessage;
import com.mycompany.entity.ChatMessage.UserType;
import com.mycompany.entity.ChatAssignment;
import com.mycompany.model.User;
import com.mycompany.dto.ChatMessageDTO;
import com.mycompany.repository.ChatMessageRepository;
import com.mycompany.repository.ChatAssignmentRepository;
import com.mycompany.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChatService {
    
    @Autowired
    private ChatMessageRepository chatMessageRepository;
    
    @Autowired
    private ChatAssignmentRepository chatAssignmentRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    
    // Gửi tin nhắn
    public ChatMessageDTO sendMessage(Long senderId, Long receiverId, String message, 
                                     UserType senderType, UserType receiverType) {
        
        // Nếu customer gửi tin nhắn mà không chỉ định receiverId, broadcast cho tất cả staff
        if (senderType == UserType.CUSTOMER && receiverId == null) {
            return broadcastToAllStaff(senderId, message);
        }
        
        // Kiểm tra quy tắc: Customer chỉ được chat với 1 staff (tạm bỏ qua cho giờ)
        /*
        if (senderType == UserType.CUSTOMER) {
            Optional<Long> assignedStaff = chatAssignmentRepository.findStaffByCustomerId(senderId);
            if (assignedStaff.isPresent() && !assignedStaff.get().equals(receiverId)) {
                throw new RuntimeException("Khách hàng chỉ có thể nhắn tin với nhân viên được phân công!");
            }
            // Nếu chưa có assignment, tự động tạo assignment cho customer này
            if (assignedStaff.isEmpty() && receiverType == UserType.STAFF) {
                autoAssignCustomerToStaff(senderId, receiverId);
            }
        }
        */
        
        // Tạo tin nhắn mới
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(senderId);
        chatMessage.setReceiverId(receiverId);
        chatMessage.setMessage(message);
        chatMessage.setSenderType(senderType);
        chatMessage.setReceiverType(receiverType);
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setIsRead(false);
        
        // Lưu vào database
        ChatMessage savedMessage = chatMessageRepository.save(chatMessage);
        
        // Chuyển đổi sang DTO
        ChatMessageDTO messageDTO = convertToDTO(savedMessage);
        
        // Gửi tin nhắn real-time qua WebSocket
        System.out.println("🚀 Sending WebSocket message:");
        System.out.println("   From: " + senderId + " (" + senderType + ")");
        System.out.println("   To: " + receiverId + " (" + receiverType + ")");
        System.out.println("   Message: " + message);
        System.out.println("   Message ID: " + savedMessage.getId());
        
        try {
            messagingTemplate.convertAndSendToUser(
                receiverId.toString(), 
                "/queue/messages", 
                messageDTO
            );
            System.out.println("   ✅ WebSocket message sent to user: " + receiverId);
        } catch (Exception e) {
            System.err.println("   ❌ Failed to send WebSocket message: " + e.getMessage());
        }
        
        return messageDTO;
    }
    
    // Broadcast tin nhắn từ customer cho tất cả staff
    public ChatMessageDTO broadcastToAllStaff(Long customerId, String message) {
        System.out.println("📢 Broadcasting message from customer " + customerId + " to all staff");
        
        // Lấy danh sách tất cả staff
        List<User> staffList = userRepository.findByRole("STAFF");
        
        if (staffList.isEmpty()) {
            throw new RuntimeException("Không có staff nào trong hệ thống!");
        }
        
        // Chọn staff đầu tiên để lưu tin nhắn vào database
        Long firstStaffId = staffList.get(0).getId();
        
        // Tạo tin nhắn mới
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(customerId);
        chatMessage.setReceiverId(firstStaffId); // Lưu với staff đầu tiên
        chatMessage.setMessage(message);
        chatMessage.setSenderType(UserType.CUSTOMER);
        chatMessage.setReceiverType(UserType.STAFF);
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setIsRead(false);
        
        // Lưu vào database
        ChatMessage savedMessage = chatMessageRepository.save(chatMessage);
        ChatMessageDTO messageDTO = convertToDTO(savedMessage);
        
        // Gửi tin nhắn cho tất cả staff qua WebSocket
        for (User staff : staffList) {
            try {
                messagingTemplate.convertAndSendToUser(
                    staff.getId().toString(), 
                    "/queue/messages", 
                    messageDTO
                );
                System.out.println("   📤 Broadcasted to staff: " + staff.getId() + " (" + staff.getFullName() + ")");
            } catch (Exception e) {
                System.err.println("   ❌ Failed to broadcast to staff " + staff.getId() + ": " + e.getMessage());
            }
        }
        
        return messageDTO;
    }
    
    // Lấy tin nhắn giữa 2 user
    public List<ChatMessageDTO> getMessagesBetweenUsers(Long userId1, Long userId2) {
        List<ChatMessage> messages = chatMessageRepository.findMessagesBetweenUsers(userId1, userId2);
        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Đánh dấu tin nhắn đã đọc
    public void markMessagesAsRead(Long receiverId, Long senderId) {
        List<ChatMessage> unreadMessages = chatMessageRepository.findMessagesBetweenUsers(senderId, receiverId)
                .stream()
                .filter(msg -> msg.getReceiverId().equals(receiverId) && !msg.getIsRead())
                .collect(Collectors.toList());
        
        unreadMessages.forEach(msg -> msg.setIsRead(true));
        chatMessageRepository.saveAll(unreadMessages);
    }
    
    // Lấy danh sách khách hàng đã chat với staff (sử dụng assignment table)
    public List<Long> getCustomersChattedWithStaff(Long staffId) {
        return getCustomersAssignedToStaff(staffId);
    }
    
    // Đếm tin nhắn chưa đọc
    public Long countUnreadMessages(Long userId) {
        return chatMessageRepository.countUnreadMessages(userId);
    }
    
    // Đếm tin nhắn chưa đọc từ user cụ thể
    public Long countUnreadMessagesFromUser(Long receiverId, Long senderId) {
        return chatMessageRepository.countUnreadMessagesFromUser(receiverId, senderId);
    }
    
    // Tự động assign customer cho staff
    private void autoAssignCustomerToStaff(Long customerId, Long staffId) {
        ChatAssignment assignment = new ChatAssignment();
        assignment.setCustomerId(customerId);
        assignment.setStaffId(staffId);
        assignment.setIsActive(true);
        chatAssignmentRepository.save(assignment);
    }
    
    // Lấy staff được assign cho customer
    public Optional<Long> getAssignedStaff(Long customerId) {
        return chatAssignmentRepository.findStaffByCustomerId(customerId);
    }
    
    // Lấy danh sách khách hàng được assign cho staff từ bảng assignment
    public List<Long> getCustomersAssignedToStaff(Long staffId) {
        return chatAssignmentRepository.findCustomersByStaffId(staffId);
    }
    
    // Lấy tất cả tin nhắn của customer (từ/đến bất kỳ staff nào)
    public List<ChatMessageDTO> getAllMessagesForCustomer(Long customerId) {
        List<ChatMessage> messages = chatMessageRepository.findAllByCustomerId(customerId);
        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Chuyển đổi Entity sang DTO
    private ChatMessageDTO convertToDTO(ChatMessage message) {
        ChatMessageDTO dto = new ChatMessageDTO();
        dto.setId(message.getId());
        dto.setSenderId(message.getSenderId());
        dto.setReceiverId(message.getReceiverId());
        dto.setMessage(message.getMessage());
        dto.setTimestamp(message.getTimestamp());
        dto.setIsRead(message.getIsRead());
        dto.setSenderType(message.getSenderType().toString());
        dto.setReceiverType(message.getReceiverType().toString());
        
        // Lấy tên người gửi và người nhận
        Optional<User> sender = userRepository.findById(message.getSenderId());
        Optional<User> receiver = userRepository.findById(message.getReceiverId());
        
        dto.setSenderName(sender.map(User::getFullName).orElse("Unknown"));
        dto.setReceiverName(receiver.map(User::getFullName).orElse("Unknown"));
        
        return dto;
    }
}
