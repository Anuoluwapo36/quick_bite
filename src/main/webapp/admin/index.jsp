<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>QuitBite - Admin Login</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/admin/css/login.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
	<div class="login-container">
		<div class="login-box">
			<h1>
				<i class="fas fa-hamburger"></i> QuitBite Admin
			</h1>
			<p class="subtitle">Fast Food Management System</p>
			<%
			String error = request.getParameter("error");

			if ("empty".equals(error)) {
			%>
			<p style="color: red;">Username and password required</p>
			<%
			} else if ("invalid".equals(error)) {
			%>
			<p style="color: red;">Invalid credentials</p>
			<%
			}
			%>


			<%
			String message = request.getParameter("message");

			if (message != null) {
			%>
			<div
				style="background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 10px;">
				<i class="fas fa-check-circle"></i>
				<%=message%>
			</div>
			<%
			}
			%>


			<form action="<%=request.getContextPath()%>/adminLogin" method="post">
				<div class="form-group">
					<label for="username"><i class="fas fa-user"></i> Username</label>
					<input type="text" id="username" name="username"
						class="form-control" placeholder="Enter username">
				</div>

				<div class="form-group">
					<label for="password"><i class="fas fa-lock"></i> Password</label>
					<input type="password" id="password" name="password"
						class="form-control" placeholder="Enter password">
				</div>

				<div class="form-group">
					<button type="submit" class="btn btn-primary">
						<i class="fas fa-sign-in-alt"></i> Login
					</button>
				</div>

				<div class="text-center">
					<a href="<%=request.getContextPath()%>/forgotpassword.jsp" style="color: var(--primary);">Forgot Password?</a>
				</div>
			</form>


		</div>
	</div>
</body>
</html>