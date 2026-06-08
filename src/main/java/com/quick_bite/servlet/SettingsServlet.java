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

@WebServlet("/admin/settings")
public class SettingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
            return;
        }

        request.getRequestDispatcher("/admin/dashboard/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=please login first");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");

        String formType = request.getParameter("formType");

        if ("general".equals(formType)) {
            String adminName = request.getParameter("adminName");
            String adminEmail = request.getParameter("adminEmail");

            if (adminName == null || adminName.trim().isEmpty()) {
                request.setAttribute("error", "Admin name is required");
            } else if (adminEmail == null || !adminEmail.matches(".+@.+\\..+")) {
                request.setAttribute("error", "Invalid admin email");
            } else {
                admin.setAdminName(adminName);
                admin.setAdminEmail(adminEmail);
                boolean updated = AdminDAO.updateAdmin(admin);
                if (updated) {
                    Admin freshAdmin = AdminDAO.getAdminById(admin.getAdminId());
                    session.setAttribute("admin", freshAdmin);
                    request.setAttribute("message", "General settings updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update general settings");
                }
            }

        } else if ("password".equals(formType)) {
            String adminPassword = request.getParameter("adminPassword");

            if (adminPassword == null || adminPassword.trim().isEmpty()) {
                request.setAttribute("error", "Password is required");
            } else if (adminPassword.length() < 8) {
                request.setAttribute("error", "Password must be at least 8 characters");
            } else {
                admin.setAdminPassword(adminPassword);
                boolean updated = AdminDAO.updateAdmin(admin);
                if (updated) {
                    request.setAttribute("message", "Password updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update password");
                }
            }

        } else if ("company".equals(formType)) {
            String companyName = request.getParameter("companyName");
            String companyEmail = request.getParameter("companyEmail");
            String companyPhone = request.getParameter("companyPhone");
            String companyAddress = request.getParameter("companyAddress");

            admin.setCompanyName(companyName);
            admin.setCompanyEmail(companyEmail);
            admin.setCompanyPhone(companyPhone);
            admin.setCompanyAddress(companyAddress);

            boolean updated = AdminDAO.updateAdmin(admin);
            if (updated) {
                Admin freshAdmin = AdminDAO.getAdminById(admin.getAdminId());
                session.setAttribute("admin", freshAdmin);
                request.setAttribute("message", "Company info updated successfully");
            } else {
                request.setAttribute("error", "Failed to update company info");
            }
        }

        request.getRequestDispatcher("/admin/dashboard/settings.jsp").forward(request, response);
    }

}
