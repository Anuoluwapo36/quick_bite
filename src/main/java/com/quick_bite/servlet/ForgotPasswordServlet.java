package com.quick_bite.servlet;

import java.io.IOException;

import com.quick_bite.dao.AdminDAO;
import com.quick_bite.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String step = request.getParameter("step");

        if ("1".equals(step)) {
            String username = request.getParameter("username").trim();

            if (username == null || username.isEmpty()) {
                request.setAttribute("error", "Username cannot be empty");
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            Admin admin = AdminDAO.getAdminByUsername(username);
            if (admin == null) {
                request.setAttribute("error", "Username not found");
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            request.setAttribute("username", username);
            request.setAttribute("step", 2);
            request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);

        } else if ("2".equals(step)) {
            String username = request.getParameter("username");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (username == null || username.isEmpty()) {
                request.setAttribute("error", "Invalid session, please start again");
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.setAttribute("username", username);
                request.setAttribute("step", 2);
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() < 8 || !newPassword.matches(".*[A-Z].*") || !newPassword.matches(".*[0-9].*")) {
                request.setAttribute("error", "Password must be at least 8 characters, contain one uppercase and one number");
                request.setAttribute("username", username);
                request.setAttribute("step", 2);
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
                return;
            }

            boolean updated = AdminDAO.updatePassword(username, newPassword);

            if (updated) {
                request.setAttribute("username", username);
                request.setAttribute("step", 3);
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to reset password. Try again.");
                request.setAttribute("username", username);
                request.setAttribute("step", 2);
                request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("step", 1);
            request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("step", 1);
        request.getRequestDispatcher("/forgotpassword.jsp").forward(request, response);
    }
}
