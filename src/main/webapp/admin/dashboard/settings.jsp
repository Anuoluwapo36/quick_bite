<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.quick_bite.model.Admin"%>

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
<title>Settings - QuitBite Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
				</a><a href="<%=request.getContextPath()%>/admin/products"
					class="menu-item"> <i class="fas fa-utensils"></i> <span>Products</span>
				</a> <a href="<%=request.getContextPath()%>/admin/addProduct"
					class="menu-item"> <i class="fas fa-plus-circle"></i> <span>Add
						Product</span>
				</a> <a href="<%=request.getContextPath()%>/admin/orders"
					class="menu-item"> <i class="fas fa-shopping-cart"></i> <span>Orders</span>

				</a> <a href="<%=request.getContextPath()%>/admin/dashboard/report"
					class="menu-item"> <i class="fas fa-chart-bar"></i> <span>Reports</span>
				</a> <a href="<%=request.getContextPath()%>/admin/settings"
					class="menu-item active"> <i class="fas fa-cog"></i> <span>Settings</span>
				</a> <a href="<%=request.getContextPath()%>/admin/logout"
					class="menu-item"> <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
				</a>

			</nav>
		</aside>

		<main class="main-content">
			<header class="content-header">
				<h1>
					<i class="fas fa-cog"></i> Settings
				</h1>
				<div class="user-info">
					<div class="avatar">A</div>
					<span>Admin Settings</span>
				</div>
			</header>

			<!-- Settings Tabs -->
			<div
				style="background: white; border-radius: 10px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);">
				<!-- Tab Navigation -->
				<div style="display: flex; border-bottom: 1px solid #eee;">
					<button class="tab-btn active" onclick="openTab(event, 'general')">General</button>
					<button class="tab-btn" onclick="openTab(event, 'password')">Password</button>
					<button class="tab-btn" onclick="openTab(event, 'company')">Company
						Info</button>
				</div>

				<div style="padding: 30px;">
					<div id="general" class="tab-content active">
						<h3 style="margin-bottom: 25px; color: var(--secondary);">
							<i class="fas fa-sliders-h"></i> General Settings
						</h3>
						<%
						String error = (String) request.getAttribute("error");
						String message = (String) request.getAttribute("message");
						%>

						<%
						if (error != null) {
						%>
						<div
							style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 20px;">
							<i class="fas fa-exclamation-circle"></i>
							<%=error%>
						</div>
						<%
						}
						%>

						<%
						if (message != null) {
						%>
						<div
							style="background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 20px;">
							<i class="fas fa-check-circle"></i>
							<%=message%>
						</div>
						<%
						}
						%>

						<div class="form-container">
							<form action="<%=request.getContextPath()%>/admin/settings"
								method="post">
								<input type="hidden" name="formType" value="general">

								<div class="form-row">
									<div class="form-group">
										<label for="adminName">Admin Name</label> <input type="text"
											id="adminName" class="form-control" name="adminName"
											placeholder="chnage admin name"
											value="<%=admin != null ? admin.getAdminName() : ""%>">
									</div>
									<div class="form-group">
										<label for="adminEmail">Email Address</label> <input
											type="email" id="adminEmail" class="form-control"
											name="adminEmail" placeholder="admin email"
											value="<%=admin.getAdminEmail()%>">

									</div>
								</div>





								<div class="form-actions">
									<button type="submit" class="btn btn-success">
										<i class="fas fa-save"></i> Save General Settings
									</button>
								</div>
							</form>
						</div>
					</div>

					<!-- Password Change Tab -->
					<div id="password" class="tab-content">
						<h3 style="margin-bottom: 25px; color: var(--secondary);">
							<i class="fas fa-key"></i> Change Password
						</h3>

						<div class="form-container">
							<form action="<%=request.getContextPath()%>/admin/settings"
								method="post">
								<input type="hidden" name="formType" value="password">

								<div class="form-group">
									<label for="currentPassword">Current Password </label> <input
										type="password" id="currentPassword"
										placeholder="old password" class="form-control">
								</div>

								<div class="form-row">
									<div class="form-group">
										<label for="newPassword">New Password </label> <input
											type="password" id="newPassword" name="adminPassword"
											class="form-control" placeholder="new password">
									</div>
									<div class="form-group">
										<label for="confirmPassword">Confirm New Password </label> <input
											type="password" id="confirmPassword" name="confirmPassword"
											class="form-control" placeholder="">
									</div>
								</div>

								<div
									style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
									<h5 style="color: var(--secondary); margin-bottom: 10px;">
										<i class="fas fa-info-circle"></i> Password Requirements:
									</h5>
									<ul style="color: #666; padding-left: 20px; margin: 0;">
										<li>Minimum 8 characters</li>
										<li>At least one uppercase letter</li>
										<li>At least one number</li>
										<li>At least one special character</li>
									</ul>
								</div>

								<div class="form-actions">
									<button type="submit" class="btn btn-success">
										<i class="fas fa-key"></i> Update Password
									</button>
								</div>
							</form>
						</div>
					</div>

					<!-- Company Info Tab -->
					<div id="company" class="tab-content">
						<h3 style="margin-bottom: 25px; color: var(--secondary);">
							<i class="fas fa-building"></i> Company Information
						</h3>

						<div class="form-container">
							<form action="<%=request.getContextPath()%>/admin/settings"
								method="post">
								<input type="hidden" name="formType" value="company">

								<div class="form-group">
									<label for="companyName">Company Name </label> <input
										type="text" id="companyName" class="form-control"
										name="companyName" placeholder="company name"
										value="<%=admin.getCompanyName() != null ? admin.getCompanyName() : ""%>">

								</div>

								<div class="form-row">
									<div class="form-group">
										<label for="companyEmail">Company Email</label> <input
											type="email" id="companyEmail" class="form-control"
											name="companyEmail" placeholder="company email"
											value="<%=admin.getCompanyEmail() != null ? admin.getCompanyEmail() : ""%>">


									</div>
									<div class="form-group">
										<label for="companyPhone">Phone Number</label><input
											type="tel" id="companyPhone" class="form-control"
											name="companyPhone" placeholder="company hotline"
											value="<%=admin.getCompanyPhone() != null ? admin.getCompanyPhone() : ""%>">

									</div>
								</div>

								<div class="form-group">
									<label for="companyAddress">Address</label>
									<textarea id="companyAddress" class="form-control"
										placeholder="comopany address" name="companyAddress" rows="3"><%=admin.getCompanyAddress() != null ? admin.getCompanyAddress() : ""%></textarea>
								</div>






								<div class="form-actions">
									<button type="submit" class="btn btn-success">
										<i class="fas fa-save"></i> Save Company Info
									</button>
								</div>
							</form>
						</div>
					</div>


				</div>
			</div>
		</main>
	</div>


	<script>
		function openTab(evt, tabName) {
			// Hide all tab contents
			const tabContents = document.getElementsByClassName("tab-content");
			for (let i = 0; i < tabContents.length; i++) {
				tabContents[i].classList.remove("active");
			}

			// Remove active class from all tab buttons
			const tabButtons = document.getElementsByClassName("tab-btn");
			for (let i = 0; i < tabButtons.length; i++) {
				tabButtons[i].classList.remove("active");
			}

			// Show current tab and mark button as active
			document.getElementById(tabName).classList.add("active");
			evt.currentTarget.classList.add("active");
		}
	</script>
</body>
</html>