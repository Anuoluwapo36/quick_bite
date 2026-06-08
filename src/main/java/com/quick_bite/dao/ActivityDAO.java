

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.quick_bite.model.Activity;
import com.quick_bite.sqlconnection.DBConnection;




public class ActivityDAO {

	public static List<Activity> getRecentActivities(int customerId) {

		List<Activity> activities = new ArrayList<>();

		try (Connection con = DBConnection.getConnection()) {


			String sqlOrders = """
					    SELECT o.order_id, o.total_amount, o.status, o.created_at
					    FROM orders o
					    WHERE o.customer_id = ?
					    ORDER BY o.created_at DESC
					    LIMIT 10
					""";

			try (PreparedStatement ps = con.prepareStatement(sqlOrders)) {


				ps.setInt(1, customerId);
				ResultSet rs = ps.executeQuery();

				while (rs.next()) {


					String details = "Order #" + rs.getInt("order_id") + " • $" + rs.getBigDecimal("total_amount");
					activities.add(new Activity("Order Placed", details, rs.getTimestamp("created_at"),
							rs.getString("status")));

				}

			}

			String sqlPayments = """
					    SELECT payment_id, amount, payment_method, payment_status, payment_date
					    FROM payments
					    WHERE customer_id = ?
					    ORDER BY payment_date DESC
					    LIMIT 10
					""";

			try (PreparedStatement ps = con.prepareStatement(sqlPayments)) {


				ps.setInt(1, customerId);
				ResultSet rs = ps.executeQuery();

				while (rs.next()) {


					String details = "Paid $" + rs.getBigDecimal("amount") + " via " + rs.getString("payment_method");
					activities.add(new Activity("Payment Made", details, rs.getTimestamp("payment_date"),
							rs.getString("payment_status")));

				}

			}

			String sqlProfileUpdates = """
					    SELECT updated_at, field_changed, old_value, new_value
					    FROM customer_audit
					    WHERE customer_id = ?
					    ORDER BY updated_at DESC
					    LIMIT 10
					""";

			try (PreparedStatement ps = con.prepareStatement(sqlProfileUpdates)) {


				ps.setInt(1, customerId);
				ResultSet rs = ps.executeQuery();

				while (rs.next()) {


					String details = "Changed " + rs.getString("field_changed") + " from '" + rs.getString("old_value")
							+ "' to '" + rs.getString("new_value") + "'";
					activities.add(new Activity("Profile Updated", details, rs.getTimestamp("updated_at"), "Updated"));

				}

			}

			String sqlPasswordChanges = """
					    SELECT changed_at
					    FROM password_audit
					    WHERE customer_id = ?
					    ORDER BY changed_at DESC
					    LIMIT 5
					""";

			try (PreparedStatement ps = con.prepareStatement(sqlPasswordChanges)) {


				ps.setInt(1, customerId);
				ResultSet rs = ps.executeQuery();

				while (rs.next()) {


					String details = "Password updated";
					activities.add(new Activity("Password Changed", details, rs.getTimestamp("changed_at"), ""));

				}

			}

		} catch (SQLException e) {


			e.printStackTrace();

		}

		return activities;

	}



}
