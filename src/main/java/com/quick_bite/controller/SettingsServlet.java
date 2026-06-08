

package com.quick_bite.controller;



import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.CustomerDAO;
import com.quick_bite.dao.OrderDAO;
import com.quick_bite.model.Customer;
import com.quick_bite.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;



	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Customer customer = (Customer) session.getAttribute("customer");

		if (customer == null) {


			request.setAttribute("error", "Please login first");
			request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
			return;

		}

		List<Order> orders = OrderDAO.getPaidOrdersByCustomerId(customer.getCustomerId());
		request.setAttribute("orders", orders);
		request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);

	}



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

		String type = request.getParameter("type");

		if ("password".equals(type)) {


			handlePasswordUpdate(request, response, customer);

		} else if ("profile".equals(type)) {


			handleProfileUpdate(request, response, customer);

		} else if ("deleteAccount".equals(type)) {


			handleDeleteAccount(request, response, customer);

		}

		else {


			request.setAttribute("error", "Invalid request type");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);

		}

	}



	private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response, Customer customer)
			throws IOException, ServletException {

		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		if (currentPassword == null || currentPassword.isEmpty() || newPassword == null || newPassword.isEmpty()
				|| confirmPassword == null || confirmPassword.isEmpty()) {


			request.setAttribute("error", "All password fields are required");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);
			return;

		}

		if (!CustomerDAO.checkPassword(customer.getCustomerId(), currentPassword)) {


			request.setAttribute("error", "Current password is incorrect");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);
			return;

		}

		if (!newPassword.equals(confirmPassword)) {


			request.setAttribute("error", "New password and confirmation do not match");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);
			return;

		}

		if (!newPassword.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$")) {


			request.setAttribute("error",
					"Password must be at least 8 characters, include an uppercase letter and a number");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);
			return;

		}

		boolean updated = CustomerDAO.updatePassword(customer.getCustomerId(), newPassword);

		if (updated) {


			request.setAttribute("success", "Password updated successfully");

		} else {


			request.setAttribute("error", "Failed to update password");

		}

		request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);

	}



	private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, Customer customer)
			throws IOException, ServletException {

		String fullName = request.getParameter("fullname");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		if (fullName == null || fullName.isEmpty() || phone == null || phone.isEmpty() || address == null
				|| address.isEmpty()) {


			request.setAttribute("error", "All fields are required");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);
			return;

		}

		boolean updated = CustomerDAO.updateCustomerProfile(customer.getCustomerId(), fullName, phone, address);

		if (updated) {


			customer.setFullName(fullName);
			customer.setPhone(phone);
			customer.setAddress(address);
			request.getSession().setAttribute("customer", customer);

			request.setAttribute("success", "Profile updated successfully");

		} else {


			request.setAttribute("error", "Failed to update profile");

		}

		request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);

	}



	private void handleDeleteAccount(HttpServletRequest request, HttpServletResponse response, Customer customer)
			throws IOException, ServletException {

		boolean deleted = CustomerDAO.deleteCustomer(customer.getCustomerId());

		if (deleted) {


			request.getSession().invalidate();
			request.setAttribute("success", "Account deleted successfully. We're sorry to see you go!");
			request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);

		} else {


			request.setAttribute("error", "Failed to delete account. Please try again later.");
			request.getRequestDispatcher("/WEB-INF/view/customer/settings.jsp").forward(request, response);

		}

	}



}