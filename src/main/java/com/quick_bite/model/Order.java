

package com.quick_bite.model;



import java.sql.Timestamp;
import java.util.List;




public class Order {

	private int orderId;
	private String customerName;
	private String customerPhone;
	private String customerAddress;
	private double totalAmount;
	private String status;
	private Timestamp createdAt;
	private String customerEmail;

	private List<OrderItem> items;
	private Payment paymetinfo;



	public int getOrderId() {

		return orderId;

	}



	public void setOrderId(int orderId) {

		this.orderId = orderId;

	}



	public String getCustomerName() {

		return customerName;

	}



	public void setCustomerName(String customerName) {

		this.customerName = customerName;

	}



	public String getCustomerPhone() {

		return customerPhone;

	}



	public void setCustomerPhone(String customerPhone) {

		this.customerPhone = customerPhone;

	}



	public String getCustomerAddress() {

		return customerAddress;

	}



	public void setCustomerAddress(String customerAddress) {

		this.customerAddress = customerAddress;

	}



	public double getTotalAmount() {

		return totalAmount;

	}



	public void setTotalAmount(double totalAmount) {

		this.totalAmount = totalAmount;

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



	public String getCustomerEmail() {

		return customerEmail;

	}



	public void setCustomerEmail(String customerEmail) {

		this.customerEmail = customerEmail;

	}



	public List<OrderItem> getItems() {

		return items;

	}



	public void setItems(List<OrderItem> items) {

		this.items = items;

	}



	public Payment getPaymetinfo() {

		return paymetinfo;

	}



	public void setPaymetinfo(Payment paymetinfo) {

		this.paymetinfo = paymetinfo;

	}



	public String getItemsSummary() {

		if (items == null || items.isEmpty())
			return "";
		StringBuilder sb = new StringBuilder();

		for (OrderItem item : items) {


			sb.append(item.getQuantity()).append("x ")
					.append(item.getProduct() != null ? item.getProduct().getProductName() : "Unknown").append(", ");

		}

		if (sb.length() > 2)
			sb.setLength(sb.length() - 2);
		return sb.toString();

	}



}
