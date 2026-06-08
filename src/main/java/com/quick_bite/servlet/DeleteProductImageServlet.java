package com.quick_bite.servlet;

import java.io.File;
import java.io.IOException;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.ProductImage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/delete-product-image")
public class DeleteProductImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Folder where product images are stored
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            return;
        }

        try {
            int imageId = Integer.parseInt(request.getParameter("id"));
            
            ProductImage img = ProductDAO.getProductImageById(imageId);
            if (img != null) {
                boolean deleted = ProductDAO.deleteProductImage(imageId);

                if (deleted) {
                    // Delete physical file
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File file = new File(uploadPath, img.getImageName());
                    if (file.exists()) {
                        file.delete();
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/edit-product?id=" + (img != null ? img.getProductId() : ""));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=deleteFailed");
        }
    }
}
