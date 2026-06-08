

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.quick_bite.model.TopProduct;
import com.quick_bite.model.WeeklySalesReport;
import com.quick_bite.sqlconnection.DBConnection;




public class ReportDAO {

	// Total revenue
	public static double getTotalRevenue() {

		double total = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con
						.prepareStatement("SELECT SUM(amount) FROM payments WHERE payment_status='PAID'")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				total = rs.getDouble(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return total;

	}



	// Total orders
	public static int getTotalOrders() {

		int total = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM orders")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				total = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return total;

	}



	// New customers
	public static int getNewCustomers() {

		int total = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(DISTINCT customer_email) FROM orders")) {


			ResultSet rs = ps.executeQuery();
			if (rs.next())
				total = rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return total;

	}



	// Cancellation rate
	public static double getCancellationRate() {

		double rate = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM orders WHERE status='Cancelled'")) {


			ResultSet rs = ps.executeQuery();
			int cancelled = 0;
			if (rs.next())
				cancelled = rs.getInt(1);

			PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM orders");
			ResultSet rs2 = ps2.executeQuery();
			int total = 1; // avoid division by zero
			if (rs2.next())
				total = rs2.getInt(1);

			rate = ((double) cancelled / total) * 100;

		} catch (Exception e) {


			e.printStackTrace();

		}

		return rate;

	}



	// Sales per day (for chart)
	public static Map<String, Double> getRevenuePerDay() {

		Map<String, Double> map = new LinkedHashMap<>();

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT DATE(o.created_at) as date, SUM(p.amount) as revenue " + "FROM orders o "
								+ "LEFT JOIN payments p ON o.order_id = p.order_id " + "WHERE p.payment_status='PAID' "
								+ "GROUP BY DATE(o.created_at) ORDER BY DATE(o.created_at)")) {


			ResultSet rs = ps.executeQuery();

			while (rs.next()) {


				map.put(rs.getDate("date").toString(), rs.getDouble("revenue"));

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return map;

	}

	public static List<TopProduct> getTopSellingProducts() {
	    List<TopProduct> list = new ArrayList<>();

	    String sql = """
	        SELECT p.product_name,
	               SUM(oi.quantity) total_sold,
	               SUM(oi.quantity * oi.price) revenue
	        FROM order_items oi
	        JOIN products p ON oi.product_id = p.product_id
	        JOIN payments pay ON oi.order_id = pay.order_id
	        WHERE pay.payment_status = 'PAID'
	        GROUP BY p.product_name
	        ORDER BY revenue DESC
	        LIMIT 5
	    """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            list.add(new TopProduct(
	                rs.getString("product_name"),
	                rs.getInt("total_sold"),
	                rs.getDouble("revenue")
	            ));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public static List<WeeklySalesReport> getWeeklySalesReport() {
	    List<WeeklySalesReport> list = new ArrayList<>();

	    String sql = """
	        SELECT YEAR(o.created_at) AS year,
	               WEEK(o.created_at, 1) AS week,  -- ISO week number, week starts on Monday
	               COUNT(DISTINCT o.order_id) AS orders,
	               COUNT(DISTINCT o.customer_email) AS customers,
	               SUM(CASE WHEN p.payment_status = 'PAID' THEN p.amount ELSE 0 END) AS revenue,
	               AVG(CASE WHEN p.payment_status = 'PAID' THEN p.amount ELSE NULL END) AS avg_value
	        FROM orders o
	        LEFT JOIN payments p ON o.order_id = p.order_id
	        GROUP BY YEAR(o.created_at), WEEK(o.created_at, 1)
	        ORDER BY year DESC, week DESC
	    """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            String weekLabel = rs.getInt("year") + "-W" + rs.getInt("week");

	            list.add(new WeeklySalesReport(
	                weekLabel,
	                rs.getInt("orders"),
	                rs.getInt("customers"),
	                rs.getDouble("revenue"),
	                rs.getDouble("avg_value")
	            ));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}


	public static Map<String, Integer> getPeakHours() {
	    Map<String, Integer> map = new LinkedHashMap<>();

	    String sql = """
	        SELECT HOUR(created_at) hour, COUNT(*) total
	        FROM orders
	        GROUP BY HOUR(created_at)
	        ORDER BY hour
	    """;

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            String label = rs.getInt("hour") + ":00";
	            map.put(label, rs.getInt("total"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return map;
	}

}
