<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.User" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !role.equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    User u = (User) request.getAttribute("userToEdit");
    if (u == null) {
        response.sendRedirect("ManageUsersServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User Account - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #005f73; --bg-light: #f4f7f6; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg-light); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); width: 100%; max-width: 500px; }
        h2 { color: var(--primary); text-align: center; margin-bottom: 30px; font-size: 22px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { margin-bottom: 15px; }
        .form-group.full-width { grid-column: span 2; }
        label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 8px; color: #333; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-family: 'Poppins'; box-sizing: border-box; font-size: 14px; }
        .btn { width: 100%; background: var(--primary); color: white; padding: 12px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 15px; }
        .btn:hover { background: #0a9396; }
        .back-link { display: block; text-align: center; margin-top: 20px; text-decoration: none; color: #666; font-size: 13px; }
        .back-link:hover { color: var(--primary); font-weight: 500;}
    </style>
</head>
<body>
<div class="card">
    <h2>Edit Account Details</h2>
    <form action="UpdateUserByAdminServlet" method="POST">
        <input type="hidden" name="id" value="<%= u.getId() %>">

        <div class="form-grid">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" value="<%= u.getUsername() %>" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="text" name="password" value="<%= u.getPassword() %>" required>
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" value="<%= u.getPhone() != null && !u.getPhone().equals("null") ? u.getPhone() : "" %>" required>
            </div>

            <div class="form-group">
                <label>System Role</label>
                <select name="role" required>
                    <option value="Admin" <%= "Admin".equals(u.getRole()) ? "selected" : "" %>>Admin</option>
                    <option value="Staff" <%= "Staff".equals(u.getRole()) ? "selected" : "" %>>Staff</option>
                    <option value="Customer" <%= "Customer".equals(u.getRole()) ? "selected" : "" %>>Customer</option>
                </select>
            </div>
        </div>

        <button type="submit" class="btn">Save Changes</button>
        <a href="ManageUsersServlet" class="back-link">Cancel and Go Back</a>
    </form>
</div>
</body>
</html>