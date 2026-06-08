

package com.quick_bite.model;

public class WeeklySalesReport {
    private String weekLabel; 
    private int orders;
    private int customers;
    private double revenue;
    private double avgValue;

    public WeeklySalesReport(String weekLabel, int orders, int customers, double revenue, double avgValue) {
        this.weekLabel = weekLabel;
        this.orders = orders;
        this.customers = customers;
        this.revenue = revenue;
        this.avgValue = avgValue;
    }

	
	public String getWeekLabel() {
	
		return weekLabel;
	
	}

	
	public void setWeekLabel(String weekLabel) {
	
		this.weekLabel = weekLabel;
	
	}

	
	public int getOrders() {
	
		return orders;
	
	}

	
	public void setOrders(int orders) {
	
		this.orders = orders;
	
	}

	
	public int getCustomers() {
	
		return customers;
	
	}

	
	public void setCustomers(int customers) {
	
		this.customers = customers;
	
	}

	
	public double getRevenue() {
	
		return revenue;
	
	}

	
	public void setRevenue(double revenue) {
	
		this.revenue = revenue;
	
	}

	
	public double getAvgValue() {
	
		return avgValue;
	
	}

	
	public void setAvgValue(double avgValue) {
	
		this.avgValue = avgValue;
	
	}
    
    

}

