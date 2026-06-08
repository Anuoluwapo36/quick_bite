<%@ page import="com.quick_bite.model.Order"%>
<%@ page import="com.quick_bite.model.OrderItem"%>
<%@ page import="com.quick_bite.model.Payment"%>


<%
Order order = (Order) request.getAttribute("order");

if (order == null) {
%>
<p style="text-align: center; padding: 20px;">Order not found.</p>
<%
return;

}
%>
<%
Payment payment = order.getPaymetinfo();
String paymentMethod = (payment != null) ? payment.getPaymentMethod() : "Not Paid Yet";
String paymentStatus = (payment != null) ? payment.getPaymentStatus() : "Pending";
%>
<div
	style="background: #f8f9fa; padding: 20px; border-radius: 5px; margin-bottom: 20px;">
	<h3>
		Order #<%=order.getOrderId()%></h3>
	<p>
		<strong>Status:</strong> <span id="orderStatus"><%=order.getStatus()%></span>
	</p>
	<p>
		<strong>Order Date:</strong>
		<%=order.getCreatedAt()%></p>
	

	<p>
		<strong>Payment Method:</strong>
		<%=paymentMethod%></p>
	<p>
		<strong>Payment Status:</strong>
		<%=paymentStatus%></p>

</div>

<div
	style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
	<div>
		<h4>
			<i class="fas fa-user"></i> Customer Information
		</h4>
		<p>
			<strong>Name:</strong>
			<%=order.getCustomerName()%></p>
		<p>
			<strong>Email:</strong>
			<%=order.getCustomerEmail()%></p>
		<p>
			<strong>Phone:</strong>
			<%=order.getCustomerPhone() != null ? order.getCustomerPhone() : "-"%></p>
		<p>
			<strong>Address:</strong>
			<%=order.getCustomerAddress() != null ? order.getCustomerAddress() : "-"%></p>
	</div>

	<div>
		<h4>
			<i class="fas fa-info-circle"></i> Order Information
		</h4>
		<p>
			<strong>Estimated Delivery:</strong> 30 minutes
		</p>
	
	</div>
</div>

<div style="margin-bottom: 20px;">
	<h4>
		<i class="fas fa-shopping-cart"></i> Order Items
	</h4>
	<table style="width: 100%; border-collapse: collapse;">
		<thead>
			<tr style="background: #f8f9fa;">
				<th style="padding: 8px; text-align: left;">Item</th>
				<th style="padding: 8px; text-align: center;">Quantity</th>
				<th style="padding: 8px; text-align: right;">Price</th>
				<th style="padding: 8px; text-align: right;">Total</th>
			</tr>
		</thead>
		<tbody>
			<%
			double subtotal = 0;

			for (OrderItem item : order.getItems()) {


				double total = item.getPrice() * item.getQuantity();
				subtotal += total;
			%>
			<tr>
				<td style="padding: 8px;"><%=item.getProduct().getProductName()%></td>
				<td style="padding: 8px; text-align: center;"><%=item.getQuantity()%></td>
				<td style="padding: 8px; text-align: right;">$<%=String.format("%.2f", item.getPrice())%></td>
				<td style="padding: 8px; text-align: right;">$<%=String.format("%.2f", total)%></td>
			</tr>
			<%
			}

			double deliveryFee = 2.50;
			double tax = subtotal * 0.08;
			double totalAmount = subtotal + deliveryFee + tax;
			%>
			<tr style="border-top: 2px solid #ddd;">
				<td colspan="3" style="text-align: right;"><strong>Subtotal:</strong></td>
				<td style="text-align: right;">$<%=String.format("%.2f", subtotal)%></td>
			</tr>
			<tr>
				<td colspan="3" style="text-align: right;"><strong>Delivery
						Fee:</strong></td>
				<td style="text-align: right;">$<%=String.format("%.2f", deliveryFee)%></td>
			</tr>
			<tr>
				<td colspan="3" style="text-align: right;"><strong>Tax
						(8%):</strong></td>
				<td style="text-align: right;">$<%=String.format("%.2f", tax)%></td>
			</tr>
			<tr style="background: #f8f9fa;">
				<td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
				<td style="text-align: right; color: green;"><strong>$<%=String.format("%.2f", totalAmount)%></strong></td>
			</tr>
		</tbody>
	</table>
</div>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
