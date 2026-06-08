<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login - Quick Bite</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/customer-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .login-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: #f5f5f5;
        }
        
        .login-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        
        .login-header {
            background: #FF6B35;
            padding: 30px 25px;
            text-align: center;
            color: white;
            border-radius: 12px 12px 0 0;
        }
        
        .login-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 10px;
        }
        
        .login-logo i {
            font-size: 32px;
        }
        
        .login-logo span {
            font-size: 24px;
            font-weight: 700;
        }
        
        .login-logo span span {
            color: #FFD166;
        }
        
        .login-header h1 {
            font-size: 22px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .login-header p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .login-form {
            padding: 30px 25px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 16px;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: border 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #FF6B35;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            padding: 4px;
        }
        
        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .remember {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .remember input {
            accent-color: #FF6B35;
        }
        
        .forgot-link {
            color: #FF6B35;
            text-decoration: none;
        }
        
        .login-btn {
            width: 100%;
            padding: 14px;
            background: #FF6B35;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .login-btn:hover {
            background: #E55A2B;
        }
        
        .divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
            color: #666;
            font-size: 13px;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #ddd;
        }
        
        .divider span {
            background: white;
            padding: 0 15px;
            position: relative;
        }
        
        .signup-link {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #666;
            font-size: 14px;
        }
        
        .signup-link a {
            color: #FF6B35;
            text-decoration: none;
            font-weight: 600;
            margin-left: 5px;
        }
        
        .error-message {
            background: #ffe6e6;
            border: 1px solid #ff9999;
            color: #cc0000;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .success-message {
            background: #e6ffe6;
            border: 1px solid #99ff99;
            color: #006600;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        @media (max-width: 480px) {
            .login-container {
                max-width: 100%;
            }
            
            .login-header {
                padding: 25px 20px;
            }
            
            .login-form {
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-page">
        <div class="login-container">
            <div class="login-header">
                <div class="login-logo">
                    <i class="fas fa-hamburger"></i>
                    <span>Quick<span>Bite</span></span>
                </div>
                <h1>Welcome Back</h1>
                <p>Sign in to your account to continue</p>
            </div>
            
            <div class="login-form">
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    
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
                
                <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" class="form-input" 
                                   placeholder="john@example.com" >
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" class="form-input" 
                                   placeholder="Enter your password" >
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
             
                    
                    <button type="submit" class="login-btn" id="loginBtn">
                        <i class="fas fa-sign-in-alt"></i>
                        Sign In
                    </button>
                </form>
                
                <div class="divider">
                    <span>Don't have an account?</span>
                </div>
                
                <div class="signup-link">
                    New to Quick Bite?
                    <a href="${pageContext.request.contextPath}/signup">Create an account</a>
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
        
        // Form validation
        const form = document.getElementById('loginForm');
        const loginBtn = document.getElementById('loginBtn');
        
        form.addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            
            if (!email || !password) {
                e.preventDefault();
                alert('Please fill in both email and password');
                return;
            }
            
            // Show loading state
            loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing In...';
            loginBtn.disabled = true;
        });
    </script>
</body>
</html>