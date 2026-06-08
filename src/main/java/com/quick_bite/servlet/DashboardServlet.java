package com.quick_bite.servlet;

import java.io.IOException;
import java.util.List;

import com.quick_bite.dao.OrderDAO;
import com.quick_bite.dao.PaymentDAO;
import com.quick_bite.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.quick_bite.dao.ProductDAO;

@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
            return;
        }

        int totalOrders = OrderDAO.getTotalOrdersToday();
        int pendingOrders = OrderDAO.getPendingOrder();
        int deliveryOrders = OrderDAO.getDeliveryOrdersToday();
        int pickupOrders = OrderDAO.getPickupOrdersToday();
        int preparingOrders = OrderDAO.getPreparingOrder();
        int totalProducts = ProductDAO.getTotalProducts();

        double totalRevenue = PaymentDAO.getTotalRevenueToday();
        double avgOrderValue = PaymentDAO.getAverageOrderValueToday();

        List<Order> recentOrders = OrderDAO.getAllOrders();
        if (recentOrders.size() > 10) {
            recentOrders = recentOrders.subList(0, 10);
        }

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalProducts", totalProducts);

        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("deliveryOrders", deliveryOrders);
        request.setAttribute("pickupOrders", pickupOrders);
        request.setAttribute("preparingOrders", preparingOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("avgOrderValue", avgOrderValue);
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/admin/dashboard/dashboard.jsp").forward(request, response);
    }
}
