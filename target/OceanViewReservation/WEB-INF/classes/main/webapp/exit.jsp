<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security measures: Prevent browser caching to ensure complete logout and prevent going 'Back'
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Safely Exited</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --text-dark: #1a1a1a; --text-muted: #555; --danger: #e63946; }
        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed; background-size: cover; color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column; }
        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: -1; }

        header { background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(12px); padding: 15px; display: flex; justify-content: center; align-items: center; box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); }
        header img { height: 45px; margin-right: 15px; }
        header h1 { margin: 0; font-size: 24px; color: var(--primary); font-weight: 700; letter-spacing: 0.5px; }

        main { flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px; animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .exit-container { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px); padding: 50px 40px; border-radius: 20px; width: 100%; max-width: 450px; text-align: center; box-shadow: 0 15px 40px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.6); border-top: 6px solid var(--danger); }
        .exit-icon { font-size: 65px; color: var(--danger); margin-bottom: 20px; text-shadow: 0 4px 15px rgba(230, 57, 70, 0.3); animation: popIn 0.5s ease-out forwards; }
        @keyframes popIn { 0% { transform: scale(0); } 80% { transform: scale(1.1); } 100% { transform: scale(1); } }
        .exit-container h2 { margin-top: 0; color: var(--primary); margin-bottom: 15px; font-size: 28px; font-weight: 700; }
        .exit-container p { color: var(--text-muted); font-size: 15px; margin-bottom: 35px; line-height: 1.6; }

        .login-btn { display: inline-block; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; text-decoration: none; padding: 14px 30px; font-size: 16px; border-radius: 30px; font-weight: 600; transition: 0.3s; font-family: 'Poppins', sans-serif; box-shadow: 0 5px 15px rgba(0,95,115,0.3); }
        .login-btn:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,95,115,0.4); }

        footer { text-align: center; padding: 15px; color: rgba(255,255,255,0.9); font-size: 13px; backdrop-filter: blur(8px); background: rgba(0,0,0,0.6); margin-top: auto; }
    </style>
</head>
<body>

<div class="overlay"></div>

<header>
    <img src="https://cdn-icons-png.flaticon.com/512/3009/3009489.png" alt="Logo">
    <h1>Ocean View Resort</h1>
</header>

<main>
    <div class="exit-container">
        <div class="exit-icon"><i class="fa-solid fa-right-from-bracket"></i></div>
        <h2>Successfully Exited</h2>
        <p>You have safely logged out of the Ocean View Resort Reservation System. Your secure session has been terminated.</p>

        <a href="login.jsp" class="login-btn"><i class="fa-solid fa-shield-halved"></i> Log in Again</a>
    </div>
</main>

<footer>
    &copy; 2026 Ocean View Resort - Reservation System. All Rights Reserved. <br> Developed for Advanced Programming Assignment.
</footer>

</body>
</html>