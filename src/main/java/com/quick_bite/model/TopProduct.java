package com.quick_bite.model;

public class TopProduct {

    private String productName;
    private int totalSold;
    private double revenue;

    public TopProduct(String productName, int totalSold, double revenue) {
        this.productName = productName;
        this.totalSold = totalSold;
        this.revenue = revenue;
    }

    public String getProductName() {
        return productName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public double getRevenue() {
        return revenue;
    }
}
