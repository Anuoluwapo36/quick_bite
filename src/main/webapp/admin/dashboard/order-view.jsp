<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.quick_bite.model.*"%>
<%@ page import="java.util.List"%>

<%
Order order = (Order) request.getAttribute("order");

if (order == null) {


	response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
	return;

}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Order Details - QuitBite</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
</head>
<body>

	<div class="order-container">
		<h2>
			Order #ORD<%=order.getOrderId()%></h2>

		<p>
			<strong>Customer:</strong>
			<%=order.getCustomerName()%></p>

		<p>
			<strong>Status:</strong>
			<%=order.getPaymetinfo() != null ? order.getPaymetinfo().getPaymentStatus() : "Unpaid"%>
		</p>

		<p>
			<strong>Order Date:</strong>
			<%=order.getCreatedAt()%></p>

		<h3>Items</h3>
		<table>
			<thead>
				<tr>
					<th>Item</th>
					<th>Qty</th>
					<th>Price</th>
				</tr>
			</thead>
			<tbody>
				<%
				List<OrderItem> items = order.getItems();

				if (items != null) {


					for (OrderItem item : items) {
				%>
				<tr>
					<td><%=item.getProduct() != null ? item.getProduct().getProductName() : item.getProductName()%></td>
					<td><%=item.getQuantity()%></td>
					<td>$<%=String.format("%.2f", item.getPrice())%></td>
				</tr>
				<%
				}

				}
				%>
			</tbody>
		</table>

		<p>
			<strong>Total:</strong> $<%=String.format("%.2f", order.getPaymetinfo().getAmount())%>
		</p>

		<a href="<%=request.getContextPath()%>/admin/dashboard"
			class="btn btn-primary">Back to Dashboard</a>
	</div>

</body>
</html>
