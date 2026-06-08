package com.quick_bite.servlet;

import java.io.IOException;

import com.quick_bite.dao.AdminDAO;
import com.quick_bite.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    
    	request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
    	return;
    
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath() + "/admin/index.jsp?error=empty"
            );
            return;
        }

        Admin admin = AdminDAO.login(username.trim(), password.trim());

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } else {
            response.sendRedirect(
                request.getContextPath() + "/admin/index.jsp?error=invalid"
            );
        }
    }
}
