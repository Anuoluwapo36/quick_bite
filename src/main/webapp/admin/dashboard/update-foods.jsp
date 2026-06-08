<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.quick_bite.model.Admin"%>

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
<%@ page import="com.quick_bite.model.Product"%>

<%
Product product = (Product) request.getAttribute("product");

if (product == null) {


	response.sendRedirect(request.getContextPath() + "/admin/products");
	return;

}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add food - QuitBite Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="dashboard-container">
		<!-- Sidebar  -->
		<aside class="sidebar">
			<div class="sidebar-header">
				<h2>
					<i class="fas fa-hamburger"></i> <%=admin.getCompanyName() %>
				</h2>
			</div>
						<nav class="sidebar-menu">
				<a href="dashboard.jsp" class="menu-item "> <i
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
			<header class="content-header">
				<h1>
					<i class="fas fa-plus-circle"></i> Add New Product
				</h1>
				<a href="products.jsp" class="btn"> <i class="fas fa-arrow-left"></i>
					Back to Products
				</a>
			</header>

			<!-- Add Product Form -->
			<div class="form-container">
				<%
				String error = request.getParameter("error");

				if ("errors".equals(error)) {
				%>
				<p style="color: red;">input cant not be empty</p>
				<%
				} else if ("invalid".equals(error)) {
				%>
				<p style="color: red;">Invalid credentials</p>
				<%
				}
				%>



				<form action="<%=request.getContextPath()%>/admin/update-product"
					method="post" enctype="multipart/form-data">
					<input type="hidden" name="productId"
						value="<%=product.getProductId()%>">

					<div class="form-row">
						<div class="form-group">
							<label for="productName">Product Name </label> <input type="text"
								id="productName" class="form-control" name="foodname"
								value="<%=product.getProductName()%>"
							placeholder="e.g., Classic Burger">
						</div>

						<div class="form-group">
							<label for="category">Category </label> <select id="category"
								name="category" class="form-control">
								<option value="">Select Category</option>

								<option value="burgers"
									<%="burgers".equalsIgnoreCase(product.getCategoriesName()) ? "selected" : ""%>>
									Burgers</option>

								<option value="pizzas"
									<%="pizzas".equalsIgnoreCase(product.getCategoriesName()) ? "selected" : ""%>>
									Pizzas</option>

								<option value="drinks"
									<%="drinks".equalsIgnoreCase(product.getCategoriesName()) ? "selected" : ""%>>
									Drinks</option>

								<option value="sides"
									<%="sides".equalsIgnoreCase(product.getCategoriesName()) ? "selected" : ""%>>
									Sides</option>

								<option value="desserts"
									<%="desserts".equalsIgnoreCase(product.getCategoriesName()) ? "selected" : ""%>>
									Desserts</option>
							</select>

						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="price">Price ($) </label> <input type="number"
								id="price" class="form-control" name="price"
								value="<%=product.getProductPrice()%>"
							placeholder="e.g., 8.99" step="0.01">
						</div>

				
					</div>

					<div class="form-group">
						<label for="description">Description</label>
						<textarea id="description" class="form-control" rows="4"
							name="description" placeholder="Product description..."><%=product.getProductDesc()%></textarea>
					</div>

				<div class="form-group">
					<label>Current Images</label>
					<div
						style="display: flex; gap: 10px; flex-wrap: wrap; max-height: 150px; overflow-y: auto;">
						<%
						if (product.getImages() != null && !product.getImages().isEmpty()) {


							for (com.quick_bite.model.ProductImage img : product.getImages()) {
						%>
						<img
							src="<%=request.getContextPath()%>/uploads/<%=img.getImageName()%>"
							style="width: 80px; height: 80px; object-fit: cover; border-radius: 5px;">
						<div style="position: relative;">
							
							<a
								href="<%=request.getContextPath()%>/admin/delete-product-image?id=<%=img.getImageId()%>"
								style="position: absolute; top: -5px; right: -5px; color: red; font-weight: bold;">×</a>
						</div>


						<%
						}

						} else {
						%>
						<p>No images uploaded</p>
						<%
						}
						%>
					</div>
				</div>

					<div class="form-group">
						<label>Product Image</label>
						<div
							style="border: 2px dashed #ddd; padding: 30px; text-align: center; border-radius: 5px; cursor: pointer;">
							<i class="fas fa-cloud-upload-alt"
								style="font-size: 48px; color: #ccc;"></i>
							<p>Click to upload product image</p>
							<input type="file" name="productImages" multiple accept="image/*">
						</div>
					</div>

					<div class="form-group">
						<label> <input type="checkbox" checked> Product is
							active (visible to customers)
						</label>
					</div>

					<div class="form-actions">
						<button type="reset" class="btn">
							<i class="fas fa-times"></i> Cancel
						</button>
						<button type="submit" class="btn btn-success">
							<i class="fas fa-save"></i> Save Product
						</button>
					</div>
				</form>
			</div>

		</main>
	</div>
</body>
</html>