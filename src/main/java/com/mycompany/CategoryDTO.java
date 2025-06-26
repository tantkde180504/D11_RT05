package com.mycompany;

import com.fasterxml.jackson.annotation.JsonFormat;

public class CategoryDTO {
    private Long id;
    private String name;
    private String description;
    private Long parentId;
    private Boolean isActive;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private java.time.LocalDateTime createdAt;

    public CategoryDTO() {}

    public CategoryDTO(Long id, String name, String description, Long parentId, Boolean isActive, java.time.LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.parentId = parentId;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public java.time.LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.time.LocalDateTime createdAt) { this.createdAt = createdAt; }
}
