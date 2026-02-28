<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.oceanview.model.User" %>
<%
    // Security measures Redirect to login page if not logged in
    String loggedUser = (String) session.getAttribute("loggedUser");
    String role = (String) session.getAttribute("userRole");
    if (loggedUser == null || !"Admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --white: #ffffff; --danger: #e63946; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; text-decoration: none; color: var(--primary); }
        .logo-sec img { height: 42px; }
        .logo-sec h1 { font-size: 24px; margin: 0; font-weight: 700; }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }

        .container { flex: 1; padding: 40px; display: flex; justify-content: center; animation: fadeIn 0.8s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .table-card { background: rgba(255, 255, 255, 0.95); padding: 35px; border-radius: 20px; width: 100%; max-width: 950px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .table-card h2 { color: var(--primary); margin: 0 0 20px 0; font-size: 20px; display: flex; align-items: center; gap: 10px; }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        th { background: var(--primary); color: white; padding: 18px 15px; text-align: left; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 18px 15px; border-bottom: 1px solid #eee; font-size: 15px; color: var(--text-dark); }
        tr:hover { background: #f8fbff; }

        .role-badge { background: #e0fbfc; color: var(--primary); padding: 6px 15px; border-radius: 20px; font-size: 13px; font-weight: 600; border: 1px solid var(--secondary); display: inline-block; }

        .action-links a { font-size: 18px; transition: 0.3s; margin: 0 10px; text-decoration: none; }
        .action-links a:hover { transform: scale(1.2); }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 12px; margin-top: auto; }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <a href="adminDashboard.jsp" class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>System User Management</h1>
    </a>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="table-card">
        <h2><i class="fa-solid fa-users-gear"></i> System User List</h2>

        <table>
            <thead>
            <tr>
                <th>User ID</th>
                <th>Username</th>
                <th>Account Role</th>
                <th>Contact No</th>
                <th style="text-align: center;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> users = (List<User>) request.getAttribute("userList");
                if (users != null && !users.isEmpty()) {
                    for (User u : users) {
            %>
            <tr>
                <td style="font-weight: 700; color: var(--primary); font-size: 16px;">#<%= u.getId() %></td>
                <td style="font-weight: 500;"><i class="fa-solid fa-user" style="color: var(--secondary); margin-right: 5px;"></i> <%= u.getUsername() %></td>
                <td><span class="role-badge"><%= u.getRole() %></span></td>
                <td><i class="fa-solid fa-phone" style="color: #888; margin-right: 5px;"></i> <%= (u.getPhone() != null && !u.getPhone().equals("null")) ? u.getPhone() : "<span style='color:#ccc;'>Not Set</span>" %></td>

                <td style="text-align: center;" class="action-links">
                    <a href="LoadUserForEditServlet?id=<%= u.getId() %>" title="Edit User" style="color: var(--primary);">
                        <i class="fa-solid fa-user-pen"></i>
                    </a>
                    <a href="DeleteUserServlet?id=<%= u.getId() %>" onclick="return confirm('Are you sure you want to delete this user completely?');" title="Delete User" style="color: var(--danger);">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; padding: 40px; color: #888;">
                    <i class="fa-solid fa-folder-open" style="font-size: 28px; display: block; margin-bottom: 15px; color: #ccc;"></i>
                    No users found in the system.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>