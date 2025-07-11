package com.mycompany.model;

public class BestsellerProduct {
    private String name;
    private int totalSold;

    public BestsellerProduct(String name, int totalSold) {
        this.name = name;
        this.totalSold = totalSold;
    }

    public String getName() {
        return name;
    }

    public int getTotalSold() {
        return totalSold;
    }
}
