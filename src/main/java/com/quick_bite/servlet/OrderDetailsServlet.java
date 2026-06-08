

package com.quick_bite.servlet;



import java.io.IOException;

import com.quick_bite.dao.OrderDAO;
import com.quick_bite.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/admin/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;



	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {


			response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=notLoggedIn");
			return;

		}

		int orderId = Integer.parseInt(request.getParameter("orderId"));
		Order order = OrderDAO.getOrderById(orderId);

		request.setAttribute("order", order);
		request.getRequestDispatcher("/admin/dashboard/order-details.jsp").forward(request, response);

	}



}
