<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />


<div class="login-container text-center">
    <h3>Please Login to the System</h3>

    <% 
        String msg = (String) session.getAttribute("loginMessage");
        if(msg != null) { 
    %>
        <div class="alert alert-danger" role="alert">
            <%= msg %>
        </div>
    <% 
            session.removeAttribute("loginMessage");
        } 
    %>

    <form method="post" action="validateLogin.jsp">
        <div class="mb-3 text-start">
            <label for="username" class="form-label">Username:</label>
            <input type="text" class="form-control" name="username" id="username" maxlength="10" required>
        </div>
        <div class="mb-3 text-start">
            <label for="password" class="form-label">Password:</label>
            <input type="password" class="form-control" name="password" id="password" maxlength="10" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Log In</button>
    </form>
</div>

<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
