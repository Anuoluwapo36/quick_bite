

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quick_bite.model.Product;
import com.quick_bite.model.ProductImage;
import com.quick_bite.sqlconnection.DBConnection;




public class ProductDAO {

	/**
	 * Insert a new product with category name (manual input) and optional images.
	 * If the category does not exist, it will be inserted automatically.
	 *
	 * @param product      Product object containing name, description, price
	 * @param imageNames   List of image filenames (can be empty)
	 * @param categoryName Category name typed by admin
	 * @return Generated product_id
	 */
	public static int insertProduct(Product product, List<String> imageNames, String categoryName) {

		int productId = 0;
		int categoryId = 0;

		try {


			Connection con = DBConnection.getConnection();

			// 1️⃣ Check if category exists
			String checkCat = "SELECT category_id FROM categories WHERE category_name=?";
			PreparedStatement psCheck = con.prepareStatement(checkCat);
			psCheck.setString(1, categoryName);
			ResultSet rsCat = psCheck.executeQuery();

			if (rsCat.next()) {


				categoryId = rsCat.getInt("category_id");

			} else {


				// Insert new category
				String insertCat = "INSERT INTO categories(category_name) VALUES(?)";
				PreparedStatement psInsertCat = con.prepareStatement(insertCat,
						PreparedStatement.RETURN_GENERATED_KEYS);
				psInsertCat.setString(1, categoryName);
				psInsertCat.executeUpdate();
				ResultSet rsNewCat = psInsertCat.getGeneratedKeys();

				if (rsNewCat.next()) {


					categoryId = rsNewCat.getInt(1);

				}

			}

			// Insert product with categoryId
			String sqlProduct = "INSERT INTO products(product_name, product_desc, product_price, category_id) VALUES(?,?,?,?)";
			PreparedStatement psProd = con.prepareStatement(sqlProduct, PreparedStatement.RETURN_GENERATED_KEYS);
			psProd.setString(1, product.getProductName());
			psProd.setString(2, product.getProductDesc());
			psProd.setDouble(3, product.getProductPrice());
			psProd.setInt(4, categoryId);

			int row = psProd.executeUpdate();

			if (row > 0) {


				ResultSet rsProd = psProd.getGeneratedKeys();

				if (rsProd.next()) {


					productId = rsProd.getInt(1);

				}

			}

			// Insert images
			String sqlImage = "INSERT INTO product_images(product_id, image_name) VALUES(?, ?)";
			PreparedStatement psImg = con.prepareStatement(sqlImage);

			if (imageNames == null || imageNames.isEmpty()) {


				psImg.setInt(1, productId);
				psImg.setString(2, "/image/default.png");
				psImg.executeUpdate();

			} else {


				for (String img : imageNames) {


					psImg.setInt(1, productId);
					psImg.setString(2, img);
					psImg.addBatch();

				}

				psImg.executeBatch();

			}

			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return productId;

	}

	// display product



	public static List<Product> getAllProducts() {

		List<Product> productList = new ArrayList<>();

		try {


			Connection con = DBConnection.getConnection();

			// all products with category name
			String sql = "SELECT p.product_id, p.product_name, p.product_desc, p.product_price, " + "c.category_name "
					+ "FROM products p " + "LEFT JOIN categories c ON p.category_id = c.category_id "
					+ "ORDER BY p.created_at DESC";

			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {


				Product p = new Product();
				p.setProductId(rs.getInt("product_id"));
				p.setProductName(rs.getString("product_name"));
				p.setProductDesc(rs.getString("product_desc"));
				p.setProductPrice(rs.getDouble("product_price"));
				p.setCategoriesName(rs.getString("category_name"));

				// Get images for this product
				List<ProductImage> images = new ArrayList<>();
				PreparedStatement psImg = con.prepareStatement("SELECT * FROM product_images WHERE product_id = ?");
				psImg.setInt(1, p.getProductId());
				ResultSet rsImg = psImg.executeQuery();

				while (rsImg.next()) {


					ProductImage img = new ProductImage();
					img.setImageId(rsImg.getInt("image_id"));
					img.setProductId(rsImg.getInt("product_id"));
					img.setImageName(rsImg.getString("image_name"));
					images.add(img);

				}

				rsImg.close();
				psImg.close();

				p.setImages(images);

				productList.add(p);

			}

			rs.close();
			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return productList;

	}



	// delete product
	public static boolean deleteProduct(int productId) {

		boolean deleted = false;

		try {


			Connection con = DBConnection.getConnection();

			// Delete the product
			String sql = "DELETE FROM products WHERE product_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, productId);

			int rows = ps.executeUpdate();
			deleted = rows > 0;

			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return deleted;

	}



	// get product by id
	public static Product getProductById(int productId) {

		Product p = null;

		try {


			Connection con = DBConnection.getConnection();

			String sql = "SELECT p.*, c.category_name " + "FROM products p "
					+ "LEFT JOIN categories c ON p.category_id = c.category_id " + "WHERE p.product_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, productId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {


				p = new Product();
				p.setProductId(rs.getInt("product_id"));
				p.setProductName(rs.getString("product_name"));
				p.setProductDesc(rs.getString("product_desc"));
				p.setProductPrice(rs.getDouble("product_price"));
				p.setCategoryId(rs.getInt("category_id"));
				p.setCategoriesName(rs.getString("category_name"));

			}

			rs.close();
			ps.close();

			// Load images
			if (p != null) {


				List<ProductImage> images = new ArrayList<>();
				PreparedStatement psImg = con.prepareStatement("SELECT * FROM product_images WHERE product_id = ?");
				psImg.setInt(1, productId);
				ResultSet rsImg = psImg.executeQuery();

				while (rsImg.next()) {


					ProductImage img = new ProductImage();
					img.setImageId(rsImg.getInt("image_id"));
					img.setProductId(productId);
					img.setImageName(rsImg.getString("image_name"));
					images.add(img);

				}

				rsImg.close();
				psImg.close();
				p.setImages(images);

			}

			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return p;

	}



	// update or reedit the food
	public static boolean updateProduct(Product p) {

		boolean success = false;

		try {


			Connection con = DBConnection.getConnection();

			String sql = "UPDATE products SET " + "product_name = ?, " + "product_desc = ?, " + "product_price = ?, "
					+ "category_id = ? " + "WHERE product_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, p.getProductName());
			ps.setString(2, p.getProductDesc());
			ps.setDouble(3, p.getProductPrice());
			ps.setInt(4, p.getCategoryId());
			ps.setInt(5, p.getProductId());

			success = ps.executeUpdate() > 0;

			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return success;

	}



	public static void addProductImages(int productId, List<String> imageNames) {

		try {


			Connection con = DBConnection.getConnection();

			String sql = "INSERT INTO product_images (product_id, image_name) VALUES (?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);

			for (String img : imageNames) {


				ps.setInt(1, productId);
				ps.setString(2, img);
				ps.addBatch();

			}

			ps.executeBatch();
			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

	}



//category by name
	public static int getCategoryIdByName(String categoryName) {

		int categoryId = 0;

		try (Connection con = DBConnection.getConnection()) {


			String sql = "SELECT category_id FROM categories WHERE category_name = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, categoryName);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				categoryId = rs.getInt("category_id");
			rs.close();
			ps.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return categoryId;

	}



	public static boolean deleteProductImage(int imageId) {

		boolean deleted = false;

		try {


			Connection con = DBConnection.getConnection();

			String sql = "DELETE FROM product_images WHERE image_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, imageId);

			deleted = ps.executeUpdate() > 0;

			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return deleted;

	}



	public static ProductImage getProductImageById(int imageId) {

		ProductImage img = null;

		try {


			Connection con = DBConnection.getConnection();
			String sql = "SELECT * FROM product_images WHERE image_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, imageId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {


				img = new ProductImage();
				img.setImageId(rs.getInt("image_id"));
				img.setProductId(rs.getInt("product_id"));
				img.setImageName(rs.getString("image_name"));

			}

			rs.close();
			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return img;

	}



	public static int getTotalProducts() {

		int total = 0;

		try (Connection con = DBConnection.getConnection()) {


			String sql = "SELECT COUNT(*) AS total FROM products";
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {


				total = rs.getInt("total");

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return total;

	}



	public static List<Product> getProductsByCategory(String categoryName) {
	    List<Product> products = new ArrayList<>();

	    String sql = """
	        SELECT p.product_id, p.product_name, p.product_desc, p.product_price,
	               c.category_name
	        FROM products p
	        JOIN categories c ON p.category_id = c.category_id
	        WHERE c.category_name = ?
	        ORDER BY p.created_at DESC
	    """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, categoryName);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Product p = new Product();
	            p.setProductId(rs.getInt("product_id"));
	            p.setProductName(rs.getString("product_name"));
	            p.setProductDesc(rs.getString("product_desc"));
	            p.setProductPrice(rs.getDouble("product_price"));
	            p.setCategoriesName(rs.getString("category_name"));

	            List<ProductImage> images = new ArrayList<>();
	            PreparedStatement psImg = con.prepareStatement(
	                "SELECT * FROM product_images WHERE product_id = ?"
	            );
	            psImg.setInt(1, p.getProductId());
	            ResultSet rsImg = psImg.executeQuery();

	            while (rsImg.next()) {
	                ProductImage img = new ProductImage();
	                img.setImageId(rsImg.getInt("image_id"));
	                img.setProductId(rsImg.getInt("product_id"));
	                img.setImageName(rsImg.getString("image_name"));
	                images.add(img);
	            }

	            rsImg.close();
	            psImg.close();

	            p.setImages(images);
	            products.add(p);
	        }

	        rs.close();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return products;
	}



}
