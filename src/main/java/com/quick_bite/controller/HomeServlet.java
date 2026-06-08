

package com.quick_bite.controller;



import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Customer;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/home")
public class HomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;



	@Override
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

		String category = request.getParameter("category");

		List<Product> products;
		if (category != null && !category.isEmpty()) {
		    products = ProductDAO.getProductsByCategory(category);
		} else {
		    products = ProductDAO.getAllProducts();
		}

		request.setAttribute("products", products);
		request.getRequestDispatcher("/WEB-INF/view/customer/home.jsp").forward(request, response);

	}



}
