<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.quick_bite.model.Customer"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<title>My Profile - Quick Bite</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/profile.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/customer/css/profile.css">
</head>
<body>

	<%
	Customer customer = (Customer) session.getAttribute("customer");
	if (customer == null) {
		response.sendRedirect("login.jsp");
		return;
	}

	String error = (String) request.getAttribute("error");
	String success = (String) request.getAttribute("success");
	%>

	<div class="profile-container">

		<%
		if (error != null) {
		%>
		<div class="alert alert-error"><%=error%></div>
		<%
		}
		%>
		<%
		if (success != null) {
		%>
		<div class="alert alert-success"><%=success%></div>
		<%
		}
		%>

	
		<div class="profile-layout">

			<div class="profile-sidebar">
				<div class="profile-card">
					<div class="profile-avatar">
						<div class="avatar-circle">
							<i class="fas fa-user"></i>
						</div>
						
					</div>

					<div class="profile-info">
						<h2 class="profile-name"><%=customer.getFullName()%></h2>
						<p class="profile-email"><%=customer.getEmail()%></p>
						<p class="profile-member">
							<i class="fas fa-crown" style="color: #FFD166;"></i> Member Since
							<%=customer.getCreatedAt() != null ? customer.getCreatedAt().toLocalDateTime().getYear() : "N/A"%>
						</p>
					</div>

				
				</div>

				<div class="quick-actions">
					<h3>Quick Actions</h3>
					<div class="action-grid">
						<button class="action-btn"
							onclick="window.location.href='<%=request.getContextPath()%>/home'">
							<i class="fas fa-home"></i> Home
						</button>
						<button class="action-btn"
							onclick="window.location.href='<%=request.getContextPath()%>/orders'">
							<i class="fas fa-history"></i> Order History
						</button>
						<button class="action-btn"
							onclick="window.location.href='<%=request.getContextPath()%>/settings'">
							<i class="fas fa-cog"></i> Settings
						</button>
					</div>
				</div>
			</div>

<!-- Recent Activity -->
<div class="content-section">
    <div class="section-header">
        <h2><i class="fas fa-clock" style="color: #06D6A0;"></i> Recent Activity</h2>
    </div>
    
    <div class="activity-list">
        <%
            List<com.quick_bite.model.Activity> activities = (List<com.quick_bite.model.Activity>) request.getAttribute("activities");
            if (activities != null && !activities.isEmpty()) {
                for (com.quick_bite.model.Activity act : activities) {
        %>
        <div class="activity-item">
            <div class="activity-icon">
                <% 
                    switch(act.getType()) {
                        case "Order Placed": %>
                            <i class="fas fa-shopping-cart"></i>
                        <% break;
                        case "Payment Made": %>
                            <i class="fas fa-credit-card"></i>
                        <% break;
                        case "Profile Updated": %>
                            <i class="fas fa-user-edit"></i>
                        <% break;
                        case "Password Changed": %>
                            <i class="fas fa-lock"></i>
                        <% break;
                        default: %>
                            <i class="fas fa-info-circle"></i>
                    <% } %>
            </div>
            <div class="activity-details">
                <h4><%= act.getType() %></h4>
                <p><%= act.getDetails() %></p>
            </div>
            <span class="activity-status"><%= act.getStatus() != null ? act.getStatus() : "" %></span>
        </div>
        <%
                } // end for
            } else {
        %>
        <p>No recent activity.</p>
        <% } %>
    </div>
</div>


		</div>
	</div>



</body>
</html>
