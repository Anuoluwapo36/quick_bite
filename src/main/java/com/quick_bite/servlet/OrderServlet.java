package com.quick_bite.servlet;

import com.quick_bite.dao.OrderDAO;
import com.quick_bite.dao.PaymentDAO;
import com.quick_bite.model.Admin;
import com.quick_bite.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession();
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
            return;
        }

        // Fetch all orders
        List<Order> orders = OrderDAO.getAllOrders();

        // Order stats
        int totalOrders = OrderDAO.getTotalOrdersToday();
        int deliveryOrders = OrderDAO.getDeliveryOrdersToday();
        int pickupOrders = OrderDAO.getPickupOrdersToday();
        int pendingOrder = OrderDAO.getPendingOrder();
        int preparingOrder = OrderDAO.getPreparingOrder();

        // Payment stats
        double totalRevenue = PaymentDAO.getTotalRevenueToday();
        double avgOrderValue = PaymentDAO.getAverageOrderValueToday();
        int completedToday = PaymentDAO.getCompletedOrdersToday();

        // Attach data to request
        request.setAttribute("orders", orders);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("deliveryOrders", deliveryOrders);
        request.setAttribute("pickupOrders", pickupOrders);
        request.setAttribute("pendingOrder", pendingOrder);
        request.setAttribute("preparingOrder", preparingOrder);

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("avgOrderValue", avgOrderValue);
        request.setAttribute("completedToday", completedToday);

        
        request.getRequestDispatcher("/admin/dashboard/order.jsp").forward(request, response);
    }
}
