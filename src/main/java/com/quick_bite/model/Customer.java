package com.quick_bite.model;

import java.sql.Timestamp;

public class Customer {
    private int customerId;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String password;

    private Timestamp createdAt;
    private boolean isDeleted;

	
	public int getCustomerId() {
	
		return customerId;
	
	}

	
	public void setCustomerId(int customerId) {
	
		this.customerId = customerId;
	
	}

	
	public String getFullName() {
	
		return fullName;
	
	}

	
	public void setFullName(String fullName) {
	
		this.fullName = fullName;
	
	}

	
	public String getEmail() {
	
		return email;
	
	}

	
	public void setEmail(String email) {
	
		this.email = email;
	
	}

	
	public String getPhone() {
	
		return phone;
	
	}

	
	public void setPhone(String phone) {
	
		this.phone = phone;
	
	}

	
	public String getAddress() {
	
		return address;
	
	}

	
	public void setAddress(String address) {
	
		this.address = address;
	
	}

	
	public String getPassword() {
	
		return password;
	
	}

	
	public void setPassword(String password) {
	
		this.password = password;
	
	}

	
	public Timestamp getCreatedAt() {
	
		return createdAt;
	
	}

	
	public void setCreatedAt(Timestamp createdAt) {
	
		this.createdAt = createdAt;
	
	}


	
	public boolean isDeleted() {
	
		return isDeleted;
	
	}


	
	public void setDeleted(boolean isDeleted) {
	
		this.isDeleted = isDeleted;
	
	}


}
