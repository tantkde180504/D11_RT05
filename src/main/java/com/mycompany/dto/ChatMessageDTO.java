package com.mycompany.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageDTO {
    private Long id;
    private Long senderId;
    private Long receiverId;
    private String message;
    private LocalDateTime timestamp;
    private Boolean isRead;
    private String senderType;
    private String receiverType;
    private String senderName; // Tên người gửi để hiển thị
    private String receiverName; // Tên người nhận để hiển thị
}
