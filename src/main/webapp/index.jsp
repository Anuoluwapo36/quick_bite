<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Quick Bite - Fast Food Delivery</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/landing.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="landing-page">
        <!-- Hero Section -->
        <section class="landing-hero">
            <div class="hero-overlay"></div>
            <nav class="landing-nav">
                <div class="nav-container">
                    <div class="brand">
                        <i class="fas fa-hamburger"></i>
                        <span class="brand-name">Quick<span>Bite</span></span>
                    </div>
                    <div class="nav-actions">
                        <a href="<%=request.getContextPath()%>/login" class="nav-btn">Login</a>
                        <a href="<%=request.getContextPath()%>/signup" class="nav-btn primary"> register account</a>
                         <a href="<%=request.getContextPath()%>/adminLogin" class="nav-btn primary"> Admin Dashboard</a>
                    </div>
                </div>
            </nav>
            
            <div class="hero-content">
                <h1 class="hero-title">Craving Something <span class="highlight">Delicious?</span></h1>
                <p class="hero-subtitle">Get your favorite fast food delivered hot and fresh in minutes</p>
                <div class="hero-cta">
                    <a href="signup.jsp" class="cta-btn">
                        <i class="fas fa-bolt"></i>
                        Order in 30 Minutes
                    </a>
                    <a href="#features" class="cta-btn outline">
                        <i class="fas fa-play-circle"></i>
                        See How It Works
                    </a>
                </div>
            </div>
            
            <div class="scroll-indicator">
                <i class="fas fa-chevron-down"></i>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section" id="features">
            <div class="container">
                <h2 class="section-title">Why Choose Quick Bite?</h2>
                <p class="section-subtitle">Experience fast food delivery like never before</p>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3>Fast Delivery</h3>
                        <p>Get your food delivered in 30 minutes or less, guaranteed</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-fire"></i>
                        </div>
                        <h3>Hot & Fresh</h3>
                        <p>Food arrives hot and fresh, just like from the restaurant</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>Safe Delivery</h3>
                        <p>Contactless delivery with strict hygiene standards</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-tags"></i>
                        </div>
                        <h3>Best Prices</h3>
                        <p>Great food at affordable prices with regular discounts</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- App Download -->
        <section class="app-section">
            <div class="container">
                <div class="app-content">
                    <div class="app-info">
                        <h2>Get the Quick Bite App</h2>
                        <p>Order faster, track your delivery, and get exclusive app-only deals</p>
                        <div class="app-buttons">
                            <a href="#" class="app-btn">
                                <i class="fab fa-apple"></i>
                                <div>
                                    <small>Download on the</small>
                                    <span>App Store</span>
                                </div>
                            </a>
                            <a href="#" class="app-btn">
                                <i class="fab fa-google-play"></i>
                                <div>
                                    <small>Get it on</small>
                                    <span>Google Play</span>
                                </div>
                            </a>
                        </div>
                    </div>
                    <div class="app-image">
                        <div class="phone-mockup">
                            <div class="phone-screen">
                                <div class="screen-content">
                                    <i class="fas fa-hamburger"></i>
                                    <h4>Quick Bite</h4>
                                    <p>Order in progress...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="landing-footer">
            <div class="container">
                <div class="footer-grid">
                    <div class="footer-col">
                        <div class="brand">
                            <i class="fas fa-hamburger"></i>
                            <span class="brand-name">Quick<span>Bite</span></span>
                        </div>
                        <p>Fast food delivered fast.<br> Satisfaction guaranteed.</p>
                    </div>
                    
                    <div class="footer-col">
                        <h4>Quick Links</h4>
                        <a href="<%=request.getContextPath()%>/login">Login</a>
                        <a href="<%=request.getContextPath()%>/signup">Sign Up</a>
                        <a href="#features">How It Works</a>
                        <a href="#">Contact Us</a>
                    </div>
                    
                    <div class="footer-col">
                        <h4>Contact</h4>
                        <p><i class="fas fa-phone"></i> +1 (555) 123-4567</p>
                        <p><i class="fas fa-envelope"></i> hello@quickbite.com</p>
                        <p><i class="fas fa-map-marker-alt"></i> 123 Food Street, NY</p>
                    </div>
                    
                    <div class="footer-col">
                        <h4>Follow Us</h4>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="footer-bottom">
                    <p>&copy; 2024 Quick Bite. All rights reserved.</p>
                    <div class="footer-links">
                        <a href="#">Privacy Policy</a>
                        <a href="#">Terms of Service</a>
                        <a href="#">Cookie Policy</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</body>
</html>