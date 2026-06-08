package com.quick_bite.servlet;

import java.io.IOException;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/edit-product")
public class EditProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("id"));

        Product product = ProductDAO.getProductById(productId);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/admin/dashboard/update-foods.jsp").forward(request, response);
    }
    
    
    

}
