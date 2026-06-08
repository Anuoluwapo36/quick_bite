

package com.quick_bite.controller;



import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.OrderDAO;
import com.quick_bite.model.Customer;
import com.quick_bite.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/orders")
public class OrderHistoryServlet extends HttpServlet {

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
		    request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp")
		           .forward(request, response);
		    return;
		}


		
		List<Order> orders = OrderDAO.getPaidOrdersByCustomerId(customer.getCustomerId());
		request.setAttribute("orders", orders);
		request.getRequestDispatcher("/WEB-INF/view/customer/order-history.jsp").forward(request, response);

	}



}
