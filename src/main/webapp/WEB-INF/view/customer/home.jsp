<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.quick_bite.model.Product"%>
<%@page import="com.quick_bite.model.ProductImage"%>
<%@page import="com.quick_bite.model.Customer"%>

<%
Customer customer = (Customer) session.getAttribute("customer");

if (customer == null) {


	response.sendRedirect(request.getContextPath() + "/login.jsp?error=please login first");
	return;

}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Dashboard - Quick Bite</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/customer-style.css">
	<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/home.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<!-- Top Navigation -->
	<nav class="dashboard-nav">
		<div class="nav-content">
			<a href="dashboard.jsp" class="nav-logo"> <i
				class="fas fa-hamburger"></i> <span>Quick<span>Bite</span></span>
			</a>


			<div class="nav-actions">
				<a href="${pageContext.request.contextPath}/profile"
					class="nav-icon"> <i class="fas fa-user"></i>
				</a> <a href="${pageContext.request.contextPath}/orders"
					class="nav-icon"> <i class="fas fa-box"></i>
				</a> <a href="<%=request.getContextPath()%>/logout" class="nav-icon"> <i
					class="fas fa-sign-out-alt"></i>
				</a>
			</div>
		</div>
	</nav>

	<!-- Main Dashboard -->
	<div class="dashboard-container">
		<!-- Welcome Section -->
		<div class="welcome-section">
			<div class="welcome-content">
				<h1>
					Welcome back<%=(customer.getFullName() != null && !customer.getFullName().isEmpty()) ? ", " + customer.getFullName() : ""%>!
				</h1>

				<p>What would you like to eat today?</p>
				<div class="delivery-info">
					<i class="fas fa-map-marker-alt"></i> <span><%=(customer.getAddress() != null && !customer.getAddress().isEmpty()) ? ", " + customer.getAddress() : ""%></span>
					
				</div>
			</div>
			<div class="promo-banner">
				<i class="fas fa-bolt"></i>
				<div>
					<h3>30-Minute Delivery</h3>
					<p>Order now, get it fast!</p>
				</div>
			</div>
		</div>

		<!-- Quick Categories -->
		<div class="quick-categories">
			<h2 class="section-title">Quick Categories</h2>
			<div class="categories-grid">
				<a href="home?category=Burgers" class="category-item">
					<div class="category-icon burger">
						<i class="fas fa-hamburger"></i>
					</div> <span>Burgers</span>
				</a> <a href="home?category=Pizza" class="category-item">

					<div class="category-icon pizza">
						<i class="fas fa-pizza-slice"></i>
					</div> <span>Pizza</span>
				</a> <a href="home?category=Chicken" class="category-item">

					<div class="category-icon chicken">
						<i class="fas fa-drumstick-bite"></i>
					</div> <span>Chicken</span>
				</a> <a href="home?category=Drinks" class="category-item">

					<div class="category-icon drinks">
						<i class="fas fa-wine-bottle"></i>
					</div> <span>Drinks</span>
				</a> <a href="home?category=Desserts" class="category-item">

					<div class="category-icon desserts">
						<i class="fas fa-ice-cream"></i>
					</div> <span>Desserts</span>
				</a> <a href="home?category=Sides" class="category-item">

					<div class="category-icon sides">
						<i class="fas fa-french-fries"></i>
					</div> <span>Sides</span>
				</a>
			</div>
		</div>

		<div class="popular-section">
			<div class="section-header">
				<h2 class="section-title">Popular Near You</h2>
				
			</div>

			<div class="items-grid">
				<%
				List<Product> products = (List<Product>) request.getAttribute("products");

				if (products != null && !products.isEmpty()) {


					for (Product p : products) {


						List<ProductImage> images = p.getImages();
				%>
				<div class="food-item">
					<a
						href="<%=request.getContextPath()%>/quick_bite/food/view?id=<%=p.getProductId()%>"
						class="product-card">
						<div class="item-image">
							<%
							if (images != null && !images.isEmpty()) {
							%>
							<img class="food-image"
								src="<%=request.getContextPath()%>/uploads/<%=images.get(0).getImageName()%>"
								>
							<%
							} else {
							%>
							<i class="fas fa-hamburger fa-2x" style="color: #666;"></i>
							<%
							}
							%>
						</div>
					</a>
					<div class="item-info">
						<h3><%=p.getProductName()%></h3>
						<p><%=p.getCategoriesName() != null ? p.getCategoriesName() : "Uncategorized"%></p>
						<div class="item-meta">
							<span class="price">$<%=String.format("%.2f", p.getProductPrice())%></span>
						</div>

					</div>
				</div>
				<%
				}

				} else {
				%>
				<a href="<%=request.getContextPath()%>/home" class="view-all"> <i
					class="fas fa-arrow-left"></i>return back </a>
				<p>No products available right now.</p>
				<%
				}
				%>

			</div>
		</div>


	
	</div>


</body>
</html>