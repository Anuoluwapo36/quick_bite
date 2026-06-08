

package com.quick_bite.servlet;



import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.quick_bite.dao.ProductDAO;
import com.quick_bite.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;




@WebServlet("/admin/update-product")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UpdateProductServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final String UPLOAD_DIR = "uploads";



	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Admin check
		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {


			response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
			return;

		}

		int productId = Integer.parseInt(request.getParameter("productId"));

		Product p = new Product();
		p.setProductId(productId);
		p.setProductName(request.getParameter("foodname"));
		p.setProductDesc(request.getParameter("description"));
		p.setProductPrice(Double.parseDouble(request.getParameter("price")));
		String categoryName = request.getParameter("category");
		p.setCategoryId(ProductDAO.getCategoryIdByName(categoryName));

		ProductDAO.updateProduct(p);

		// For new images
		String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		List<String> imageNames = new ArrayList<>();

		for (Part part : request.getParts()) {


			if (part.getName().equals("productImages") && part.getSize() > 0) {


				String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
				part.write(uploadPath + File.separator + fileName);
				imageNames.add(fileName);

			}

		}

		if (!imageNames.isEmpty()) {


			ProductDAO.addProductImages(productId, imageNames);

		}

		response.sendRedirect(request.getContextPath() + "/admin/products?updated=true");

	}



}
