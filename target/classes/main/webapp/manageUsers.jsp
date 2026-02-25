<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.oceanview.model.User" %>
<%
    // Security measures Redirect to login page if not logged in
    String loggedUser = (String) session.getAttribute("loggedUser");
    if (loggedUser == null) {
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
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --white: #ffffff; }
        body {
            font-family: 'Poppins', sans-serif; margin: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover; min-height: 100vh;
        }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }
        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .back-btn { background: var(--primary); color: white; padding: 10px 20px; border-radius: 30px; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.3s; }
        .back-btn:hover { background: var(--secondary); transform: translateX(-5px); }

        .container { padding: 40px; display: flex; justify-content: center; animation: fadeIn 0.8s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .table-card { background: rgba(255, 255, 255, 0.95); padding: 35px; border-radius: 20px; width: 100%; max-width: 1000px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }

        table { width: 100%; border-collapse: collapse; margin-top: 25px; background: white; border-radius: 12px; overflow: hidden; }
        th { background: var(--primary); color: white; padding: 15px; text-align: left; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 15px; border-bottom: 1px solid #eee; font-size: 14px; color: var(--text-dark); }
        tr:last-child td { border-bottom: none; }
        tr:hover { background: #f8fbff; }

        /* Role Badge Style */
        .role-badge {
            background: #e0fbfc; color: var(--primary); padding: 5px 12px;
            border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid var(--secondary);
        }

        .action-links a { font-size: 18px; transition: 0.3s; }
        .action-links a:hover { transform: scale(1.2); }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <div style="display: flex; align-items: center; gap: 12px; color: var(--primary);">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" height="42">
        <h1 style="font-size: 24px; margin: 0; font-weight: 700;">System User Management</h1>
    </div>
    <a href="adminDashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
</header>

<main class="container">
    <div class="table-card">
        <h2 style="color: var(--primary); margin: 0; font-size: 20px;"><i class="fa-solid fa-list-check"></i> System User List</h2>

        <table>
            <thead>
            <tr>
                <th>System ID</th>
                <th>Username</th>
                <th>Account Role</th>
                <th>Contact No</th>
                <th style="text-align: center;">Manage Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                // Retrieving data sent from the Servlet
                List<User> users = (List<User>) request.getAttribute("userList");

                if (users != null && !users.isEmpty()) {
                    for (User u : users) {
            %>
            <tr>
                <td style="font-weight: 600; color: var(--primary);">#<%= u.getId() %></td>
                <td style="font-weight: 500;"><%= u.getUsername() %></td>
                <td><span class="role-badge"><%= u.getRole() %></span></td>
                <td><%= (u.getPhone() != null && !u.getPhone().equals("null")) ? u.getPhone() : "<span style='color:#ccc;'>Not Set</span>" %></td>
                <td style="text-align: center;" class="action-links">
                    <a href="LoadUserForEditServlet?id=<%= u.getId() %>" title="Edit User" style="color: var(--primary); margin-right: 15px;">
                        <i class="fa-solid fa-user-pen"></i>
                    </a>

                    <a href="DeleteUserServlet?id=<%= u.getId() %>"
                       onclick="return confirm('Are you sure you want to delete this user?');"
                       title="Delete User" style="color: #e63946;">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; padding: 30px; color: #888;">
                    <i class="fa-solid fa-circle-info" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
                    No users found. Please refresh or check database connection.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>

<footer style="text-align: center; padding: 20px; color: white; font-size: 12px; margin-top: auto;">
    &copy; 2026 Ocean View Resort - Security & Management Portal
</footer>

</body>
</html>