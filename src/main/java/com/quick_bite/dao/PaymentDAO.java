

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;

import com.quick_bite.model.Payment;
import com.quick_bite.sqlconnection.DBConnection;




public class PaymentDAO {

	public static double getTotalRevenueToday() {

		double revenue = 0;

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"SELECT SUM(amount) FROM payments WHERE DATE(payment_date) = CURDATE() AND payment_status = 'PAID'")) {


			ResultSet rs = ps.executeQuery();

			if (rs.next()) {


				revenue = rs.getDouble(1);

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return revenue;

	}



	public static int getCompletedOrdersToday() {

		String sql = """
				    SELECT COUNT(*)
				    FROM payments
				    WHERE payment_status='PAID'
				    AND DATE(payment_date)=CURDATE()
				""";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {


			if (rs.next())
				return rs.getInt(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return 0;

	}



	public static double getAverageOrderValueToday() {

		String sql = """
				    SELECT COALESCE(AVG(amount),0)
				    FROM payments
				    WHERE payment_status='PAID'
				    AND DATE(payment_date)=CURDATE()
				""";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {


			if (rs.next())
				return rs.getDouble(1);

		} catch (Exception e) {


			e.printStackTrace();

		}

		return 0;

	}



	public static Payment getPaymentByOrderId(int orderId) {

		Payment payment = null;

		String sql = "SELECT * FROM payments WHERE order_id = ? LIMIT 1";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {


			ps.setInt(1, orderId);

			try (ResultSet rs = ps.executeQuery()) {


				if (rs.next()) {


					payment = new Payment();
					payment.setPaymentId(rs.getInt("payment_id"));
					payment.setOrderId(rs.getInt("order_id"));
					payment.setAmount(rs.getDouble("amount"));
					payment.setPaymentMethod(rs.getString("payment_method"));
					payment.setPaymentStatus(rs.getString("payment_status").trim());
					payment.setTransactionId(rs.getString("transaction_id"));
					payment.setCreatedAt(rs.getTimestamp("payment_date"));

				}

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return payment;

	}



	public static boolean createPayment(int orderId, double amount, String paymentMethod, String paymentStatus,
			String transactionId) {

		String sql = """
				    INSERT INTO payments (order_id, amount, payment_method, payment_status, transaction_id)
				    VALUES (?, ?, ?, ?, ?)
				""";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {


			ps.setInt(1, orderId);
			ps.setDouble(2, amount);
			ps.setString(3, paymentMethod);
			ps.setString(4, paymentStatus);
			ps.setString(5, transactionId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {


			e.printStackTrace();

		}

		return false;

	}

	 public static void cleanOldPendingPayments() {
	        String sql = "DELETE FROM payment WHERE status = 'Pending' AND created_at < ?";
	        try (Connection con = DBConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            Timestamp fiveMinutesAgo = Timestamp.from(Instant.now().minusSeconds(300));
	            ps.setTimestamp(1, fiveMinutesAgo);
	            ps.executeUpdate();

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

}
