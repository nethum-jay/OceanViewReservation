<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Resort - Register Guest</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 50px; }
        .form-container { background: white; padding: 30px; border-radius: 8px; max-width: 400px; margin: auto; box-shadow: 0px 0px 10px 0px #0000001a; }
        input[type="text"] { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        input[type="submit"] { width: 100%; background-color: #28a745; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; }
        .error { color: red; font-size: 14px; }
        .success { color: green; font-size: 14px; }
    </style>
    <script>
        // Client-Side Validation Mechanism
        function validateForm() {
            let name = document.forms["regForm"]["name"].value;
            let contact = document.forms["regForm"]["contactNo"].value;
            if (name == "") {
                alert("Name must be filled out");
                return false;
            }
            if (contact.length < 10) {
                alert("Contact Number must be at least 10 digits");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

<div class="form-container">
    <h2>Guest Registration</h2>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <p class="error"><%= request.getAttribute("errorMessage") %></p>
    <% } %>
    <% if(request.getAttribute("successMessage") != null) { %>
    <p class="success"><%= request.getAttribute("successMessage") %></p>
    <% } %>

    <form name="regForm" action="GuestServlet" method="post" onsubmit="return validateForm()">
        <label>Full Name:</label>
        <input type="text" name="name" required>

        <label>Address:</label>
        <input type="text" name="address" required>

        <label>Contact Number:</label>
        <input type="text" name="contactNo" required>

        <input type="submit" value="Register Guest">
    </form>
</div>

</body>
</html>