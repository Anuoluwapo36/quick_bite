<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.quick_bite.model.Admin"%>
<%@ page import="java.util.List"%>
<%@ page import="com.quick_bite.model.*"%>


<%
Admin admin = (Admin) session.getAttribute("admin");

if (admin == null) {


	response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
	return;

}

int totalOrders = (int) request.getAttribute("totalOrders");
int totalProducts = (int) request.getAttribute("totalProducts");

int pendingOrders = (int) request.getAttribute("pendingOrders");
int deliveryOrders = (int) request.getAttribute("deliveryOrders");
int pickupOrders = (int) request.getAttribute("pickupOrders");
int preparingOrders = (int) request.getAttribute("preparingOrders");
double totalRevenue = (double) request.getAttribute("totalRevenue");
double avgOrderValue = (double) request.getAttribute("avgOrderValue");
List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard - QuitBite Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="dashboard-container">
		<aside class="sidebar">
			<div class="sidebar-header">
				<h2>
					<i class="fas fa-hamburger"></i> <%=admin.getCompanyName() %>
				</h2>
			</div>

			<nav class="sidebar-menu">
			<a href="<%=request.getContextPath()%>/admin/dashboard" class="menu-item "> <i
					class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
				</a> <a href="<%=request.getContextPath()%>/admin/products"
					class="menu-item"> <i class="fas fa-utensils"></i> <span>Products</span>
				</a> <a href="<%=request.getContextPath()%>/admin/addProduct"
					class="menu-item"> <i class="fas fa-plus-circle"></i> <span>Add
						Product</span>
				</a> <a href="<%=request.getContextPath()%>/admin/orders"
					class="menu-item"> <i class="fas fa-shopping-cart"></i> <span>Orders</span>

				</a> <a href="<%=request.getContextPath()%>/admin/dashboard/report"
					class="menu-item"> <i class="fas fa-chart-bar"></i> <span>Reports</span>
				</a> <a href="<%=request.getContextPath()%>/admin/settings"
					class="menu-item"> <i class="fas fa-cog"></i> <span>Settings</span>
				</a> <a href="<%=request.getContextPath()%>/admin/logout"
					class="menu-item"> <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
				</a>

			</nav>
		</aside>

		<!-- Main Content -->
		<main class="main-content">
			<!-- Header -->
			<header class="content-header">
				<h1>Dashboard</h1>
				<div class="user-info">
					<div class="avatar">A</div>
					<span>Welcome, admin <%=admin.getAdminName()%></span>
				</div>
			</header>

			<!-- Stats Cards -->
			<div class="cards-container">
				<div class="card">
					<div class="card-icon orders">
						<i class="fas fa-shopping-cart"></i>
					</div>
					<h3><%=totalOrders%></h3>
					<p>Today's Orders</p>
				</div>
				<div class="card">
					<div class="card-icon products">
						<i class="fas fa-utensils"></i>
					</div>
					<h3><%=totalProducts%></h3>
					<p>Total Products</p>
				</div>

				<div class="card">
					<div class="card-icon revenue">
						<i class="fas fa-dollar-sign"></i>
					</div>
					<h3>
						$<%=totalRevenue%></h3>
					<p>Today's Revenue</p>
				</div>

				
			</div>

			<!-- Recent Orders -->
			<div class="table-container">
				<h3>
					<i class="fas fa-history"></i> Recent Orders
				</h3>
				<table>
					<thead>
						<tr>
							<th>Order ID</th>
							<th>Customer</th>
							<th>Items</th>
							<th>Total</th>
							<th>Status</th>
							<th>Order Date</th>

							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (Order order : recentOrders) {


							String statusText = "Unpaid";
							String color = "red";
							Payment p = order.getPaymetinfo();

							if (p != null) {


								if ("PAID".equalsIgnoreCase(p.getPaymentStatus())) {


							statusText = "Paid";
							color = "green";

								} else if ("FAILED".equalsIgnoreCase(p.getPaymentStatus())) {


							statusText = "Failed";
							color = "red";

								} else if ("PENDING".equalsIgnoreCase(p.getPaymentStatus())) {


							statusText = "Pending";
							color = "orange";

								}

							}
						%>
						<tr>
							<td>#ORD<%=order.getOrderId()%></td>
							<td><%=order.getCustomerName()%></td>
							<td><%=order.getItemsSummary()%></td>
							<%
							double orderTotal = 0.0;
							Payment payment = order.getPaymetinfo();

							if (payment != null && payment.getAmount() > 0) {


								orderTotal = payment.getAmount();

							} else {


								orderTotal = order.getItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();

							}
							%>
							<td>$<%=String.format("%.2f", orderTotal)%></td>

							<td><span style="color:<%=color%>;"><%=statusText%></span></td>
							<td><%=order.getCreatedAt()%></td>
							<td>
								<form action="<%=request.getContextPath()%>/admin/orders/view"
									method="get">
									<input type="hidden" name="orderId"
										value="<%=order.getOrderId()%>">
									<button type="submit" class="btn btn-sm btn-info">View</button>
								</form>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>


				</table>
			</div>


		</main>
	</div>
</body>
</html>