package com.mycompany.controller;

import com.mycompany.dto.ChatMessageDTO;
import com.mycompany.entity.ChatMessage.UserType;
import com.mycompany.model.User;
import com.mycompany.repository.UserRepository;
import com.mycompany.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class ChatController {
    
    @Autowired
    private ChatService chatService;
    
    // WebSocket endpoint để gửi tin nhắn
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessageDTO messageDTO, 
                           SimpMessageHeaderAccessor headerAccessor) {
        try {
            UserType senderType = UserType.valueOf(messageDTO.getSenderType());
            UserType receiverType = UserType.valueOf(messageDTO.getReceiverType());
            
            chatService.sendMessage(
                messageDTO.getSenderId(),
                messageDTO.getReceiverId(), 
                messageDTO.getMessage(),
                senderType,
                receiverType
            );
        } catch (Exception e) {
            // Gửi lỗi về client nếu có
            System.err.println("Lỗi gửi tin nhắn: " + e.getMessage());
        }
    }
    
    // REST API endpoints
    @RestController
    @RequestMapping("/api/chat")
    public static class ChatRestController {
        
        @Autowired
        private ChatService chatService;
        
        @Autowired
        private UserRepository userRepository;
        
        // Lấy lịch sử chat giữa 2 user
        @GetMapping("/messages")
        public List<ChatMessageDTO> getMessages(@RequestParam Long userId1, 
                                               @RequestParam Long userId2) {
            return chatService.getMessagesBetweenUsers(userId1, userId2);
        }
        
        // Gửi tin nhắn qua REST API
        @PostMapping("/send")
        public ChatMessageDTO sendMessage(@RequestBody Map<String, Object> request) {
            Long senderId = Long.valueOf(request.get("senderId").toString());
            Long receiverId = Long.valueOf(request.get("receiverId").toString());
            String message = request.get("message").toString();
            UserType senderType = UserType.valueOf(request.get("senderType").toString());
            UserType receiverType = UserType.valueOf(request.get("receiverType").toString());
            
            return chatService.sendMessage(senderId, receiverId, message, senderType, receiverType);
        }
        
        // Đánh dấu tin nhắn đã đọc
        @PostMapping("/mark-read")
        public void markAsRead(@RequestParam Long receiverId, @RequestParam Long senderId) {
            chatService.markMessagesAsRead(receiverId, senderId);
        }
        
        // Lấy danh sách khách hàng đã chat với staff
        @GetMapping("/customers/{staffId}")
        public List<Long> getCustomersForStaff(@PathVariable Long staffId) {
            return chatService.getCustomersChattedWithStaff(staffId);
        }
        
        // Đếm tin nhắn chưa đọc
        @GetMapping("/unread-count/{userId}")
        public Long getUnreadCount(@PathVariable Long userId) {
            return chatService.countUnreadMessages(userId);
        }
        
        // Đếm tin nhắn chưa đọc từ user cụ thể
        @GetMapping("/unread-count")
        public Long getUnreadCountFromUser(@RequestParam Long receiverId, 
                                         @RequestParam Long senderId) {
            return chatService.countUnreadMessagesFromUser(receiverId, senderId);
        }
        
        // Lấy staff được assign cho customer
        @GetMapping("/assigned-staff/{customerId}")
        public Optional<Long> getAssignedStaff(@PathVariable Long customerId) {
            return chatService.getAssignedStaff(customerId);
        }
        
        // Lấy danh sách tất cả customers cho staff
        @GetMapping("/customers")
        public List<Map<String, Object>> getCustomers() {
            List<com.mycompany.model.User> customers = userRepository.findByRoleOrderByFullNameAsc("CUSTOMER");
            return customers.stream()
                    .map(user -> {
                        Map<String, Object> customerData = new HashMap<>();
                        customerData.put("id", user.getId());
                        customerData.put("fullName", user.getFullName());
                        customerData.put("email", user.getEmail());
                        return customerData;
                    })
                    .collect(Collectors.toList());
        }
        
        // Lấy tất cả tin nhắn của customer (từ/đến bất kỳ staff nào)
        @GetMapping("/customer-messages/{customerId}")
        public List<ChatMessageDTO> getCustomerMessages(@PathVariable Long customerId) {
            return chatService.getAllMessagesForCustomer(customerId);
        }
        
        // API để debug user info
        @GetMapping("/debug/user-info")
        public Map<String, Object> getUserInfo(@RequestParam(required = false) String email) {
            Map<String, Object> result = new HashMap<>();
            
            try {
                if (email != null) {
                    Optional<com.mycompany.model.User> user = userRepository.findByEmail(email);
                    if (user.isPresent()) {
                        result.put("found", true);
                        result.put("id", user.get().getId());
                        result.put("fullName", user.get().getFullName());
                        result.put("email", user.get().getEmail());
                        result.put("role", user.get().getRole());
                    } else {
                        result.put("found", false);
                        result.put("email", email);
                    }
                }
                
                // Lấy tất cả users để debug
                List<com.mycompany.model.User> allUsers = userRepository.findAll();
                result.put("allUsers", allUsers.stream()
                    .map(user -> {
                        Map<String, Object> userData = new HashMap<>();
                        userData.put("id", user.getId());
                        userData.put("fullName", user.getFullName());
                        userData.put("email", user.getEmail());
                        userData.put("role", user.getRole());
                        return userData;
                    })
                    .collect(Collectors.toList()));
                    
                return result;
            } catch (Exception e) {
                result.put("error", e.getMessage());
                return result;
            }
        }
    }
}
