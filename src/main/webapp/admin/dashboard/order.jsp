<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.quick_bite.model.Order"%>

<%@page import="com.quick_bite.model.Admin"%>
<%@page import="com.quick_bite.model.Payment"%>
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

if (request.getAttribute("orders") == null) {
	response.sendRedirect(request.getContextPath() + "/admin/orders");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Orders - QuitBite Admin</title>
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
					<a href="<%=request.getContextPath()%>/admin/dashboard"
					class="menu-item "> <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
				</a> <a href="<%=request.getContextPath()%>/admin/products"
					class="menu-item"> <i class="fas fa-utensils"></i> <span>Products</span>
				</a> <a href="<%=request.getContextPath()%>/admin/addProduct"
					class="menu-item"> <i class="fas fa-plus-circle"></i> <span>Add
						Product</span>
				</a> <a href="<%=request.getContextPath()%>/admin/orders"
					class="menu-item active"> <i class="fas fa-shopping-cart"></i> <span>Orders</span>
				
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
					<i class="fas fa-shopping-cart"></i> Order Management
				</h1>
				<div style="display: flex; gap: 10px;">
					<select class="form-control" style="width: 150px;"
						id="statusFilter">
						<option>All Status</option>
						<option>Pending</option>
						<option>Preparing</option>
						<option>Delivering</option>
						<option>Completed</option>
						<option>Cancelled</option>
					</select> <input type="date" class="form-control" style="width: 150px;"
						id="dateFilter">

				</div>
			</header>

			<!-- Order Stats -->
			<div class="cards-container">
				<div class="card" onclick="filterByStatus('Pending')"
					style="cursor: pointer;">
					<div style="color: var(--warning); font-size: 24px;">
						<i class="fas fa-clock"></i>
					</div>
					<h3>${pendingOrder}</h3>
					<p>Pending Orders</p>
				</div>

				<div class="card" onclick="filterByStatus('Preparing')"
					style="cursor: pointer;">
					<div style="color: var(--info); font-size: 24px;">
						<i class="fas fa-utensils"></i>
					</div>
					<h3>${preparingOrder}</h3>
					<p>Preparing</p>
				</div>

				<div class="card" onclick="filterByStatus('Delivering')"
					style="cursor: pointer;">
					<div style="color: var(--primary); font-size: 24px;">
						<i class="fas fa-motorcycle"></i>
					</div>
					<h3>${deliveryOrders}</h3>
					<p>Out for Delivery</p>
				</div>

				<div class="card" onclick="filterByStatus('Completed')"
					style="cursor: pointer;">
					<div style="color: var(--success); font-size: 24px;">
						<i class="fas fa-check-circle"></i>
					</div>
					<h3>${completedToday}</h3>
					<p>Completed Today</p>
				</div>
			</div>

			<!-- Orders Table -->
			<div class="table-container">
				<div
					style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
					<h3>
						<i class="fas fa-list"></i> All Orders
					</h3>
					<div style="display: flex; gap: 10px;">
						<input type="text" class="form-control"
							placeholder="Search orders..." style="width: 200px;"
							id="searchOrder">
						<button class="btn btn-primary" onclick="searchOrders()">
							<i class="fas fa-search"></i>
						</button>
					</div>
				</div>

				<table>
					<thead>
						<tr>
							<th>Order ID</th>
							<th>Customer</th>
							<th>Date & Time</th>
							<th>Items</th>
							<th>Total</th>
							<th>Status</th>
							<th>Payment</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<Order> orders = (List<Order>) request.getAttribute("orders");

						if (orders != null && !orders.isEmpty()) {
							for (Order order : orders) {
						%>
						<tr data-order-id="<%=order.getOrderId()%>"
							data-customer="<%=order.getCustomerName().toLowerCase()%>"
							data-status="<%=order.getStatus()%>"
							data-date="<%=order.getCreatedAt()%>">

							<td><strong>#ORD<%=order.getOrderId()%></strong></td>
							<td><%=order.getCustomerName()%><br> <small><%=order.getCustomerEmail()%></small></td>
							<td><%=order.getCreatedAt()%></td>
							<td>
								<%
								for (com.quick_bite.model.OrderItem item : order.getItems()) {
									double itemTotal = item.getPrice() * item.getQuantity();
								%> <%=item.getQuantity()%>x <%=item.getProduct().getProductName()%>
								- $<%=String.format("%.2f", itemTotal)%><br> <%
 }
 %>
							</td>
							<td>
								<%
								double orderTotal = order.getItems().stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
								%> $<%=String.format("%.2f", orderTotal)%>
							</td>
							<td><select class="form-control"
								style="width: 120px; padding: 5px;"
								onchange="updateOrderStatus(<%=order.getOrderId()%>, this.value)">
									<%
									String status = order.getStatus();
									%>
									<option disabled selected value="">Select status</option>

									<%
									if ("Pending".equals(status)) {
									%>
									<option value="Preparing">Preparing</option>
									<option value="Cancelled">Cancelled</option>
									<%
									} else if ("Preparing".equals(status)) {
									%>
									<option value="pick-up">Pick-up</option>
									<option value="Delivering">Delivering</option>
									<option value="Cancelled">Cancelled</option>
									<%
									} else if ("pick-up".equals(status) || "Delivering".equals(status)) {
									%>
									<option value="Completed">Completed</option>
									<option value="Cancelled">Cancelled</option>
									<%
									} else if ("Completed".equals(status) || "Cancelled".equals(status)) {
									%>
									<option disabled>Cannot change if order is completed</option>
									<%
									}
									%>
							</select></td>


							<td>
								<%
								Payment payment = order.getPaymetinfo();
								if (payment != null && payment.getPaymentStatus() != null) {

									String dbStatus = payment.getPaymentStatus().trim();
									String color = "black";

									if (dbStatus.equalsIgnoreCase("PAID") || dbStatus.equalsIgnoreCase("SUCCESS")
									|| dbStatus.equalsIgnoreCase("COMPLETED")) {
										color = "var(--success)";
									} else if (dbStatus.equalsIgnoreCase("FAILED") || dbStatus.equalsIgnoreCase("DECLINED")
									|| dbStatus.equalsIgnoreCase("CANCELLED")) {
										color = "var(--danger)";
									} else {
										color = "orange";
									}
								%> <span style="color: <%=color%>;"> <i
									class="fas fa-credit-card"></i> <%=dbStatus%>
							</span> <%
 } else {
 %> <span style="color: var(--danger);"> <i
									class="fas fa-exclamation-circle"></i> No Payment
							</span> <%
 }
 %>
							</td>


							<td>
								<div class="btn-group">
									<button class="btn btn-sm btn-info view-order-btn"
										value="<%=order.getOrderId()%>">
										<i class="fas fa-eye"></i>
									</button>


								</div>
							</td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="8" style="text-align: center;">No orders found.</td>
						</tr>
						<%
						}
						%>
					</tbody>


				</table>
			</div>

			<!-- Order Summary -->
			<div
				style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 30px;">
				<!-- Today's Summary -->
				<div class="table-container">
					<h3>
						<i class="fas fa-calendar-day"></i> Today's Summary
					</h3>
					<table>
						<tr>
							<td>Total Orders:</td>
							<td><strong>${totalOrders}</strong></td>
						</tr>
						<tr>
							<td>Total Revenue:</td>
							<td><strong style="color: var(--success);">$${totalRevenue}</strong></td>
						</tr>
						<tr>
							<td>Average Order Value:</td>
							<td><strong>$${avgOrderValue}</strong></td>
						</tr>
						<tr>
							<td>Delivery Orders:</td>
							<td><strong>${deliveryOrders}</strong></td>
						</tr>
						<tr>
							<td>Pickup Orders:</td>
							<td><strong>${pickupOrders}</strong></td>
						</tr>
					</table>
				</div>



			</div>


		</main>
	</div>
	<!-- Centered Overlay Message -->
	<div id="statusOverlay"
		style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 2000; justify-content: center; align-items: center; opacity: 0; transition: opacity 0.4s;">
		<div id="statusOverlayText"
			style="background: white; padding: 20px 40px; border-radius: 10px; font-size: 18px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.3); text-align: center; min-width: 250px;">
			<!-- Message goes here -->
		</div>
	</div>

	<!-- Order Details Modal -->
	<div id="orderModal"
		style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1000; justify-content: center; align-items: center;">
		<div
			style="background: white; width: 90%; max-width: 800px; max-height: 90%; overflow-y: auto; border-radius: 10px; padding: 30px;">
			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h2 id="modalTitle">Order Details</h2>
				<button onclick="closeModal()"
					style="background: none; border: none; font-size: 24px; cursor: pointer; color: #666;">
					<i class="fas fa-times"></i>
				</button>
			</div>
			<div id="modalContent">
				<jsp:include page="/admin/dashboard/order-details.jsp" />

			</div>
			<div style="display: flex; gap: 10px; margin-top: 20px;">
				<button class="btn btn-primary" onclick="printOrder()">
					<i class="fas fa-print"></i> Print Invoice
				</button>
				<button class="btn" onclick="closeModal()">Close</button>
			</div>
		</div>
	</div>

	<script>
	let currentPage = 1;
	const rowsPerPage = 50;

	function filterOrders() {
	    const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
	    const dateFilter = document.getElementById('dateFilter').value;
	    const searchTerm = document.getElementById('searchOrder').value.toLowerCase();

	    const rows = Array.from(document.querySelectorAll('table tbody tr'));

	    // Filter rows by status, date, search
	    const filteredRows = rows.filter(row => {
	        const rowStatus = row.dataset.status.toLowerCase();
	        const rowDate = row.dataset.date.split(' ')[0];
	        const rowCustomer = row.dataset.customer.toLowerCase();
	        const rowOrderId = row.dataset.orderId.toLowerCase();

	        const matchesStatus = (!statusFilter || statusFilter === 'all status' || rowStatus === statusFilter);
	        const matchesDate = (!dateFilter || rowDate === dateFilter);
	        const matchesSearch = (!searchTerm || rowCustomer.includes(searchTerm) || rowOrderId.includes(searchTerm));

	        return matchesStatus && matchesDate && matchesSearch;
	    });

	    // Hide all rows
	    rows.forEach(row => row.style.display = 'none');

	    // Show only current page
	    const start = (currentPage - 1) * rowsPerPage;
	    const end = start + rowsPerPage;
	    filteredRows.slice(start, end).forEach(row => row.style.display = '');

	    updatePaginationButtons(filteredRows.length);
	}

//next and prev

function updatePaginationButtons(totalRows) {
    const totalPages = Math.ceil(totalRows / rowsPerPage);
    const pageButtons = document.querySelectorAll('.pagination-container button[data-page]');

    pageButtons.forEach(btn => {
        const page = parseInt(btn.dataset.page);
        btn.style.display = (page <= totalPages) ? 'inline-flex' : 'none';
        btn.classList.toggle('btn-primary', page === currentPage);
    });
}

document.querySelectorAll('.pagination-container button[data-page]').forEach(btn => {
    btn.addEventListener('click', () => {
        currentPage = parseInt(btn.dataset.page);
        filterOrders();
    });
});

document.getElementById('prevPage').addEventListener('click', () => {
    if(currentPage > 1) { currentPage--; filterOrders(); }
});

document.getElementById('nextPage').addEventListener('click', () => {
    const totalRows = document.querySelectorAll('table tbody tr').length;
    const totalPages = Math.ceil(totalRows / rowsPerPage);
    if(currentPage < totalPages) { currentPage++; filterOrders(); }
});

 //fliter by card and input

// Status dropdown
document.getElementById('statusFilter').addEventListener('change', () => {
    filterOrders();
    highlightCard(document.getElementById('statusFilter').value);
});

// Date picker
document.getElementById('dateFilter').addEventListener('change', filterOrders);

// Search input
document.getElementById('searchOrder').addEventListener('input', filterOrders);

// Status cards
const statusCards = document.querySelectorAll('.cards-container .card');

function highlightCard(selectedStatus) {
    statusCards.forEach(card => {
        const cardText = card.querySelector('p').textContent.toLowerCase();
        card.style.border = (cardText === selectedStatus.toLowerCase())
            ? '2px solid var(--primary)'
            : '1px solid #ccc';
    });
}

function filterByStatus(status) {
    document.getElementById('statusFilter').value = status;
    filterOrders();
    highlightCard(status);
}




  



    function reprintReceipt(orderId) {
        alert(`Reprinting receipt for order #${orderId}`);
        // In real app, generate and print receipt
    }

    // Modal functions
    function closeModal() {
        document.getElementById('orderModal').style.display = 'none';
    }

    function printOrder() {
        alert('Printing order invoice...');
        // In real app, open print dialog
    }

    // Quick action functions
    function printTodayOrders() {
        alert('Printing today\'s orders...');
    }

    function exportOrders() {
        alert('Exporting orders to Excel...');
    }

    function viewPendingOrders() {
        filterByStatus('Pending');
    }

    function sendReminders() {
        alert('Sending order reminders to customers...');
    }

    // Close modal when clicking outside
    document.getElementById('orderModal').addEventListener('click', function(e) {
        if(e.target === this) {
            closeModal();
        }
    });
    </script>

	<script>
	function updateOrderStatus(orderId, status) {
	    fetch('<%=request.getContextPath()%>/admin/orderAction', {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	        body: 'action=updateStatus&orderId=' + orderId + '&status=' + encodeURIComponent(status)
	    })
	    .then(response => response.json())
	    .then(data => {
	        const statusSpan = document.querySelector(`#orderStatus`);
	        if (data.success) {
	            if (statusSpan) statusSpan.textContent = status;
	            showOverlayMessage(`Order  status updated`, true);
	        } else {
	            showOverlayMessage('Failed to update order status', false);
	        }
	    })
	    .catch(err => {
	        console.error(err);
	        showOverlayMessage('Error updating order status', false);
	    });
	}



// Overlay message function
function showOverlayMessage(message, success = true, duration = 2000) {
    const overlay = document.getElementById('statusOverlay');
    const overlayText = document.getElementById('statusOverlayText');

    overlayText.textContent = message;
    overlayText.style.backgroundColor = success ? '#d4edda' : '#f8d7da';
    overlayText.style.color = success ? '#155724' : '#721c24';
    overlay.style.display = 'flex';
    overlay.style.opacity = 0;

    // Small delay to trigger CSS transition
    setTimeout(() => overlay.style.opacity = 1, 10);

    setTimeout(() => {
        overlay.style.opacity = 0;
        setTimeout(() => overlay.style.display = 'none', 400);
    }, duration);
}
</script>



	<script>
    // Select the modal and close buttons
    const modal = document.getElementById('orderModal');
    const closeBtn = document.querySelector('#orderModal button[id="modalCloseBtn"]');
    const closeBtn2 = document.getElementById('modalCloseBtn2');

    // Select all "View" buttons
    const viewButtons = document.querySelectorAll('.view-order-btn');

    viewButtons.forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.value;

            // Fetch the JSP for this order
            fetch('<%=request.getContextPath()%>/admin/orderDetails?orderId=' + orderId)
                .then(response => response.text())  // Get HTML
                .then(html => {
                    document.getElementById('modalContent').innerHTML = html;
                    modal.style.display = 'flex'; // Show modal
                })
                .catch(err => alert('Failed to load order details'));
        });
    });

    // Close modal when X button is clicked
    closeBtn.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    // Close modal when bottom "Close" button is clicked
    closeBtn2.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    // Close modal if clicking outside the modal content
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
</script>


</body>
</html>