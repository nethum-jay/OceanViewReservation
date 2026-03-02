<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - System Registration</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root { --primary: #005f73; --secondary: #0a9396; --accent: #94d2bd; --text-dark: #1a1a1a; --success: #2a9d8f; }

        body {
            font-family: 'Poppins', sans-serif; margin: 0; padding: 0;
            background: url('https://images.unsplash.com/photo-1618140052121-39fc6db33972?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover; display: flex; align-items: center; justify-content: center; min-height: 100vh;
        }

        .overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.55); z-index: -1; }

        .register-card {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            padding: 40px; border-radius: 20px; width: 100%; max-width: 420px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3); border-top: 6px solid var(--secondary);
            text-align: center; animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .icon-box {
            width: 70px; height: 70px; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center;
            font-size: 28px; margin: 0 auto 20px; box-shadow: 0 8px 20px rgba(10,147,150,0.3);
        }

        .register-card h2 { color: var(--primary); margin-top: 0; margin-bottom: 25px; font-weight: 700; }

        .input-group { margin-bottom: 18px; text-align: left; }
        .input-group label { display: block; font-size: 13px; font-weight: 600; color: var(--text-dark); margin-bottom: 6px; }

        .input-container { position: relative; }
        .input-container i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--secondary); }
        .input-container input, .input-container select {
            width: 100%; padding: 12px 15px 12px 40px; border: 1px solid #ccc; border-radius: 8px;
            font-size: 14px; font-family: 'Poppins', sans-serif; transition: 0.3s; box-sizing: border-box;
        }
        .input-container select { appearance: none; cursor: pointer; }
        .input-container input:focus, .input-container select:focus { border-color: var(--secondary); outline: none; box-shadow: 0 0 8px rgba(10,147,150,0.3); }

        .submit-btn {
            width: 100%; padding: 12px; background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600;
            cursor: pointer; transition: 0.3s; margin-top: 15px; font-family: 'Poppins', sans-serif;
        }
        .submit-btn:hover { box-shadow: 0 5px 15px rgba(0,95,115,0.4); transform: translateY(-2px); }

        .success-msg { color: var(--success); font-weight: 600; font-size: 14px; background: #e0fae5; padding: 10px; border-radius: 8px; margin-bottom: 20px; border: 1px solid var(--success); }
        .error-msg { color: #e63946; font-weight: 600; font-size: 14px; background: #ffe6e6; padding: 10px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e63946; }
    </style>
</head>
<body>
<div class="overlay"></div>

<div class="register-card">
    <div class="icon-box"><i class="fa-solid fa-user-plus"></i></div>
    <h2>Create Account</h2>

    <% if(request.getAttribute("successMessage") != null) { %>
    <div class="success-msg">
        <i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("successMessage") %>
        <br><span style="font-size: 11px; font-weight: normal;">Redirecting to Login page...</span>
    </div>

    <script>
        setTimeout(function() {
            window.location.href = "login.jsp";
        }, 3000); // 3000 milliseconds = 3 seconds
    </script>
    <% } %>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="RegisterServlet" method="POST" autocomplete="off" onsubmit="return secureSubmit();">

        <div style="position: absolute; left: -9999px; width: 1px; height: 1px; overflow: hidden;">
            <input type="text" autocomplete="username" tabindex="-1">
            <input type="password" autocomplete="new-password" tabindex="-1">
            <input type="tel" autocomplete="tel" tabindex="-1">
        </div>

        <input type="hidden" name="username" id="realUsername">
        <input type="hidden" name="password" id="realPassword">
        <input type="hidden" name="phone" id="realPhone">

        <div class="input-group">
            <label>Choose Username</label>
            <div class="input-container">
                <i class="fa-solid fa-user"></i>
                <input type="text" id="dummyUsername" placeholder="Letters only (e.g. Kasun)" required
                       autocomplete="off" readonly onfocus="this.removeAttribute('readonly');"
                       title="Username can only contain letters and spaces."
                       oninput="formatUsername(this)">
            </div>
        </div>

        <div class="input-group">
            <label>Create Password</label>
            <div class="input-container">
                <i class="fa-solid fa-lock"></i>
                <input type="password" id="dummyPassword" placeholder="Min 8 chars, 1 number & 1 symbol" required
                       autocomplete="new-password" readonly onfocus="this.removeAttribute('readonly');"
                       pattern="(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,}"
                       title="Password must be at least 8 characters long, and contain at least one number and one special symbol (e.g., @, #, $).">
            </div>
        </div>

        <div class="input-group">
            <label>Phone Number</label>
            <div class="input-container">
                <i class="fa-solid fa-phone"></i>
                <input type="tel" id="dummyPhone" placeholder="07XXXXXXXX" required pattern="[0-9]{10}" maxlength="10"
                       autocomplete="off" readonly onfocus="this.removeAttribute('readonly');"
                       title="Please enter a valid 10-digit phone number."
                       oninput="formatPhone(this)">
            </div>
        </div>

        <button type="submit" class="submit-btn"><i class="fa-solid fa-user-check"></i> Register User</button>
    </form>

    <div style="margin-top: 25px; font-size: 14px; color: #555;">
        Already have an account?
        <a href="login.jsp" style="color: var(--primary); font-weight: 600; text-decoration: none; transition: 0.3s;">
            Login Here
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

    function formatPhone(inputField) {
        inputField.value = inputField.value.replace(/[^0-9]/g, '');
    }

    function secureSubmit() {
        document.getElementById('realUsername').value = document.getElementById('dummyUsername').value;
        document.getElementById('realPassword').value = document.getElementById('dummyPassword').value;
        document.getElementById('realPhone').value = document.getElementById('dummyPhone').value;
        return true;
    }
</script>

</body>
</html>