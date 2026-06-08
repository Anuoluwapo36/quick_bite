

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




@WebServlet("/admin/addProduct")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddProductServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final String UPLOAD_DIR = "uploads";



	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {


			response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=loginRequired");
			return;

		}

		request.getRequestDispatcher("/admin/dashboard/add-foods.jsp").forward(request, response);

	}



	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("admin") == null) {


			response.sendRedirect(request.getContextPath() + "/admin/index.jsp?error=login Required");
			return;

		}

//        Admin admin = (Admin) session.getAttribute("admin"); 
		String productName = request.getParameter("foodname");
		String categoryName = request.getParameter("category");
		String priceStr = request.getParameter("price");
		String description = request.getParameter("description");

		if (productName == null || productName.isEmpty() || categoryName == null || categoryName.isEmpty()
				|| priceStr == null || priceStr.isEmpty()) {


			response.sendRedirect(request.getContextPath() + "/admin/dashboard/add-foods.jsp?error=errors");
			return;

		}

		double price = 0;

		try {


			price = Double.parseDouble(priceStr);

		} catch (NumberFormatException e) {


			response.sendRedirect("/admin/dashboard/add-food.jsp?error=2");
			return;

		}

		// Create Product object
		Product product = new Product();
		product.setProductName(productName);
		product.setProductDesc(description);
		product.setProductPrice(price);
		product.setCategoriesName(categoryName);

		// Handle uploaded images
		List<String> imageNames = new ArrayList<>();

		try {


			for (Part part : request.getParts()) {


				if (part.getName().equals("productImages") && part.getSize() > 0) {


					String fileName = new File(part.getSubmittedFileName()).getName();
					String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
					File uploadDir = new File(uploadPath);
					if (!uploadDir.exists())
						uploadDir.mkdir();

					String filePath = uploadPath + File.separator + fileName;
					part.write(filePath);

					imageNames.add(fileName);

				}

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		// Insert product via DAO
		int productId = ProductDAO.insertProduct(product, imageNames, categoryName);

		if (productId > 0) {


			response.sendRedirect( request.getContextPath() + "/admin/products?success=1");

		} else {


			response.sendRedirect(request.getContextPath() + "/admin/dashboard/add-product.jsp?error=3");

		}

	}



}
