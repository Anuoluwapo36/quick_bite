package com.quick_bite.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.quick_bite.model.Admin;
import com.quick_bite.sqlconnection.DBConnection;

public class AdminDAO {

    public static Admin login(String username, String password) {
        Admin admin = null;
        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM admin WHERE admin_username = ? AND admin_password = ? AND status = 'ACTIVE'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password); 
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = mapResultSetToAdmin(rs);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    // Get admin by id
    public static Admin getAdminById(int adminId) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admin WHERE admin_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = mapResultSetToAdmin(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    // Update admin info
    public static boolean updateAdmin(Admin admin) {
        // Basic validation
        if (admin.getAdminName() == null || admin.getAdminName().isEmpty()) return false;
        if (admin.getAdminEmail() == null || !admin.getAdminEmail().matches(".+@.+\\..+")) return false;
        if (admin.getAdminPassword() == null || admin.getAdminPassword().length() < 8) return false;

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE admin SET admin_name = ?, admin_email = ?, admin_password = ?, " +
                         "company_name = ?, company_email = ?, company_phone = ?, company_address = ? " +
                         "WHERE admin_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, admin.getAdminName());
            ps.setString(2, admin.getAdminEmail());
            ps.setString(3, admin.getAdminPassword()); 
            ps.setString(4, admin.getCompanyName());
            ps.setString(5, admin.getCompanyEmail());
            ps.setString(6, admin.getCompanyPhone());
            ps.setString(7, admin.getCompanyAddress());
            ps.setInt(8, admin.getAdminId());

            int updated = ps.executeUpdate();
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private static Admin mapResultSetToAdmin(ResultSet rs) throws Exception {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setAdminName(rs.getString("admin_name"));
        admin.setAdminEmail(rs.getString("admin_email"));
        admin.setAdminUsername(rs.getString("admin_username"));
        admin.setAdminPassword(rs.getString("admin_password"));
        admin.setStatus(rs.getString("status"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        admin.setCompanyName(rs.getString("company_name"));
        admin.setCompanyEmail(rs.getString("company_email"));
        admin.setCompanyPhone(rs.getString("company_phone"));
        admin.setCompanyAddress(rs.getString("company_address"));
        return admin;
    }
    
    
    public static Admin getAdminByUsername(String username) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admin WHERE admin_username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                admin = mapResultSetToAdmin(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }

    public static boolean updatePassword(String username, String newPassword) {
        if (newPassword == null || newPassword.length() < 8) return false; 
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE admin SET admin_password = ? WHERE admin_username = ?";
            PreparedStatement ps = con.prepareStatement(sql);

         

            ps.setString(1, newPassword); 
            ps.setString(2, username);

            int updated = ps.executeUpdate();
            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
}
