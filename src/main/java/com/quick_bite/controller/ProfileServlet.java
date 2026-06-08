package com.quick_bite.controller;

import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.ActivityDAO;
import com.quick_bite.model.Activity;
import com.quick_bite.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

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

        List<Activity> activities = ActivityDAO.getRecentActivities(customer.getCustomerId());

        request.setAttribute("activities", activities);

        request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
    }
}
