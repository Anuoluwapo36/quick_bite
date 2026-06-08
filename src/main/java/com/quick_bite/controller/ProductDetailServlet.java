

package com.quick_bite.controller;



import java.io.IOException;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Customer;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/quick_bite/food/view")
public class ProductDetailServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;



	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Customer customer = (Customer) session.getAttribute("customer");

		if (customer == null) {


			request.setAttribute("error", "Please login first");
			request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
			return;

		}

		String strId = request.getParameter("id");

		if (strId == null) {


			response.sendRedirect("home.jsp");
			return;

		}

		try {


			int productId = Integer.parseInt(strId);
			Product product = ProductDAO.getProductById(productId);

			if (product == null) {


				response.sendRedirect("home.jsp");
				return;

			}

			request.setAttribute("product", product);
			request.getRequestDispatcher("/WEB-INF/view/customer/food-detail.jsp").forward(request, response);

		} catch (NumberFormatException e) {


			response.sendRedirect("dashboard.jsp");

		}

	}



}
