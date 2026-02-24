<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.oceanview.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }
        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; }
        .container { padding: 40px; display: flex; justify-content: center; }
        .table-card { background: rgba(255, 255, 255, 0.95); padding: 30px; border-radius: 20px; width: 100%; max-width: 1000px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: var(--primary); color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #ddd; font-size: 14px; }
        tr:hover { background: #f1f1f1; }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <div style="display: flex; align-items: center; gap: 10px; color: var(--primary);">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" height="40">
        <h1 style="font-size: 22px; margin: 0;">Manage Users</h1>
    </div>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>
<main class="container">
    <div class="table-card">
        <h2 style="color: var(--primary); margin-top: 0;">System User List</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Username</th>
                <th>Role</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> users = (List<User>) request.getAttribute("userList");
                if (users != null) {
                    for (User u : users) {
            %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= (u.getFullName() != null) ? u.getFullName() : "N/A" %></td>
                <td><%= u.getUsername() %></td>
                <td><span style="font-weight: 600; color: var(--secondary);"><%= u.getRole() %></span></td>
                <td><%= (u.getEmail() != null) ? u.getEmail() : "N/A" %></td>
                <td>
                    <button style="color: var(--primary); border: none; background: none; cursor: pointer;"><i class="fa-solid fa-pen-to-square"></i></button>
                    <button style="color: #e63946; border: none; background: none; cursor: pointer; margin-left: 10px;"><i class="fa-solid fa-trash"></i></button>
                </td>
            </tr>
            <%      }
            } else { %>
            <td>
                <a href="LoadUserForEditServlet?id=<%= u.getId() %>" style="color: var(--primary); text-decoration: none; margin-right: 15px;">
                    <i class="fa-solid fa-pen-to-square"></i>
                </a>

                <a href="DeleteUserServlet?id=<%= u.getId() %>"
                   onclick="return confirm('Are you sure you want to delete this user?');"
                   style="color: #e63946; text-decoration: none;">
                    <i class="fa-solid fa-trash"></i>
                </a>
            </td>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>