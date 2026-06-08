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

@WebServlet("/admin/orders/view")
public class OrderViewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        Order order = OrderDAO.getOrderById(orderId);

        if (order == null) {
            request.setAttribute("error", "Order not found");
            request.getRequestDispatcher("/admin/dashboard/dashboard.jsp").forward(request, response);
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/admin/dashboard/order-view.jsp").forward(request, response);
    }
}
