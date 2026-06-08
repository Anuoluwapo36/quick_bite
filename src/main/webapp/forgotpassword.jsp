<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// Get step as Integer from servlet
Integer stepAttr = (Integer) request.getAttribute("step");
int step = (stepAttr != null) ? stepAttr : 1;

String username = (String) request.getAttribute("username");
String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password - QuitBite</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/admin-style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="forgot-container">
		<div class="forgot-box">
			<div class="logo-header">
				<h2>
					<i class="fas fa-hamburger"></i> QuitBite LOGO
				</h2>
				<p class="subtitle">Reset Your Password</p>
			</div>

			<!-- Display error -->
			<%
			if (error != null) {
			%>
			<div class="error-message" style="color: red; margin-bottom: 15px;">
				<i class="fas fa-exclamation-circle"></i>
				<%=error%>
			</div>
			<%
			}
			%>

			<!-- Step 1: Enter Username -->
			<%
			if (step == 1) {
			%>
			<form action="<%=request.getContextPath()%>/forgot-password"
				method="post">
				<input type="hidden" name="step" value="1">
				<div class="form-group">
					<label><i class="fas fa-user"></i> Enter Admin Username</label> <input
						type="text" name="username" class="form-control"
						placeholder="Enter your username" required> <small
						class="help-text">Enter the username you use to login</small>
				</div>
				<div class="form-actions">
					<a href="<%=request.getContextPath()%>/admin/index.jsp" class="btn btn-secondary"> <i
						class="fas fa-arrow-left"></i> Back to Login
					</a>
					<button type="submit" class="btn btn-primary">
						Verify Username <i class="fas fa-arrow-right"></i>
					</button>
				</div>
			</form>
			<%
			}
			%>

			<%
			if (step == 2) {
			%>
			<form action="<%=request.getContextPath()%>/forgot-password"
				method="post">
				<input type="hidden" name="step" value="2"> <input
					type="hidden" name="username" value="<%=username%>">

				<div class="user-info">
					<p>
						<i class="fas fa-user-check"></i> Username: <strong><%=username%></strong>
					</p>
					<p class="info-text">Please enter your new password below</p>
				</div>

				<div class="form-group">
					<label><i class="fas fa-key"></i> New Password</label> <input
						type="password" name="newPassword" class="form-control"
						placeholder="Enter new password" required>
				</div>

				<div class="form-group">
					<label><i class="fas fa-key"></i> Confirm Password</label> <input
						type="password" name="confirmPassword" class="form-control"
						placeholder="Confirm new password" required>
				</div>

				<div class="password-rules">
					<p>
						<strong>Password Rules:</strong>
					</p>
					<ul>
						<li>At least 8 characters</li>
						<li>One uppercase letter</li>
						<li>One number</li>
					</ul>
				</div>

				<div class="form-actions">
					<a href="<%=request.getContextPath()%>/forgot-password"
						class="btn btn-secondary"> <i class="fas fa-arrow-left"></i>
						Back
					</a>
					<button type="submit" class="btn btn-primary">
						Reset Password <i class="fas fa-sync-alt"></i>
					</button>
				</div>
			</form>
			<%
			}
			%>

			<%
			if (step == 3) {
			%>
			<div class="success-icon">
				<i class="fas fa-check-circle"></i>
			</div>
			<h3>Password Reset Successful!</h3>
			<p>
				Your password has been successfully reset for username: <strong><%=username%></strong>
			</p>
			<p>You can now login with your new password.</p>
			<div class="success-actions">
				<a href="<%=request.getContextPath()%>/admin/index.jsp"
					class="btn btn-primary"> <i class="fas fa-sign-in-alt"></i> Go
					to Login
				</a>
			</div>
			<%
			}
			%>

			<div class="footer-links">
				<a href="<%=request.getContextPath()%>/admin/index.jsp"><i
					class="fas fa-home"></i> Back to Home</a> | <a href="#"><i
					class="fas fa-question-circle"></i> Need Help?</a>
			</div>
		</div>
	</div>
</body>
</html>
