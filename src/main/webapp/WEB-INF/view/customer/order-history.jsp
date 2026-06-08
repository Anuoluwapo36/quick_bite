<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.quick_bite.model.Order"%>
<%@ page import="com.quick_bite.model.OrderItem"%>
<%@ page import="com.quick_bite.model.Customer"%>




<!DOCTYPE html>
<html>
<head>
<title>Order History - Quick Bite</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/order.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/customer/css/order-history.css">
</head>
<body>
	<div class="order-history-container">
		<!-- Header -->
		<div class="history-header">
			
			<h1>Order History</h1>
			<p class="subtitle">Track your past orders and reorder favorites</p>
		</div>



		<!-- Filter Tabs -->
		<div class="filter-tabs">
		<a href="${pageContext.request.contextPath}/home" class="tab-btn active" >Back Tto HomePage</a>
			<button class="tab-btn active" onclick="filterOrders('all')">All
				Orders</button>
			<button class="tab-btn" onclick="filterOrders('delivered')">Delivered</button>
			<button class="tab-btn" onclick="filterOrders('pending')">Pending</button>
			<button class="tab-btn" onclick="filterOrders('cancelled')">Cancelled</button>
		
		</div>

		<div class="orders-list">

			<%
			List<Order> orders = (List<Order>) request.getAttribute("orders");

			if (orders == null || orders.isEmpty()) {
			%>
			<script>
            document.addEventListener("DOMContentLoaded", () => {
                document.getElementById("emptyState").style.display = "block";
            });
        </script>
			<%
			} else {
			for (Order order : orders) {
			%>

			<div class="order-card <%=order.getStatus().toLowerCase()%>">
				<div class="order-header">
					<div class="order-info">
						<span class="order-id">Order #<%=order.getOrderId()%></span> <span
							class="order-date"> <%=order.getCreatedAt()%>
						</span>
					</div>
					<div class="order-status <%=order.getStatus().toLowerCase()%>">
						<%=order.getStatus()%>
					</div>
				</div>

				<div class="order-items">
					<%
					for (OrderItem item : order.getItems()) {
					%>
					<div class="order-item">
						<div class="item-image">
							<i class="fas fa-utensils"></i>
						</div>
						<div class="item-details">
							<h4><%=item.getProduct().getProductName()%></h4>
							<p>
								Quantity:
								<%=item.getQuantity()%></p>
						</div>
						<div class="item-price">
							$<%=item.getPrice() * item.getQuantity()%>
						</div>
					</div>
					<%
					}
					%>
				</div>

				<div class="order-footer">
					<div class="order-total">
						<span> Total: <strong>$<%=order.getTotalAmount()%></strong>
						</span>
					</div>

				
				</div>
			</div>

			<%
			}
			}
			%>

		</div>


		<!-- Empty State (Hidden by default) -->
		<div class="empty-state" id="emptyState" style="display: none;">
			<div class="empty-icon">
				<i class="fas fa-shopping-bag"></i>
			</div>
			<h2>No Orders Found</h2>
			<p>You haven't placed any orders yet.</p>
			<a class="btn-browse" href="${pageContext.request.contextPath}/home">
				<i class="fas fa-utensils"></i> Browse Menu
			</a>

		</div>
	</div>

	<script>
        function filterOrders(status) {
            const orders = document.querySelectorAll('.order-card');
            const emptyState = document.getElementById('emptyState');
            let visibleCount = 0;
            
            orders.forEach(order => {
                if (status === 'all' || order.classList.contains(status)) {
                    order.style.display = 'block';
                    visibleCount++;
                } else {
                    order.style.display = 'none';
                }
            });
            
            // Update active tab
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // Show empty state if no orders
            emptyState.style.display = visibleCount === 0 ? 'block' : 'none';
        }
        
        function searchOrders(query) {
            const orders = document.querySelectorAll('.order-card');
            const emptyState = document.getElementById('emptyState');
            let visibleCount = 0;
            
            orders.forEach(order => {
                const text = order.textContent.toLowerCase();
                if (query === '' || text.includes(query.toLowerCase())) {
                    order.style.display = 'block';
                    visibleCount++;
                } else {
                    order.style.display = 'none';
                }
            });
            
            emptyState.style.display = visibleCount === 0 ? 'block' : 'none';
        }
        
        function reorder(orderId) {
            if (confirm(`Reorder items from order ${orderId}?`)) {
                // Add loading state
                const btn = event.target.closest('.btn-reorder');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
                btn.disabled = true;
                
                // Simulate API call
                setTimeout(() => {
                    alert(`Items from order ${orderId} added to cart!`);
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    
                    // Redirect to cart or dashboard
                    window.location.href = 'dashboard.jsp?reorder=' + orderId;
                }, 1500);
            }
        }
        
        function trackOrder(orderId) {
            alert(`Tracking order ${orderId} - Estimated delivery: 15 minutes`);
        }
        
        function cancelOrder(orderId) {
            if (confirm(`Cancel order ${orderId}?`)) {
                // API call to cancel order
                alert(`Order ${orderId} cancelled successfully.`);
                event.target.closest('.order-card').querySelector('.order-status').textContent = 'Cancelled';
                event.target.closest('.order-card').querySelector('.order-status').className = 'order-status cancelled';
            }
        }
        
        function rateOrder(orderId) {
            const rating = prompt(`Rate order ${orderId} (1-5 stars):`, '5');
            if (rating && rating >= 1 && rating <= 5) {
                alert(`Thanks for rating order ${orderId} with ${rating} stars!`);
                event.target.textContent = `Rated ${rating}/5`;
            }
        }
    </script>
</body>
</html>