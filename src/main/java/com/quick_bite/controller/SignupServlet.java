

package com.quick_bite.controller;



import java.io.IOException;
import java.util.regex.Pattern;

import com.quick_bite.dao.CustomerDAO;
import com.quick_bite.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.-]+@[\\w.-]+\\.\\w+$");



	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);

	}



	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");

		if (email == null || email.trim().isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {


			request.setAttribute("error", "Please enter a valid email address.");
			request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);
			return;

		}

		if (password == null || password.trim().length() < 6) {


			request.setAttribute("error", "Password must be at least 6 characters.");
			request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);
			return;

		}

		if (!password.equals(confirmPassword)) {


			request.setAttribute("error", "Passwords do not match.");
			request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);
			return;

		}

		if (CustomerDAO.getCustomerByEmail(email) != null) {


			request.setAttribute("error", "Email is already registered.");
			request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);
			return;

		}

		Customer customer = new Customer();
		customer.setEmail(email);
		customer.setPassword(password);

		boolean created = CustomerDAO.createCustomer(customer);

		if (created) {


			HttpSession session = request.getSession();
			session.setAttribute("customer", customer);
			request.setAttribute("message", "Account created successfully! Please login.");
			request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);

		} else {


			request.setAttribute("error", "Failed to create account. Please try again.");
			request.getRequestDispatcher("/WEB-INF/view/customer/signup.jsp").forward(request, response);

		}

	}



}
