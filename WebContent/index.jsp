<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>KC Grocery - Home</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f3f6fa;
    margin: 0;
    padding: 0;
}

.container {
    max-width: 800px;
    margin: 40px auto;
    text-align: center;
}

h1 {
    font-size: 32px;
    margin-bottom: 10px;
}

.menu-btn {
    display: block;
    width: 280px;
    margin: 12px auto;
    padding: 14px;
    background: #3498db;
    color: white;
    border-radius: 8px;
    text-decoration: none;
    font-size: 18px;
    font-weight: bold;
    transition: 0.2s;
}

.menu-btn:hover {
    background: #2179b8;
}

.small-btn {
    background: #6c757d;
}

.small-btn:hover {
    background: #555;
}

.signed-in {
    margin-top: 20px;
    font-size: 18px;
    color: #333;
}

.test-links a {
    color: #444;
    text-decoration: none;
}

.test-links a:hover {
    text-decoration: underline;
}
</style>

</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">

    <h1>Welcome to KC Grocery</h1>
    <p>Your friendly online grocery store!</p>

    <a class="menu-btn" href="login.jsp">🔑 Login</a>
    <a class="menu-btn" href="listprod.jsp">🛒 Begin Shopping</a>
    <a class="menu-btn" href="listorder.jsp">📦 View My Orders</a>
    <a class="menu-btn" href="customer.jsp">👤 My Profile</a>
    <a class="menu-btn" href="admin.jsp">🛠️ Admin Panel</a>
    <a class="menu-btn small-btn" href="logout.jsp">🚪 Log Out</a>

    

    <div class="test-links" style="margin-top: 25px;">
        <h3>Developer Test Links</h3>
        <p><a href="ship.jsp?orderId=1">Test Ship Order #1</a></p>
        <p><a href="ship.jsp?orderId=3">Test Ship Order #3</a></p>
    </div>
</div>

</body>
</html>
