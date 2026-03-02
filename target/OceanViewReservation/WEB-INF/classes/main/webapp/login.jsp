<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - System Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --danger: #e63946; --text-dark: #1a1a1a; }

        body {
            font-family: 'Poppins', sans-serif; margin: 0; padding: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover; display: flex; align-items: center; justify-content: center; min-height: 100vh;
        }

        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: -1; }

        .login-card {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 20px; width: 100%; max-width: 400px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3); border-top: 6px solid var(--secondary);
            text-align: center; animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .icon-box {
            width: 70px; height: 70px; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center;
            font-size: 30px; margin: 0 auto 20px; box-shadow: 0 8px 20px rgba(10,147,150,0.3);
        }

        .login-card h2 { color: var(--primary); margin-top: 0; margin-bottom: 25px; font-weight: 700; }

        .input-group { margin-bottom: 20px; text-align: left; }
        .input-group label { display: block; font-size: 14px; font-weight: 600; color: var(--text-dark); margin-bottom: 8px; }

        .input-container { position: relative; }
        .input-container i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--secondary); }
        .input-container input {
            width: 100%; padding: 12px 15px 12px 40px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 14px; font-family: 'Poppins', sans-serif; transition: 0.3s; box-sizing: border-box;
        }
        .input-container input:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.3); }

        .submit-btn {
            width: 100%; padding: 12px; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600;
            cursor: pointer; transition: 0.3s; margin-top: 10px; font-family: 'Poppins', sans-serif;
        }
        .submit-btn:hover { box-shadow: 0 5px 15px rgba(0,95,115,0.4); transform: translateY(-2px); }

        .error-msg {
            color: var(--danger); font-weight: 600; font-size: 14px; background: #ffe6e6;
            padding: 10px; border-radius: 8px; margin-bottom: 20px; border: 1px solid var(--danger);
        }
    </style>
</head>
<body>
<div class="overlay"></div>

<div class="login-card">
    <div class="icon-box"><i class="fa-solid fa-user-shield"></i></div>
    <h2>System Login</h2>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
    <% } else if(request.getParameter("error") != null) { %>
    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getParameter("error") %></div>
    <% } %>

    <form action="LoginServlet" method="POST" autocomplete="off" onsubmit="return secureSubmit();">

        <div style="position: absolute; left: -9999px; width: 1px; height: 1px; overflow: hidden;">
            <input type="text" autocomplete="username" tabindex="-1">
            <input type="password" autocomplete="current-password" tabindex="-1">
        </div>

        <input type="hidden" name="username" id="realUsername">
        <input type="hidden" name="password" id="realPassword">

        <div class="input-group">
            <label>Username</label>
            <div class="input-container">
                <i class="fa-solid fa-user"></i>
                <input type="text" id="dummyUsername" placeholder="Letters only (e.g. Kasun)" required
                       autocomplete="off" readonly onfocus="this.removeAttribute('readonly');"
                       oninput="formatUsername(this)">
            </div>
        </div>

        <div class="input-group">
            <label>Password</label>
            <div class="input-container">
                <i class="fa-solid fa-lock"></i>
                <input type="password" id="dummyPassword" placeholder="Enter your password" required
                       autocomplete="new-password">
            </div>
        </div>

        <button type="submit" class="submit-btn"><i class="fa-solid fa-right-to-bracket"></i> Secure Login</button>
    </form>

    <div style="margin-top: 25px; font-size: 14px; color: #555;">
        Don't have an account?
        <a href="register.jsp" style="color: var(--primary); font-weight: 600; text-decoration: none; transition: 0.3s;">
            Register Now
        </a>
    </div>
</div>

<script>
    function formatUsername(inputField) {
        inputField.value = inputField.value.replace(/[^a-zA-Z\s]/g, '');
        let text = inputField.value;
        if (text.length > 0) {
            inputField.value = text.charAt(0).toUpperCase() + text.slice(1);
        }
    }

    function secureSubmit() {
        document.getElementById('realUsername').value = document.getElementById('dummyUsername').value;
        document.getElementById('realPassword').value = document.getElementById('dummyPassword').value;
        return true;
    }
</script>

</body>
</html>