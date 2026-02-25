<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.User" %>
<%
    User u = (User) request.getAttribute("userToEdit");
    if (u == null) { response.sendRedirect("ManageUsersServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f4f7fc; display: flex; justify-content: center; padding: 40px; }
        .form-card { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 450px; }
        h2 { color: #005f73; margin-bottom: 25px; text-align: center; font-weight: 700; }
        label { font-size: 13px; font-weight: 600; color: #555; display: block; margin-top: 15px; }
        input, select { width: 100%; padding: 12px; margin-top: 5px; border: 1.5px solid #eef2f5; border-radius: 10px; box-sizing: border-box; background: #f9fbfd; font-family: 'Poppins'; }
        input:focus { border-color: #0a9396; outline: none; background: white; }
        button { width: 100%; padding: 14px; background: #005f73; color: white; border: none; border-radius: 10px; cursor: pointer; font-weight: 600; margin-top: 30px; transition: 0.3s; }
        button:hover { background: #0a9396; transform: translateY(-2px); }
        .cancel-link { display: block; text-align: center; margin-top: 15px; color: #888; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
<div class="form-card">
    <h2>Edit User Details</h2>
    <form action="UpdateUserByAdminServlet" method="POST">
        <input type="hidden" name="id" value="<%= u.getId() %>">

        <label>Full Name</label>
        <input type="text" name="fullName" value="<%= (u.getFullName() != null) ? u.getFullName() : "" %>" required>

        <label>Username</label>
        <input type="text" name="username" value="<%= u.getUsername() %>" required>

        <label>Email Address</label>
        <input type="email" name="email" value="<%= (u.getEmail() != null) ? u.getEmail() : "" %>" required>

        <label>Phone Number</label>
        <input type="text" name="phone" value="<%= (u.getPhone() != null) ? u.getPhone() : "" %>" required>

        <label>Role</label>
        <select name="role">
            <option value="Customer" <%= "Customer".equals(u.getRole())?"selected":"" %>>Customer</option>
            <option value="Staff" <%= "Staff".equals(u.getRole())?"selected":"" %>>Staff</option>
            <option value="Admin" <%= "Admin".equals(u.getRole())?"selected":"" %>>Admin</option>
        </select>

        <button type="submit">Update Information</button>
    </form>
    <a href="ManageUsersServlet" class="cancel-link">Cancel and Go Back</a>
</div>
</body>
</html>