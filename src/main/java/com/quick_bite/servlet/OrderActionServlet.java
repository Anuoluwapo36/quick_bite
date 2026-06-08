package com.quick_bite.servlet;

import com.quick_bite.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/orderAction")
public class OrderActionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");

                boolean updated = OrderDAO.updateOrderStatus(orderId, status);

                if (updated) {
                    out.print("{\"success\":true}");
                } else {
                    out.print("{\"success\":false}");
                }

            } catch (Exception e) {
                e.printStackTrace();
                out.print("{\"success\":false}");
            }
        } else {
            out.print("{\"success\":false}");
        }

        out.flush();
        out.close();
    }
}
