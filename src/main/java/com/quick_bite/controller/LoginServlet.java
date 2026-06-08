package com.quick_bite.controller;

import com.quick_bite.dao.CustomerDAO;
import com.quick_bite.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Please enter both email and password.");
            request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
            return;
        }

        Customer customer = CustomerDAO.getCustomerByEmail(email);

        if (customer == null) {
            request.setAttribute("error", "No account found with this email or the account has been deleted.");
            request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
            return;
        }

        if (customer.isDeleted()) {
            request.setAttribute("error", "This account has been deleted. Contact support if this is a mistake.");
            request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
            return;
        }

        if (!customer.getPassword().equals(password)) {
            request.setAttribute("error", "Incorrect password.");
            request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("customer", customer);
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
