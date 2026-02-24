<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.User" %>
<% User u = (User) request.getAttribute("userToEdit"); %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f7fc; display: flex; justify-content: center; padding: 50px; }
        .form-card { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 400px; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #005f73; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; }
    </style>
</head>
<body>
<div class="form-card">
    <h2 style="color: #005f73; margin-top: 0;">Edit User Details</h2>
    <form action="UpdateUserByAdminServlet" method="POST">
        <input type="hidden" name="id" value="<%= u.getId() %>">
        <label>Full Name</label>
        <input type="text" name="fullName" value="<%= u.getFullName()!=null?u.getFullName():"" %>">
        <label>Role</label>
        <select name="role">
            <option value="Customer" <%= "Customer".equals(u.getRole())?"selected":"" %>>Customer</option>
            <option value="Staff" <%= "Staff".equals(u.getRole())?"selected":"" %>>Staff</option>
            <option value="Admin" <%= "Admin".equals(u.getRole())?"selected":"" %>>Admin</option>
        </select>
        <label>Phone Number</label>
        <input type="text" name="phone" value="<%= u.getPhone() %>">
        <button type="submit">Save Changes</button>
    </form>
    <a href="ManageUsersServlet" style="display: block; text-align: center; margin-top: 15px; color: #666; text-decoration: none; font-size: 14px;">Cancel</a>
</div>
</body>
</html>