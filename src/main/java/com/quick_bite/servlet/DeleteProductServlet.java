package com.quick_bite.servlet;

import java.io.IOException;

import com.quick_bite.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/deleteProduct")
public class DeleteProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=notLoggedIn");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("id"));

        boolean deleted = ProductDAO.deleteProduct(productId);

        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/products?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products?msg=error");
        }
    }
}
