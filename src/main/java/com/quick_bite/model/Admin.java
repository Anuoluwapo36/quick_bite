package com.quick_bite.model;



import java.sql.Timestamp;

public class Admin {

    private int adminId;
    private String adminName;
    private String adminEmail;
    private String adminUsername;
    private String adminPassword;
    private String status;
    private Timestamp createdAt;
    private String companyName;
    private String companyEmail;
    private String companyPhone;
    private String companyAddress;
    public Admin() {
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public String getAdminUsername() {
        return adminUsername;
    }

    public void setAdminUsername(String adminUsername) {
        this.adminUsername = adminUsername;
    }

    public String getAdminPassword() {
        return adminPassword;
    }

    public void setAdminPassword(String adminPassword) {
        this.adminPassword = adminPassword;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

	
	public String getCompanyName() {
	
		return companyName;
	
	}

	
	public void setCompanyName(String companyName) {
	
		this.companyName = companyName;
	
	}

	
	public String getCompanyEmail() {
	
		return companyEmail;
	
	}

	
	public void setCompanyEmail(String companyEmail) {
	
		this.companyEmail = companyEmail;
	
	}

	
	public String getCompanyPhone() {
	
		return companyPhone;
	
	}

	
	public void setCompanyPhone(String companyPhone) {
	
		this.companyPhone = companyPhone;
	
	}

	
	public String getCompanyAddress() {
	
		return companyAddress;
	
	}

	
	public void setCompanyAddress(String companyAddress) {
	
		this.companyAddress = companyAddress;
	
	}
    
    
}
