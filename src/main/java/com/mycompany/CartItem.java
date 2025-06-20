package com.mycompany;

public class CartItem {
    private long productId;
    private String productName;
    private String imageUrl;
    private double price;
    private int quantity;

    public CartItem(long productId, String productName, String imageUrl, double price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.price = price;
        this.quantity = quantity;
    }

    public long getProductId() {
        return productId;
    }
    public String getProductName() {
        return productName;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public double getPrice() {
        return price;
    }
    public int getQuantity() {
        return quantity;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public void setPrice(double price) {
        this.price = price;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
