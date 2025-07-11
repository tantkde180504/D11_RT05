package com.mycompany.controller;

import org.springframework.web.bind.annotation.*;

import com.mycompany.dto.CategoryDTO;
import com.mycompany.repository.CategoryRepository;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@RestController
@RequestMapping(value = "/api/categories", produces = "application/json")
public class CategoryController {

    @Autowired
    private CategoryRepository categoryRepository;

    @PutMapping("/update")
    public CategoryDTO updateCategory(@RequestBody CategoryDTO category) {
        return categoryRepository.updateCategory(category);
    }

    @PostMapping("/add")
    public CategoryDTO addCategory(@RequestBody CategoryDTO category) {
        return categoryRepository.addCategory(category);
    }

    @GetMapping("")
    public List<CategoryDTO> getAllCategories() {
        return categoryRepository.findAll();
    }

    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable Long id) {
        categoryRepository.deleteCategory(id);
    }
}
