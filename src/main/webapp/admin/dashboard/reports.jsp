<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.quick_bite.model.Admin"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="java.util.*"%>
<%@ page import="com.quick_bite.model.*"%>
<%@ page import="com.quick_bite.dao.ReportDAO"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<%
Admin admin = (Admin) session.getAttribute("admin");

if (admin == null) {

	response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
	return;

}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reports - QuitBite Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
	<div class="dashboard-container">
		<!-- Sidebar -->
		<aside class="sidebar">
			<div class="sidebar-header">
				<h2>
					<i class="fas fa-hamburger"></i> <%=admin.getCompanyName() %>
				</h2>
			</div>
						<nav class="sidebar-menu">
					<a href="<%=request.getContextPath()%>/admin/dashboard"
					class="menu-item "> <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
				</a> <a href="<%=request.getContextPath()%>/admin/products"
					class="menu-item"> <i class="fas fa-utensils"></i> <span>Products</span>
				</a> <a href="<%=request.getContextPath()%>/admin/addProduct"
					class="menu-item"> <i class="fas fa-plus-circle"></i> <span>Add
						Product</span>
				</a> <a href="<%=request.getContextPath()%>/admin/orders"
					class="menu-item"> <i class="fas fa-shopping-cart"></i> <span>Orders</span>
					
				</a> <a href="<%=request.getContextPath()%>/admin/dashboard/report"
					class="menu-item active"> <i class="fas fa-chart-bar"></i> <span>Reports</span>
				</a> <a href="<%=request.getContextPath()%>/admin/settings"
					class="menu-item"> <i class="fas fa-cog"></i> <span>Settings</span>
				</a> <a href="<%=request.getContextPath()%>/admin/logout"
					class="menu-item"> <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
				</a>

			</nav>
		</aside>

		<main class="main-content">
			<header class="content-header">
				<h1>
					<i class="fas fa-chart-bar"></i> Reports & Analytics
				</h1>
	
			</header>

			<!-- Summary Cards -->
			<div class="cards-container">
				<div class="card">
					<div style="color: var(--primary); font-size: 24px;">
						<i class="fas fa-dollar-sign"></i>
					</div>
					<h3>
						$<%=String.format("%.2f", request.getAttribute("totalRevenue"))%></h3>
					<p>Total Revenue</p>
					
				</div>

				<div class="card">
					<div style="color: var(--info); font-size: 24px;">
						<i class="fas fa-shopping-cart"></i>
					</div>

					<h3><%=request.getAttribute("totalOrders")%></h3>
					<p>Total Orders</p>
				</div>

				<div class="card">
					<div style="color: var(--warning); font-size: 24px;">
						<i class="fas fa-user"></i>
					</div>
					<h3><%=request.getAttribute("newCustomers")%></h3>
					<p>New Customers</p>
					
				</div>

				<div class="card">
					<div style="color: var(--danger); font-size: 24px;">
						<i class="fas fa-percentage"></i>
					</div>
					<h3><%=String.format("%.2f", request.getAttribute("cancellationRate"))%>%
					</h3>
					<p>Cancelation Rate</p>
					
				</div>
			</div>

			<div
				style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 30px;">
				<!-- Sales Chart -->
				<div class="table-container">
					<h3>
						<i class="fas fa-chart-line"></i> Sales Overview
					</h3>
					<div style="height: 300px;">
						<canvas id="salesChart"></canvas>
					</div>
				</div>

				<!-- Top Products -->
				<div class="table-container">
					<h3>
						<i class="fas fa-star"></i> Top Products
					</h3>
					<table>
						<thead>
							<tr>
								<th>Product</th>
								<th>Sales</th>
								<th>Revenue</th>
							</tr>
						</thead>
						<tbody>
							<%
							List<TopProduct> topProducts = (List<TopProduct>) request.getAttribute("topProducts");

							if (topProducts != null && !topProducts.isEmpty()) {
								for (TopProduct p : topProducts) {
							%>
							<tr>
								<td><%=p.getProductName()%></td>
								<td><%=p.getTotalSold()%></td>
								<td>$<%=String.format("%.2f", p.getRevenue())%></td>
							</tr>
							<%
							}
							} else {
							%>
							<tr>
								<td colspan="3">No data available</td>
							</tr>
							<%
							}
							%>
						</tbody>

					</table>
				</div>
			</div>

			<!-- Detailed Weekly Sales Report -->
			<div class="table-container" style="margin-bottom: 20px;">
				<h3>
					<i class="fas fa-list-alt"></i> Weekly Sales Report
				</h3>
				<table>
					<thead>
						<tr>
							<th>Week</th>
							<th>Orders</th>
							<th>Customers</th>
							<th>Revenue</th>
							<th>Avg. Order Value</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<WeeklySalesReport> weeklyReport = ReportDAO.getWeeklySalesReport();
						if (weeklyReport != null && !weeklyReport.isEmpty()) {
							for (WeeklySalesReport w : weeklyReport) {
						%>
						<tr>
							<td><%=w.getWeekLabel()%></td>
							<td><%=w.getOrders()%></td>
							<td><%=w.getCustomers()%></td>
							<td>$<%=String.format("%.2f", w.getRevenue())%></td>
							<td>$<%=String.format("%.2f", w.getAvgValue())%></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="5" style="text-align: center; color: var(--danger);">
								No sales data available</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>


			<div
				style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
		

				<div class="table-container">
					<h3>
						<i class="fas fa-clock"></i> Peak Hours
					</h3>
					<table>
						<thead>
							<tr>
								<th>Time Slot</th>
								<th>Orders</th>
								<th>Percentage</th>
							</tr>
						</thead>
						<%
						Map<String, Integer> peakHours = ReportDAO.getPeakHours();
						int totalOrders = peakHours.values().stream().mapToInt(Integer::intValue).sum();
						%>
						<tbody>
							<%
							for (Map.Entry<String, Integer> entry : peakHours.entrySet()) {
								String timeSlot = entry.getKey();
								int count = entry.getValue();
								double percentage = totalOrders > 0 ? (count * 100.0 / totalOrders) : 0;
							%>
							<tr>
								<td><%=timeSlot%></td>
								<td><%=count%></td>
								<td><%=String.format("%.1f%%", percentage)%></td>
							</tr>
							<%
							}
							%>
						</tbody>

					</table>
				</div>
			</div>
		</main>
	</div>

	<script>
		// Sales Chart
		const revenueData =
	<%=new Gson().toJson(request.getAttribute("revenuePerDay"))%>
		;
		const labels = Object.keys(revenueData);
		const data = Object.values(revenueData);

		new Chart(document.getElementById('salesChart').getContext('2d'), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					label : 'Revenue',
					data : data,
					borderColor : 'var(--primary)',
					backgroundColor : 'rgba(255,107,53,0.1)',
					fill : true,
					tension : 0.4
				} ]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false
			}
		});

	
	</script>
</body>
</html>