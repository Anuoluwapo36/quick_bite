

package com.quick_bite.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.quick_bite.model.Customer;
import com.quick_bite.sqlconnection.DBConnection;




public class CustomerDAO {

	public static List<Customer> getAllCustomers() {

		List<Customer> customers = new ArrayList<>();

		try (Connection con = DBConnection.getConnection()) {


			String sql = "SELECT * FROM customer ORDER BY created_at DESC";
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {


				Customer c = new Customer();
				c.setCustomerId(rs.getInt("customer_id"));
				c.setFullName(rs.getString("full_name"));
				c.setEmail(rs.getString("email"));
				c.setPhone(rs.getString("phone"));
				c.setAddress(rs.getString("address"));
				c.setCreatedAt(rs.getTimestamp("created_at"));
				customers.add(c);

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return customers;

	}



	/**
	 * Create a new customer
	 * 
	 * @param customer - customer object to save
	 * @return true if inserted successfully, false otherwise
	 */
	public static boolean createCustomer(Customer customer) {

		if (getCustomerByEmail(customer.getEmail()) != null) {


			System.out.println("Email already exists: " + customer.getEmail());
			return false;

		}

		String sql = "INSERT INTO customer ( email, password, created_at) " + "VALUES (?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {


			stmt.setString(1, customer.getEmail());

			stmt.setString(2, customer.getPassword());

			stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

			int rowsInserted = stmt.executeUpdate();
			return rowsInserted > 0;

		} catch (Exception e) {


			e.printStackTrace();
			return false;

		}

	}



	/**
	 * Retrieve a customer by email
	 * 
	 * @param email - email to search
	 * @return Customer object if found, null otherwise
	 */
	public static Customer getCustomerByEmail(String email) {
	    String sql = "SELECT * FROM customer WHERE email = ? AND is_deleted = 0";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {

	        stmt.setString(1, email);
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            Customer customer = new Customer();
	            customer.setCustomerId(rs.getInt("customer_id"));
	            customer.setFullName(rs.getString("full_name"));
	            customer.setEmail(rs.getString("email"));
	            customer.setPhone(rs.getString("phone"));
	            customer.setAddress(rs.getString("address"));
	            customer.setPassword(rs.getString("password"));
	            customer.setCreatedAt(rs.getTimestamp("created_at"));
	            customer.setDeleted(rs.getInt("is_deleted") == 1);

	            return customer;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return null;
	}






	public static boolean updateCustomerProfile(int customerId, String fullName, String phone, String address) {
	    try (Connection con = DBConnection.getConnection()) {

	        String sqlOld = "SELECT full_name, phone, address FROM customer WHERE customer_id = ?";
	        String oldFullName = null, oldPhone = null, oldAddress = null;
	        try (PreparedStatement ps = con.prepareStatement(sqlOld)) {
	            ps.setInt(1, customerId);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                oldFullName = rs.getString("full_name");
	                oldPhone = rs.getString("phone");
	                oldAddress = rs.getString("address");
	            }
	        }

	        String sqlUpdate = """
	            UPDATE customer
	            SET full_name = ?, phone = ?, address = ?
	            WHERE customer_id = ?
	        """;
	        try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
	            ps.setString(1, fullName);
	            ps.setString(2, phone);
	            ps.setString(3, address);
	            ps.setInt(4, customerId);
	            int updated = ps.executeUpdate();
	            if (updated == 0) return false;
	        }

	        String sqlAudit = "INSERT INTO customer_audit (customer_id, field_changed, old_value, new_value) VALUES (?, ?, ?, ?)";
	        try (PreparedStatement ps = con.prepareStatement(sqlAudit)) {
	            if (!oldFullName.equals(fullName)) {
	                ps.setInt(1, customerId);
	                ps.setString(2, "full_name");
	                ps.setString(3, oldFullName);
	                ps.setString(4, fullName);
	                ps.executeUpdate();
	            }
	            if (!oldPhone.equals(phone)) {
	                ps.setInt(1, customerId);
	                ps.setString(2, "phone");
	                ps.setString(3, oldPhone);
	                ps.setString(4, phone);
	                ps.executeUpdate();
	            }
	            if (!oldAddress.equals(address)) {
	                ps.setInt(1, customerId);
	                ps.setString(2, "address");
	                ps.setString(3, oldAddress);
	                ps.setString(4, address);
	                ps.executeUpdate();
	            }
	        }

	        return true;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}


	public static boolean updatePassword(int customerId, String newPassword) {
	    try (Connection con = DBConnection.getConnection()) {

	        String sqlUpdate = "UPDATE customer SET password = ? WHERE customer_id = ?";
	        try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
	            ps.setString(1, newPassword); 
	            ps.setInt(2, customerId);
	            int updated = ps.executeUpdate();
	            if (updated == 0) return false;
	        }

	        String sqlAudit = "INSERT INTO password_audit (customer_id) VALUES (?)";
	        try (PreparedStatement ps = con.prepareStatement(sqlAudit)) {
	            ps.setInt(1, customerId);
	            ps.executeUpdate();
	        }

	        return true;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	public static boolean checkPassword(int customerId, String inputPassword) {

		String sql = "SELECT password FROM customer WHERE customer_id = ?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {


			ps.setInt(1, customerId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {


				String storedPassword = rs.getString("password");
		
				return storedPassword.equals(inputPassword);

			}

		} catch (Exception e) {


			e.printStackTrace();

		}

		return false;

	}

	public static boolean deleteCustomer(int customerId) {
	    String sql = "UPDATE customer SET is_deleted = 1 WHERE customer_id = ?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, customerId);
	        return ps.executeUpdate() > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}


}
