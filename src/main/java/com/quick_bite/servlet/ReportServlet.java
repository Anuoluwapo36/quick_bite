

package com.quick_bite.servlet;



import java.io.IOException;

import com.quick_bite.dao.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;




@WebServlet("/admin/dashboard/report")
public class ReportServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;



	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {


			response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=loginRequired");
			return;

		}

		request.setAttribute("totalRevenue", ReportDAO.getTotalRevenue());
		request.setAttribute("totalOrders", ReportDAO.getTotalOrders());
		request.setAttribute("newCustomers", ReportDAO.getNewCustomers());
		request.setAttribute("cancellationRate", ReportDAO.getCancellationRate());
		request.setAttribute("revenuePerDay", ReportDAO.getRevenuePerDay());
		
		
		
		request.setAttribute("topProducts", ReportDAO.getTopSellingProducts());
		request.setAttribute("dailySales", ReportDAO.getWeeklySalesReport());
		request.setAttribute("peakHours", ReportDAO.getPeakHours());




		request.getRequestDispatcher("/admin/dashboard/reports.jsp").forward(request, response);

	}



}
