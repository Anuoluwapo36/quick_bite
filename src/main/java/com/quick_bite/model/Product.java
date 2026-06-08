package com.quick_bite.model;

import java.sql.Timestamp;
import java.util.List;

public class Product {

    private int productId;
    private String productName;
    private String productDesc;
    private double productPrice;
    private Timestamp createdAt;
    private int categoryId;
    private String CategoriesName;
    private List<ProductImage> images;

    public Product() {}

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

    public String getProductDesc() {
        return productDesc;
    }

    public void setProductDesc(String productDesc) {
        this.productDesc = productDesc;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    
	public int getCategoryId() {
	
		return categoryId;
	
	}

	
	public void setCategoryId(int categoryId) {
	
		this.categoryId = categoryId;
	
	}
	
	

	
	public String getCategoriesName() {
	
		return CategoriesName;
	
	}

	
	public void setCategoriesName(String CategoriesName) {
	
		this.CategoriesName = CategoriesName;
	
	}

	public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }
}
