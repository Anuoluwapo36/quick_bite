

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.quick_bite.model.Order;
import com.quick_bite.model.OrderItem;
import com.quick_bite.model.Payment;
import com.quick_bite.model.Product;
import com.quick_bite.sqlconnection.DBConnection;




public class OrderDAO {

	public static List<Order> getAllOrders() {

		List<Order> orders = new ArrayList<>();

		try {


			Connection con = DBConnection.getConnection();

			String sql = "SELECT o.order_id, o.customer_name, o.customer_email, o.created_at, o.status, "
					+ "oi.item_id, oi.product_id, oi.quantity, oi.price, p.product_name " + "FROM orders o "
					+ "LEFT JOIN order_items oi ON o.order_id = oi.order_id "
					+ "LEFT JOIN products p ON oi.product_id = p.product_id " + "ORDER BY o.created_at DESC";

			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			int currentOrderId = -1;
			Order order = null;

			while (rs.next()) {


				int orderId = rs.getInt("order_id");

				if (orderId != currentOrderId) {


					if (order != null) {


						orders.add(order);

					}

					order = new Order();
					order.setOrderId(orderId);
					order.setCustomerName(rs.getString("customer_name"));
					order.setCustomerEmail(rs.getString("customer_email"));
					order.setCreatedAt(rs.getTimestamp("created_at"));
					order.setStatus(rs.getString("status"));
					order.setItems(new ArrayList<>());

					Payment payment = PaymentDAO.getPaymentByOrderId(orderId);
					order.setPaymetinfo(payment);

					currentOrderId = orderId;

				}

				int itemId = rs.getInt("item_id");

				if (itemId != 0) {


					OrderItem item = new OrderItem();
					item.setItemId(itemId);
					item.setOrderId(orderId);
					item.setProductId(rs.getInt("product_id"));
					item.setQuantity(rs.getInt("quantity"));
					item.setPrice(rs.getDouble("price"));

					Product product = new Product();
					product.setProductId(rs.getInt("product_id"));
					product.setProductName(rs.getString("product_name"));
					item.setProduct(product);

					order.getItems().add(item);

				}

			}

			if (order != null) {


				orders.add(order);

			}

			rs.close();
			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return orders;

	}



	public static Order getOrderById(int orderId) {

		Order order = null;

		try (Connection con = DBConnection.getConnection()) {


			String sql = """
					    SELECT o.order_id, o.customer_name, o.customer_phone, o.customer_address,
					           o.customer_email, o.created_at, o.status,
					           oi.item_id, oi.product_id, oi.quantity, oi.price, p.product_name
					    FROM orders o
					    LEFT JOIN order_items oi ON o.order_id = oi.order_id
					    LEFT JOIN products p ON oi.product_id = p.product_id
					    WHERE o.order_id = ?
					""";

			try (PreparedStatement ps = con.prepareStatement(sql)) {


				ps.setInt(1, orderId);

				try (ResultSet rs = ps.executeQuery()) {


					order = new Order();
					order.setItems(new ArrayList<>());
					boolean firstRow = true;

					while (rs.next()) {


						if (firstRow) {


							order.setOrderId(rs.getInt("order_id"));
							order.setCustomerName(rs.getString("customer_name"));
							order.setCustomerPhone(rs.getString("customer_phone"));
							order.setCustomerAddress(rs.getString("customer_address"));
							order.setCustomerEmail(rs.getString("customer_email"));
							order.setCreatedAt(rs.getTimestamp("created_at"));
							order.setStatus(rs.getString("status"));
							firstRow = false;

						}

						int itemId = rs.getInt("item_id");

						if (itemId != 0) {


							OrderItem item = new OrderItem();
							item.setItemId(itemId);
							item.setOrderId(orderId);
							item.setProductId(rs.getInt("product_id"));
							item.setQuantity(rs.getInt("quantity"));
							item.setPrice(rs.getDouble("price"));

							Product product = new Product();
							product.setProductId(rs.getInt("product_id"));
							product.setProductName(rs.getString("product_name"));
							item.setProduct(product);

							order.getItems().add(item);

						}

					}

				}

			}

			// Fetch payment info for this order
			Payment payment = PaymentDAO.getPaymentByOrderId(orderId);
			order.setPaymetinfo(payment);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return order;

	}



	// Update order status
	public static boolean updateOrderStatus(int orderId, String status) {

		boolean updated = false;

		try {


			Connection con = DBConnection.getConnection();
			String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, orderId);

			updated = ps.executeUpdate() > 0;

			ps.close();
			con.close();

		} catch (Exception e) {


			e.printStackTrace();

		}

		return updated;

	}



	public static int getTotalOrdersToday() {

		int total = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con
						.prepareStatement("SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				total = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return total;

	}



	public static int getDeliveryOrdersToday() {

		int count = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE() AND status ='Delivering'")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return count;

	}



	public static int getPickupOrdersToday() {

		int count = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE() AND status ='pick-up'")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return count;

	}



	public static int getPendingOrder() {

		int count = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE() AND status ='Pending'")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return count;

	}



	public static int getPreparingOrder() {

		int count = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE() AND status ='Preparing'")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				count = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return count;

	}




	public static int createOrder(String customerName, String customerPhone, String customerEmail,
			String customerAddress, double totalAmount) {

		int orderId = -1;

		String sql = """
				    INSERT INTO orders
				    (customer_name, customer_phone, customer_email, customer_address, total_amount, status)
				    VALUES (?, ?, ?, ?, ?, 'Pending')
				""";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {


			ps.setString(1, customerName);
			ps.setString(2, customerPhone);
			ps.setString(3, customerEmail);
			ps.setString(4, customerAddress);
			ps.setDouble(5, totalAmount);

			int rows = ps.executeUpdate();

			if (rows == 0) {


				throw new SQLException("Order insert failed!");

			}

			try (ResultSet rs = ps.getGeneratedKeys()) {


				if (rs.next()) {


					orderId = rs.getInt(1);

				}

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return orderId;

	}



	public static boolean addOrderItem(int orderId, int productId, int quantity, double price) {

		String sql = """
				    INSERT INTO order_items (order_id, product_id, quantity, price)
				    VALUES (?, ?, ?, ?)
				""";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {


			ps.setInt(1, orderId);
			ps.setInt(2, productId);
			ps.setInt(3, quantity);
			ps.setDouble(4, price);

			return ps.executeUpdate() > 0;

		} catch (Exception e) {


			e.printStackTrace();

		}

		return false;

	}



	public static List<Order> getPaidOrdersByCustomerId(int customerId) {

	    List<Order> orders = new ArrayList<>();

	    String sql = """
	        SELECT o.order_id, o.created_at, o.status, o.total_amount,
	               oi.item_id, oi.product_id, oi.quantity, oi.price,
	               p.product_name
	        FROM orders o
	        JOIN payments pay ON o.order_id = pay.order_id
	        LEFT JOIN order_items oi ON o.order_id = oi.order_id
	        LEFT JOIN products p ON oi.product_id = p.product_id
	        WHERE o.customer_id = ?
	          AND pay.payment_status = 'PAID'
	        ORDER BY o.created_at DESC
	    """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, customerId); 
	        ResultSet rs = ps.executeQuery();

	        Order order = null;
	        int currentOrderId = -1;

	        while (rs.next()) {
	            int orderId = rs.getInt("order_id");

	            if (orderId != currentOrderId) {
	                if (order != null) {
	                    orders.add(order);
	                }

	                order = new Order();
	                order.setOrderId(orderId);
	                order.setCreatedAt(rs.getTimestamp("created_at"));
	                order.setStatus(rs.getString("status"));
	                order.setTotalAmount(rs.getDouble("total_amount"));
	                order.setItems(new ArrayList<>());

	                Payment payment = PaymentDAO.getPaymentByOrderId(orderId);
	                order.setPaymetinfo(payment);

	                currentOrderId = orderId;
	            }

	            int itemId = rs.getInt("item_id");
	            if (itemId > 0) {
	                OrderItem item = new OrderItem();
	                item.setItemId(itemId);
	                item.setProductId(rs.getInt("product_id"));
	                item.setQuantity(rs.getInt("quantity"));
	                item.setPrice(rs.getDouble("price"));

	                Product product = new Product();
	                product.setProductName(rs.getString("product_name"));
	                item.setProduct(product);

	                order.getItems().add(item);
	            }
	        }

	        if (order != null) {
	            orders.add(order);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return orders;
	}


	public static Order getPaidOrderById(int orderId, String email) {

		Order order = null;

		String sql = """
				    SELECT o.order_id, o.customer_email, o.created_at, o.status, o.total_amount,
				           oi.item_id, oi_toggle.product_id, oi.quantity, oi.price,
				           p.product_name
				    FROM orders o
				    JOIN payments pay ON o.order_id = pay.order_id
				    LEFT JOIN order_items oi ON o.order_id = oi.order_id
				    LEFT JOIN products p ON oi.product_id = p.product_id
				    WHERE o.order_id = ?
				      AND o.customer_email = ?
				      AND pay.payment_status = 'PAID'
				""";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {


			ps.setInt(1, orderId);
			ps.setString(2, email);

			ResultSet rs = ps.executeQuery();

			boolean firstRow = true;
			order = new Order();
			order.setItems(new ArrayList<>());

			while (rs.next()) {


				if (firstRow) {


					order.setOrderId(rs.getInt("order_id"));
					order.setCreatedAt(rs.getTimestamp("created_at"));
					order.setStatus(rs.getString("status"));
					order.setTotalAmount(rs.getDouble("total_amount"));

					Payment payment = PaymentDAO.getPaymentByOrderId(orderId);
					order.setPaymetinfo(payment);

					firstRow = false;

				}

				int itemId = rs.getInt("item_id");

				if (itemId > 0) {


					OrderItem item = new OrderItem();
					item.setItemId(itemId);
					item.setProductId(rs.getInt("product_id"));
					item.setQuantity(rs.getInt("quantity"));
					item.setPrice(rs.getDouble("price"));

					Product product = new Product();
					product.setProductName(rs.getString("product_name"));
					item.setProduct(product);

					order.getItems().add(item);

				}

			}

			if (firstRow)
				return null; 

		} catch (Exception e) {


			e.printStackTrace();

		}

		return order;

	}



}
