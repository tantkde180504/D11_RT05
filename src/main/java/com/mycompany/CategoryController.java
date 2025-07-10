package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
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
