<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.quick_bite.model.Product"%>
<%@ page import="com.quick_bite.model.ProductImage"%>

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
<title>Products - QuitBite Admin</title>
<link rel="stylesheet" href="css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="dashboard-container">
		<aside class="sidebar">
			<div class="sidebar-header">
				<h2>
					<i class="fas fa-hamburger"></i><%=admin.getCompanyName() %>
				</h2>
			</div>
			<nav class="sidebar-menu">
				<a href="<%=request.getContextPath()%>/admin/dashboard"" class="menu-item "> <i
					class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
				</a> <a href="<%=request.getContextPath()%>/admin/products"
					class="menu-item active"> <i class="fas fa-utensils"></i> <span>Products</span>
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

		<main class="main-content">
			<header class="content-header">
				<h1>
					<i class="fas fa-utensils"></i> Manage Products
				</h1>

			</header>

			<!-- Products Table -->
			<div class="table-container" style="height: 730px; overflow-y: auto;">

				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>Image</th>
							<th>Product Name</th>
							<th>Category</th>
							<th>Price</th>

							<th>Actions</th>
						</tr>
					</thead>
					 <tbody id="productsTbody">
						<%
						List<Product> products = (List<Product>) request.getAttribute("products");

						if (products != null && !products.isEmpty()) {

							int counter = 1;

							for (Product p : products) {
						%>
						<tr class="product-row" data-set="<%=counter%>"
							data-id="<%=p.getProductId()%>"
							data-category="<%=p.getCategoriesName() != null ? p.getCategoriesName() : "Uncategorized"%>"
							data-price="<%=p.getProductPrice()%>">
							<td>#<%=String.format("%03d", counter++)%></td>
							<td>
								<div
									style="width: 50px; height: 50px; border-radius: 5px; display: flex; align-items: center; justify-content: center; background: #eee;">
									<%
									List<ProductImage> images = p.getImages();

									if (images != null && !images.isEmpty()) {
									%>
									<img
										src="<%=request.getContextPath()%>/uploads/<%=images.get(0).getImageName()%>"
										width="50" height="50"
										style="object-fit: cover; border-radius: 5px;">

									<%
									} else {
									%>
									<i class="fas fa-hamburger" style="color: #666;"></i>
									<%
									}
									%>
								</div>
							</td>
							<td><%=p.getProductName()%></td>
							<td><%=p.getCategoriesName() != null ? p.getCategoriesName() : "Uncategorized"%></td>
							<td>$<%=String.format("%.2f", p.getProductPrice())%></td>

							<td>
								<div class="btn-group">
									<a
										href="<%=request.getContextPath()%>/admin/edit-product?id=<%=p.getProductId()%>"
										class="btn btn-sm btn-warning"><i class="fas fa-edit"></i></a>
									<a href="javascript:void(0)" class="btn btn-sm btn-danger"
										onclick="openDeleteModal(<%=p.getProductId()%>)"> <i
										class="fas fa-trash"></i>
									</a>

								</div> <!-- Delete Confirmation Overlay -->
								<div id="deleteOverlay" class="delete-overlay">
									<div class="delete-modal">
										<h2>Delete foods?</h2>
										<p>This action cannot be undone.</p>

										<form
											action="<%=request.getContextPath()%>/admin/deleteProduct"
											method="post">
											<input type="hidden" name="id" id="deleteProductId">

											<div class="delete-actions">
												<button type="button" class="btn-cancel"
													onclick="closeDeleteModal()">No</button>
												<button type="submit" class="btn-delete">Yes,
													Delete</button>
											</div>
										</form>
									</div>
								</div>
							</td>
						</tr>
						<%
						}

						} else {
						%>
						<tr>
							<td colspan="8" style="text-align: center;">No products
								found.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>




			<!-- Pagination Buttons -->
			<div id="pagination"
				style="display: flex; justify-content: center; margin-top: 20px;  gap: 10px;">
				<button class="btn" id="prevBtn">« Prev</button>
				<span id="pageNumbers"></span>
				<button class="btn" id="nextBtn">Next »</button>
			</div>

		</main>

	</div>

	<script>
function openDeleteModal(productId) {
    document.getElementById("deleteProductId").value = productId;
    document.getElementById("deleteOverlay").style.display = "flex";
}

function closeDeleteModal() {
    document.getElementById("deleteOverlay").style.display = "none";
}
</script>
	<script>
const rows = Array.from(document.querySelectorAll('.product-row'));
const rowsPerPage = 8;  
let currentPage = 1;
const totalPages = Math.ceil(rows.length / rowsPerPage);

function showPage(page) {
    rows.forEach(row => row.style.display = 'none');

    const start = (page - 1) * rowsPerPage;
    const end = start + rowsPerPage;

    rows.slice(start, end).forEach(row => row.style.display = '');

    const pageNumbersDiv = document.getElementById('pageNumbers');
    pageNumbersDiv.innerHTML = '';
    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.className = 'btn ' + (i === page ? 'btn-primary' : '');
        btn.onclick = () => {
            currentPage = i;
            showPage(currentPage);
        };
        pageNumbersDiv.appendChild(btn);
    }

    document.getElementById('prevBtn').disabled = page === 1;
    document.getElementById('nextBtn').disabled = page === totalPages;
}

document.getElementById('prevBtn').onclick = () => {
    if (currentPage > 1) {
        currentPage--;
        showPage(currentPage);
    }
};
document.getElementById('nextBtn').onclick = () => {
    if (currentPage < totalPages) {
        currentPage++;
        showPage(currentPage);
    }
};

showPage(currentPage);
</script>
</body>
</html>