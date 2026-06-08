

package com.quick_bite.controller;



import java.io.IOException;
import java.util.UUID;

import com.quick_bite.dao.OrderDAO;
import com.quick_bite.dao.PaymentDAO;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Customer;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/order/payment")
public class PlaceOrderServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;



	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Customer customer = (Customer) session.getAttribute("customer");

		if (customer == null) {


			request.setAttribute("error", "Please login first");
			request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
			return;

		}

		try {


			String productIdStr = request.getParameter("product_id");
			String quantityStr = request.getParameter("quantity");

			if (productIdStr == null || quantityStr == null) {
			    request.setAttribute("error", "Invalid order request. Please try again.");
			    request.getRequestDispatcher("/WEB-INF/view/customer/home.jsp").forward(request, response);
			    return;
			}

			int productId = Integer.parseInt(productIdStr);
			int quantity = Integer.parseInt(quantityStr);

			String toppings = request.getParameter("toppings");
			String paymentMethod = request.getParameter("payment_method");

			String customerName = customer.getFullName();
			String customerPhone = customer.getPhone();
			String customerEmail = customer.getEmail();
			String customerAddress = customer.getAddress();

			if (customer.getFullName() == null || customer.getFullName().isBlank() ||
				    customer.getPhone() == null || customer.getPhone().isBlank() ||
				    customer.getAddress() == null || customer.getAddress().isBlank()) {

				    request.setAttribute("error", "Please complete your profile before placing an order.");
				    forwardBack(request, response, productId);
				    return;
				}
			if ("card".equalsIgnoreCase(paymentMethod)) {


				String cardNumber = request.getParameter("cardnumber");
				String exp = request.getParameter("exp");
				String cvv = request.getParameter("cvv");
				String cardHolder = request.getParameter("cardHolder");

				if (cardNumber == null || !cardNumber.matches("\\d{16}")) {


					request.setAttribute("error", "Invalid card number");
					forwardBack(request, response, productId);
					return;

				}

				if (exp == null || !exp.matches("(0[1-9]|1[0-2])/\\d{2}")) {


					request.setAttribute("error", "Invalid expiry date");
					forwardBack(request, response, productId);
					return;

				}

				if (cvv == null || !cvv.matches("\\d{3}")) {


					request.setAttribute("error", "Invalid CVV");
					forwardBack(request, response, productId);
					return;

				}

				if (cardHolder == null || cardHolder.trim().length() < 3) {


					request.setAttribute("error", "Invalid card holder name");
					forwardBack(request, response, productId);
					return;

				}

			}

			Product product = ProductDAO.getProductById(productId);
			if (product == null) {
			    request.setAttribute("error", "Product not found.");
			    request.getRequestDispatcher("/WEB-INF/view/customer/home.jsp").forward(request, response);
			    return;
			}
			double basePrice = product.getProductPrice();

			int extrasCount = (toppings == null || toppings.isEmpty()) ? 0 : toppings.split(",").length;

			double extrasPrice = extrasCount * 0.50;
			double itemTotal = (basePrice + extrasPrice) * quantity;
			double deliveryFee = 2.50;
			double tax = itemTotal * 0.08;
			double totalAmount = itemTotal + deliveryFee + tax;

			int orderId = OrderDAO.createOrder(customerName, customerPhone, customerEmail, customerAddress,
					totalAmount);

			if (orderId <= 0) {


				request.setAttribute("error", "Failed to create order. Please try again.");
				forwardBack(request, response, productId);
				return;

			}

			OrderDAO.addOrderItem(orderId, productId, quantity, basePrice + extrasPrice);

			String paymentStatus = paymentMethod.equals("card") ? "PAID" : "PENDING";
			String transactionId = UUID.randomUUID().toString();
			boolean paymentCreated = PaymentDAO.createPayment(orderId, totalAmount, paymentMethod, paymentStatus,
					transactionId);

			if (!paymentCreated) {


				request.setAttribute("error", "Failed to create payment. Please try again.");
				forwardBack(request, response, productId);
				return;

			}
		

			request.setAttribute("product", product);
			  request.setAttribute("orderSuccess", true); 
			    request.setAttribute("orderId", orderId);
			    request.setAttribute("paymentStatus", paymentStatus);
			    request.setAttribute("deliveryTime", 30);
			    request.setAttribute("productName", product.getProductName());

			request.getRequestDispatcher("/WEB-INF/view/customer/food-detail.jsp").forward(request, response);

		} catch (Exception e) {
		    e.printStackTrace();
		    request.setAttribute("orderSuccess", false); 
		    request.setAttribute("errorMessage", "Failed to place order. Please try again.");

		    String productIdStr = request.getParameter("product_id");
		    if (productIdStr != null) {
		        try {
		            int productId = Integer.parseInt(productIdStr);
		            Product product = ProductDAO.getProductById(productId);
		            request.setAttribute("product", product);
		        } catch (NumberFormatException ex) {
		        }
		    }

		    request.setAttribute("error", "Something went wrong. Please try again.");
		    request.getRequestDispatcher("/WEB-INF/view/customer/food-detail.jsp").forward(request, response);
		}


	}



	private void forwardBack(HttpServletRequest request, HttpServletResponse response, int productId) throws Exception {

		Product product = ProductDAO.getProductById(productId);
		request.setAttribute("product", product);
		request.setAttribute("productName", product.getProductName());

		request.getRequestDispatcher("/WEB-INF/view/customer/food-detail.jsp").forward(request, response);

	}



}
