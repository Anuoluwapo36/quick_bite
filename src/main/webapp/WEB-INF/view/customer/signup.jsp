<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Sign Up - Quick Bite</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet"
	href="${pageContext.request.contextPath}/admin/css/signup.css">

</head>
<body>
    <div class="signup-page">
        <div class="signup-container">
            <div class="signup-header">
                <div class="signup-logo">
                    <i class="fas fa-hamburger"></i>
                    <span>Quick<span>Bite</span></span>
                </div>
                <h1>Create Account</h1>
                <p>Join thousands enjoying delicious fast food delivery</p>
            </div>
            
            <div class="signup-form">
                <!-- Display errors if any -->
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    String email = request.getParameter("email");
                    
                    if (error != null) {
                %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
                <% } %>
                
                <% if (success != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <%= success %>
                </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/signup" method="post" id="signupForm">
         
                    
                    <div class="input-group">
                        <label for="email">Email Address</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" class="form-input" 
                                   value="<%= email != null ? email : "" %>" 
                                   placeholder="john@example.com" >
                        </div>
                    </div>
                    
         
                    
                    <div class="input-group">
                        <label for="password">Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" class="form-input" 
                                   placeholder="Create a strong password" >
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-meter">
                                <div class="strength-fill" id="strengthFill"></div>
                            </div>
                            <div class="strength-text" id="strengthText">Password strength: Weak</div>
                        </div>
                    </div>
                    
                    <div class="input-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" 
                                   placeholder="Confirm your password" >
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" style="color: #EF476F; font-size: 14px; margin-top: 5px; display: none;">
                            <i class="fas fa-times-circle"></i> Passwords do not match
                        </div>
                    </div>
                    
          
                    
                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">
                            I agree to the <a href="#">Terms & Conditions</a> and 
                            <a href="#">Privacy Policy</a>. I confirm that I am at least 18 years old.
                        </label>
                    </div>
                    
                    <button type="submit" class="signup-btn" id="submitBtn">
                        <i class="fas fa-user-plus"></i>
                        Create Account
                    </button>
                </form>
                
                <div class="login-link">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login">Login here</a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Password toggle visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                field.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }
        
        // Password strength checker
        const passwordField = document.getElementById('password');
        const strengthFill = document.getElementById('strengthFill');
        const strengthText = document.getElementById('strengthText');
        const strengthMeter = document.getElementById('passwordStrength');
        
        passwordField.addEventListener('input', function() {
            const password = this.value;
            
            if (password.length === 0) {
                strengthMeter.style.display = 'none';
                return;
            }
            
            strengthMeter.style.display = 'block';
            
            let strength = 0;
            
            // Length check
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            
            // Complexity checks
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            const percentage = (strength / 5) * 100;
            strengthFill.style.width = percentage + '%';
            
            // Set color and text based on strength
            if (strength <= 2) {
                strengthFill.style.background = '#EF476F';
                strengthText.textContent = 'Password strength: Weak';
                strengthText.style.color = '#EF476F';
            } else if (strength <= 4) {
                strengthFill.style.background = '#FFD166';
                strengthText.textContent = 'Password strength: Good';
                strengthText.style.color = '#FFD166';
            } else {
                strengthFill.style.background = '#06D6A0';
                strengthText.textContent = 'Password strength: Strong';
                strengthText.style.color = '#06D6A0';
            }
        });
        
        // Password match checker
        const confirmField = document.getElementById('confirmPassword');
        const matchDiv = document.getElementById('passwordMatch');
        const submitBtn = document.getElementById('submitBtn');
        
        confirmField.addEventListener('input', function() {
            const password = passwordField.value;
            const confirm = this.value;
            
            if (confirm.length === 0) {
                matchDiv.style.display = 'none';
                submitBtn.disabled = false;
                return;
            }
            
            if (password !== confirm) {
                matchDiv.style.display = 'block';
                submitBtn.disabled = true;
            } else {
                matchDiv.style.display = 'none';
                submitBtn.disabled = false;
            }
        });
        
        // Form validation
        const form = document.getElementById('signupForm');
        form.addEventListener('submit', function(e) {
            const password = passwordField.value;
            const confirm = confirmField.value;
            
            // Check password match
            if (password !== confirm) {
                e.preventDefault();
                alert('Passwords do not match!');
                return;
            }
            
            // Check password strength
            if (password.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long!');
                return;
            }
            
            // Check terms agreement
            if (!document.getElementById('terms').checked) {
                e.preventDefault();
                alert('You must agree to the Terms & Conditions and Privacy Policy!');
                return;
            }
            
            // Show loading state
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
            submitBtn.disabled = true;
        });
        
        // Social signup (simulated)
        function socialSignup(provider) {
            alert('Signing up with ' + provider + '... (This is a demo)');
            // In real app, redirect to OAuth endpoint
        }
    </script>
</body>
</html>