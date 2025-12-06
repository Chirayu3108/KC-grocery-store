<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>My Orders</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f3f6fa;
    margin: 0;
    padding: 0;
}
.container {
    width: 70%;
    margin: 40px auto;
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
h1 {
    text-align: center;
    color: #2c3e50;
}
.order-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}
.order-table th, .order-table td {
    border: 1px solid #ccc;
    padding: 10px;
}
.order-table th {
    background: #3498db;
    color: white;
}
.details-link {
    color: #2980b9;
    text-decoration: none;
}
.details-link:hover {
    text-decoration: underline;
}
</style>

</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
<h1>Your Orders</h1>

<%
//String userId = (String) session.getAttribute("userId");

if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

try {
    getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT orderId, orderDate, totalAmount FROM ordersummary WHERE customerId = ? ORDER BY orderDate DESC"
    );
    ps.setString(1, userId);
    ResultSet rs = ps.executeQuery();
%>

<table class="order-table">
<tr>
    <th>Order ID</th>
    <th>Date</th>
    <th>Total</th>
    <th>View</th>
</tr>

<%
boolean hasOrders = false;
while (rs.next()) {
    hasOrders = true;
%>
<tr>
    <td><%= rs.getInt("orderId") %></td>
    <td><%= rs.getTimestamp("orderDate") %></td>
    <td>$<%= rs.getDouble("totalAmount") %></td>
    <td><a class="details-link" href="orderDetails.jsp?orderId=<%= rs.getInt("orderId") %>">Details</a></td>
</tr>
<%
}

if (!hasOrders) {
%>
<tr><td colspan="4" style="text-align:center;">You have no orders yet.</td></tr>
<%
}

} catch (Exception e) {
    out.println("<p style='color:red;'>Error loading orders: " + e + "</p>");
} finally {
    closeConnection();
}
%>

</table>

</div>

</body>
</html>
