<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quick_bite.model.Product, com.quick_bite.model.ProductImage, com.quick_bite.model.Customer, java.util.*" %>

<%
    Customer customer = (Customer) session.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please login first");
        return;
    }
    
    Product product = (Product) request.getAttribute("product");
    Integer orderId = (Integer) request.getAttribute("orderId");
    String paymentStatus = (String) request.getAttribute("paymentStatus");
    Integer deliveryTime = (Integer) request.getAttribute("deliveryTime");
    String productName = (String) request.getAttribute("productName");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title><%= product != null ? product.getProductName() : "Product Details" %> - Quick Bite</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/food-details.css">
    <style>
        .hidden { display: none; }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .error-message i {
            font-size: 20px;
        }
    </style>
</head>
<body>
    <div class="food-detail-page">
        <div class="back-nav">
            <a href="<%=request.getContextPath()%>/home" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Menu
            </a>
        </div>

        <div class="food-detail-container">
            <div class="food-detail-left">
                <div class="food-image-section">
                    <% if (product != null) { 
                        List<ProductImage> images = product.getImages();
                        if (images != null && !images.isEmpty()) {
                            String imagePath = request.getContextPath() + "/uploads/" + images.get(0).getImageName();
                    %>
                        <img src="<%=imagePath%>" alt="<%=product.getProductName()%>" class="food-main-image">
                    <% } else { %>
                        <i class="fas fa-utensils food-main-image"></i>
                    <% }
                    } else { %>
                        <p>Product image not available.</p>
                    <% } %>
                </div>

                <div class="food-info-section">
                    <% if (product != null) { %>
                        <span class="food-category"><%=product.getCategoriesName()%></span>
                        <h1 class="food-title"><%=product.getProductName()%></h1>
                        
                        <div class="food-rating">
                            <div class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                        </div>
                        
                        <div class="food-price">$<%=product.getProductPrice()%></div>
                        
                        <p class="food-description"><%=product.getProductDesc()%></p>
                        
                        <div class="food-ingredients">
                            <h3 class="ingredients-title">Ingredients</h3>
                            <div class="ingredients-list">
                                <span class="ingredient-tag">Beef Patty</span>
                                <span class="ingredient-tag">American Cheese</span>
                                <span class="ingredient-tag">Lettuce</span>
                                <span class="ingredient-tag">Tomato</span>
                                <span class="ingredient-tag">Onions</span>
                                <span class="ingredient-tag">Pickles</span>
                                <span class="ingredient-tag">Sesame Bun</span>
                                <span class="ingredient-tag">Special Sauce</span>
                            </div>
                        </div>
                    <% } else { %>
                        <p class="error">Product details not available.</p>
                    <% } %>
                </div>
            </div>

            <div class="order-section">
                <h2 class="section-title">Your Order</h2>
                
                <!-- Quantity Selector -->
                <div class="quantity-selector">
                    <label class="quantity-label">Quantity</label>
                    <div class="quantity-controls">
                        <button type="button" class="qty-btn" onclick="updateQuantity(-1)">-</button>
                        <span class="qty-display" id="quantity">1</span>
                        <button type="button" class="qty-btn" onclick="updateQuantity(1)">+</button>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="order-summary">
                    <div class="summary-row">
                        <span>Item Total</span>
                        <span id="itemTotal"></span>
                    </div>
                    <div class="summary-row">
                        <span>Extra Toppings</span>
                        <span id="extrasTotal">$0.00</span>
                    </div>
                    <div class="summary-row">
                        <span>Delivery Fee</span>
                        <span>$2.50</span>
                    </div>
                    <div class="summary-row">
                        <span>Tax</span>
                        <span id="taxAmount"></span>
                    </div>
                    <div class="summary-row">
                        <span>Total</span>
                        <span id="grandTotal"></span>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn-buy-now" onclick="showPayment()">
                        <i class="fas fa-bolt"></i> Buy Now
                    </button>
                </div>
            </div>
        </div>

        <!-- Payment Section -->
        <div class="payment-section hidden" id="paymentSection">
            <h2 class="section-title">Complete Your Order</h2>
            
            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%=error%></span>
                </div>
            <% } %>
            
            <!-- Payment Methods -->
            <div class="payment-methods">
                <div class="payment-method selected" onclick="selectPayment('card', event)">
                    <i class="fas fa-credit-card"></i>
                    <p>Credit/Debit Card</p>
                </div>
                
                <div class="payment-method" onclick="selectPayment('paypal', event)">
                    <i class="fab fa-paypal"></i>
                    <p>PayPal</p>
                </div>
                
                <div class="payment-method" onclick="selectPayment('cash', event)">
                    <i class="fas fa-money-bill-wave"></i>
                    <p>Cash on Delivery</p>
                </div>
            </div>

            <!-- Payment Forms -->
            <form action="<%=request.getContextPath()%>/order/payment" method="post" id="orderForm">
                <!-- Hidden Inputs -->
                <input type="hidden" name="product_id" value="<%= product != null ? product.getProductId() : "" %>">
                <input type="hidden" name="payment_method" id="paymentMethod" value="card">
                <input type="hidden" name="quantity" id="quantityInput" value="1">
                <input type="hidden" name="toppings" id="toppingsInput" value="">
                
                <!-- Card Payment Form -->
                <div class="payment-form" id="cardForm">
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <input type="text" name="cardnumber" class="form-input" placeholder="1234 5678 9012 3456" maxlength="19">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" name="exp" class="form-input" placeholder="MM/YY">
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <input type="text" name="cvv" class="form-input" placeholder="123" maxlength="3">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Card Holder Name</label>
                        <input type="text" name="cardHolder" class="form-input" placeholder="steve job">
                    </div>
                </div>
                
                <!-- PayPal Form -->
                <div class="payment-form hidden" id="paypalForm">
                    <p style="text-align: center; color: #666; padding: 20px;">
                        You will be redirected to PayPal to complete your payment.
                    </p>
                </div>
                
                <!-- Cash Form -->
                <div class="payment-form hidden" id="cashForm">
                    <p style="text-align: center; color: #666; padding: 20px;">
                        Pay with cash when your order arrives. Please have exact change ready.
                    </p>
                </div>
                
                <!-- Submit Button -->
                <button type="submit" class="pay-btn">
                    <i class="fas fa-lock"></i> Pay Now - <span id="paymentTotal"></span>
                </button>
            </form>
        </div>

        <!-- Success Message -->
        <% if (orderId != null) { %>
            <div class="success-message">
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2>Order Successful!</h2>
                <p>Your <strong><%= productName != null ? productName : "Order" %></strong> has been placed successfully.</p>
                <p>Order ID: <strong>#ORD<%= orderId %></strong></p>
                <p>Estimated Delivery: <strong><%= deliveryTime != null ? deliveryTime : 30 %> minutes</strong></p>
                <div style="margin-top: 25px;">
                    <button class="btn-buy-now" onclick="window.location.href='<%=request.getContextPath()%>/home'" style="max-width: 200px; margin: 0 auto;">
                        <i class="fas fa-home"></i> Back to Home
                    </button>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        // Global variables
        let quantity = 1;
        const basePrice = <%= product != null ? product.getProductPrice() : 0 %>;
        let extraToppings = [];
        let selectedPayment = 'card';
        
        document.addEventListener('DOMContentLoaded', function() {
            updateTotals();
            selectPayment('card');
            
            <% if (error != null) { %>
                showPayment();
            <% } %>
            
            <% if (orderId != null) { %>
                document.querySelector('.payment-section').classList.add('hidden');
                document.querySelector('.order-section').classList.add('hidden');
            <% } %>
        });
        
        // Quantity functions
        function updateQuantity(change) {
            quantity += change;
            if (quantity < 1) quantity = 1;
            if (quantity > 100) quantity = 100;
            
            document.getElementById('quantity').textContent = quantity;
            document.getElementById('quantityInput').value = quantity;
            updateTotals();
        }
        
        // Toggle extra topping
        function toggleExtra(button) {
            button.classList.toggle('selected');
            const topping = button.textContent;
            
            if (button.classList.contains('selected')) {
                extraToppings.push(topping);
            } else {
                extraToppings = extraToppings.filter(item => item !== topping);
            }
            
            document.getElementById('toppingsInput').value = extraToppings.join(',');
            updateTotals();
        }
        
        // Update totals
        function updateTotals() {
            const itemTotal = basePrice * quantity;
            const extrasTotal = extraToppings.length * 0.50;
            const subtotal = itemTotal + extrasTotal;
            const deliveryFee = 2.50;
            const tax = subtotal * 0.08;
            const grandTotal = subtotal + deliveryFee + tax;
            
            document.getElementById('itemTotal').textContent = '$' + itemTotal.toFixed(2);
            document.getElementById('extrasTotal').textContent = '$' + extrasTotal.toFixed(2);
            document.getElementById('taxAmount').textContent = '$' + tax.toFixed(2);
            document.getElementById('grandTotal').textContent = '$' + grandTotal.toFixed(2);
            document.getElementById('paymentTotal').textContent = '$' + grandTotal.toFixed(2);
        }
        
        // Show payment section
        function showPayment() {
            document.querySelector('.order-section').classList.add('hidden');
            document.getElementById('paymentSection').classList.remove('hidden');
        }
        
        // Select payment method
        function selectPayment(method, event = null) {
            selectedPayment = method;
            
            // Update UI
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            if (event) {
                event.currentTarget.classList.add('selected');
            }
            
            // Show appropriate form
            document.querySelectorAll('.payment-form').forEach(el => {
                el.classList.add('hidden');
            });
            
            if (method === 'card') {
                document.getElementById('cardForm').classList.remove('hidden');
            } else if (method === 'paypal') {
                document.getElementById('paypalForm').classList.remove('hidden');
            } else if (method === 'cash') {
                document.getElementById('cashForm').classList.remove('hidden');
            }
            
            // Update hidden input
            document.getElementById('paymentMethod').value = method;
        }
        
  
    </script>
</body>
</html>