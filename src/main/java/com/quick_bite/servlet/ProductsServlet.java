package com.quick_bite.servlet;

import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/products")
public class ProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=notLoggedIn");
            return;
        }

        List<Product> products = ProductDAO.getAllProducts();

        request.setAttribute("products", products);

        request.getRequestDispatcher("/admin/dashboard/products.jsp").forward(request, response);
    }

}
