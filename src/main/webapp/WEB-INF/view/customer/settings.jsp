<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Settings - Quick Bite</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/profile.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/setting.css">
</head>
<body>
	<div class="settings-container">
		<!-- Header -->
		<div class="settings-header">

			<h1>Account Settings</h1>
			<p class="subtitle">Manage your account preferences and security</p>
		</div>

		<!-- Settings Layout -->
		<div class="settings-layout">
			<!-- Settings Navigation -->
			<div class="settings-nav">
				<a href="<%=request.getContextPath()%>/profile" class="btn-save">
					<i class="fas fa-arrow-left"></i> Back to Menu
				</a>
				<button class="nav-btn active" data-section="account">
					<i class="fas fa-user-cog"></i> Account
				</button>
		
				<button class="nav-btn" data-section="privacy">
					<i class="fas fa-shield-alt"></i> Privacy & Security
				</button>



			</div>

			<!-- Settings Content -->
			<div class="settings-content">
				<!-- Account Section -->
				<div class="settings-section active" id="account-section">
					<h2>
						<i class="fas fa-user-cog"></i> Account Settings
					</h2>
					<%
					String error = (String) request.getAttribute("error");
					String success = (String) request.getAttribute("success");
					%>

					<%
					if (error != null) {
					%>
					<div class="alert alert-error">
						<i class="fas fa-exclamation-circle"></i>
						<%=error%>
					</div>
					<%
					}
					%>

					<%
					if (success != null) {
					%>
					<div class="alert alert-success">
						<i class="fas fa-check-circle"></i>
						<%=success%>
					</div>
					<%
					}
					%>

					<form class="settings-form" id="accountForm"
						action="<%=request.getContextPath()%>/settings" method="post">
						<input type="hidden" name="type" value="profile">
						<div class="form-row">
							<div class="form-group">
								<label>full name</label> <input type="text" name="fullname"
									value="${customer.fullName}" class="form-control">
							</div>
						</div>

						<div class="form-group">
							<label>Address</label> <input type="text" name="address"
								value="${customer.address}" class="form-control">
						</div>


						<div class="form-group">
							<label>Phone Number</label><input type="tel" name="phone"
								value="${customer.phone}" class="form-control">
						</div>

						<div class="form-actions">
							<button type="submit" class="btn-cancel"
								onclick="resetForm('accountForm')">Cancel</button>
							<button type="submit" class="btn-save">Save Changes</button>
						</div>
					</form>

					<div class="danger-zone">
						<h3>
							<i class="fas fa-exclamation-triangle"></i> Danger Zone
						</h3>
						<div class="danger-actions">


							
							<div class="danger-actions">
								<form action="<%=request.getContextPath()%>/settings"
									method="post"
									onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone!');">
									<input type="hidden" name="type" value="deleteAccount">
									<button type="submit" class="btn-danger">
										<i class="fas fa-trash-alt"></i> Delete Account
									</button>
								</form>
							</div>
						</div>
					</div>
				</div>

			

				<!-- Privacy & Security Section -->
				<div class="settings-section" id="privacy-section">
					<h2>
						<i class="fas fa-shield-alt"></i> Privacy & Security
					</h2>

					<form id="securityForm">
						<div class="security-card">
							<h3>Password</h3>
							<button type="button" class="btn-change"
								onclick="changePassword()">
								<i class="fas fa-key"></i> Change Password
							</button>
						</div>




					</form>
				</div>






				<!-- Change Password Modal -->
				<div class="modal-overlay" id="passwordModal">
					<div class="modal-content">
						<div class="modal-header">
							<h3>Change Password</h3>
							<button class="modal-close" onclick="closePasswordModal()">
								<i class="fas fa-times"></i>
							</button>
						</div>


						<div class="modal-body">

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



							<form action="<%=request.getContextPath()%>/settings"
								class="settings-form" id="passwordForm" method="post">



								<input type="hidden" name="type" value="password">

								<div class="form-group">
									<label>Current Password</label> <input type="password"
										name="currentPassword" class="form-control" required>
								</div>

								<div class="form-group">
									<label>New Password</label> <input type="password"
										name="newPassword" class="form-control" required>
								</div>

								<div class="form-group">
									<label>Confirm New Password</label> <input type="password"
										name="confirmPassword" class="form-control" required>
								</div>

								<div class="password-strength">
									<div class="strength-bar">
										<div class="strength-fill" style="width: 60%"></div>
									</div>
									<span class="strength-text">Medium</span>
								</div>

								<ul class="password-hints">
									<li>At least 8 characters</li>
									<li>Include uppercase letters</li>
									<li>Include numbers</li>
									<li>Include special characters</li>
								</ul>


								<div class="modal-footer">
									<button class="btn-cancel" onclick="closePasswordModal()">Cancel</button>
									<button type="submit" class="btn-save">Change Password</button>
								</div>
							</form>
						</div>


					</div>
				</div>

				<script>
        // Initialize navigation when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Set up section switching
            document.querySelectorAll('.nav-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const section = this.getAttribute('data-section');
                    showSection(section);
                });
            });

            // Set up toggle switches
            document.querySelectorAll('.toggle-switch input').forEach(toggle => {
                toggle.addEventListener('change', function() {
                    const parent = this.closest('label');
                    if (this.checked) {
                        parent.classList.add('active');
                    } else {
                        parent.classList.remove('active');
                    }
                });
            });

            // Close modals on overlay click
            const passwordModal = document.getElementById('passwordModal');
            if (passwordModal) {
                passwordModal.addEventListener('click', function(e) {
                    if (e.target === this) {
                        closePasswordModal();
                    }
                });
            }

            // Initialize form submit handlers
            const accountForm = document.getElementById('accountForm');
            if (accountForm) {
                e.preventDefault();

            }
        });

        // Navigation function
function showSection(section) {
    // Hide all sections
    document.querySelectorAll('.settings-section').forEach(el => {
        el.classList.remove('active');
    });

    // Remove active class from all nav buttons
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
    });

    // Show selected section
    const targetSection = document.getElementById(section + '-section');
    if (targetSection) {
        targetSection.classList.add('active');
    }

    // Activate correct nav button using data-section
    document.querySelectorAll('.nav-btn').forEach(btn => {
        if (btn.getAttribute('data-section') === section) {
            btn.classList.add('active');
        }
    });
}

        
        

        
 
        
    
        
        // Modal Functions
        function changePassword() {
            const modal = document.getElementById('passwordModal');
            if (modal) modal.style.display = 'flex';
        }
        
        function closePasswordModal() {
            const modal = document.getElementById('passwordModal');
            if (modal) modal.style.display = 'none';
            
          
        }
        
      
        
   

        
     
        
       
        

    </script>
</body>
</html>