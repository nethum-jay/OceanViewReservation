<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanview.model.User, com.oceanview.dao.UserDAO" %>
<%
    // Get the currently logged in username from the session
    String loggedUser = (String) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve that user's current data from the database
    UserDAO dao = new UserDAO();
    User u = dao.getUserByUsername(loggedUser);

    // If data is not received (Error Handling)
    if (u == null) {
        out.println("<script>alert('Error loading profile data'); window.location='customerDashboard.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile - Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; }

        body {
            font-family: 'Poppins', sans-serif; margin: 0; padding: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover; min-height: 100vh; display: flex; flex-direction: column;
        }

        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        .logo-sec { display: flex; align-items: center; gap: 15px; text-decoration: none; }
        .logo-sec img { height: 45px; }
        .logo-sec h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; }

        main { flex: 1; display: flex; align-items: center; justify-content: center; padding: 40px 20px; animation: fadeIn 0.8s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .profile-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px); padding: 35px; border-radius: 24px; width: 100%; max-width: 650px; box-shadow: 0 15px 40px rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.6); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 20px; }
        .full-width { grid-column: span 2; }
        .input-group { text-align: left; }
        .input-group label { font-size: 12px; font-weight: 600; color: var(--text-dark); display: block; margin-bottom: 5px; }

        .input-container { position: relative; }
        .input-container i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--secondary); font-size: 14px; }
        .input-container input { width: 100%; padding: 10px 10px 10px 35px; border: 1.5px solid #e0e5e9; border-radius: 10px; font-size: 13px; font-family: 'Poppins'; box-sizing: border-box; background: #f9fbfd; transition: 0.3s; }

        /* Appearance of non-editable sections (Read-only styling) */
        .readonly-field {
            background: #e9ecef !important;
            color: #333333 !important;
            font-weight: 600;
            cursor: not-allowed;
            border-color: #ced4da !important;
        }

        .save-btn { width: 100%; padding: 12px; background: linear-gradient(135deg, var(--secondary), var(--primary)); color: white; border: none; border-radius: 12px; font-weight: 600; font-size: 15px; cursor: pointer; margin-top: 20px; transition: 0.3s; }
        .save-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,95,115,0.4); }

        .alert-success { background: #f0fdfa; color: #155724; border: 1px solid #c3e6cb; padding: 10px; border-radius: 10px; margin-bottom: 15px; text-align: center; }

        footer { text-align: center; padding: 20px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }
    </style>
</head>
<body>
<div class="overlay"></div>
<header>
    <a href="customerDashboard.jsp" class="logo-sec">
        <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
        <h1>Ocean View Resort</h1>
    </a>
    <div style="font-weight: 600; color: var(--primary);"><i class="fa-solid fa-circle-user"></i> <%= loggedUser %></div>
</header>

<main>
    <div class="profile-card">
        <h2 style="text-align: center; color: var(--primary); margin: 0;"><i class="fa-solid fa-user-pen"></i> Edit Profile</h2>

        <% if(request.getAttribute("successMessage") != null) { %>
        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form action="UpdateProfileServlet" method="POST">
            <div class="form-grid">
                <div class="input-group full-width">
                    <label>Full Name</label>
                    <div class="input-container"><i class="fa-solid fa-user-tag"></i>
                        <input type="text" name="fullName" value="<%= (u != null && u.getFullName() != null) ? u.getFullName() : "" %>" required></div>
                </div>

                <div class="input-group">
                    <label>Username (System ID)</label>
                    <div class="input-container"><i class="fa-solid fa-id-badge"></i>
                        <input type="text" name="username" value="<%= u.getUsername() %>" readonly class="readonly-field"></div>
                </div>

                <div class="input-group">
                    <label>Password</label>
                    <div class="input-container"><i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" value="<%= u.getPassword() %>" readonly class="readonly-field"></div>
                </div>

                <div class="input-group">
                    <label>NIC / Passport</label>
                    <div class="input-container"><i class="fa-solid fa-id-card"></i>
                        <input type="text" name="nic" value="<%= (u != null && u.getNic() != null) ? u.getNic() : "" %>" required></div>
                </div>

                <div class="input-group">
                    <label>Phone Number</label>
                    <div class="input-container"><i class="fa-solid fa-phone"></i>
                        <input type="tel" name="phone" value="<%= (u != null && u.getPhone() != null) ? u.getPhone() : "" %>" required pattern="[0-9]{10}"></div>
                </div>

                <div class="input-group full-width">
                    <label>Email Address</label>
                    <div class="input-container"><i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" value="<%= (u != null && u.getEmail() != null) ? u.getEmail() : "" %>" required></div>
                </div>

                <div class="input-group full-width">
                    <label>Residential Address</label>
                    <div class="input-container"><i class="fa-solid fa-map-location-dot"></i>
                        <input type="text" name="address" value="<%= (u != null && u.getAddress() != null) ? u.getAddress() : "" %>" required></div>
                </div>
            </div>

            <button type="submit" class="save-btn"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
        </form>

        <div style="text-align: center; margin-top: 15px;">
            <a href="customerDashboard.jsp" style="text-decoration: none; color: var(--primary); font-size: 13px;"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>
</body>
</html>