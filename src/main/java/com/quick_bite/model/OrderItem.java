package com.quick_bite.model;

public class OrderItem {

    private int itemId;
    private int orderId;
    private int productId;
    private String productName; 
    private int quantity;
    private double price;
    private Product product;

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

	
	public Product getProduct() {
	
		return product;
	
	}

	
	public void setProduct(Product product) {
	
		this.product = product;
	
	}
    
    
}
