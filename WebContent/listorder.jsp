<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>KC Grocery – Order List</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f3f6fa;
    margin: 0;
    padding: 0;
}

.container {
    max-width: 1000px;
    margin: 30px auto;
}

.order-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 25px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.order-header h3 {
    margin: 0;
}

.order-meta {
    color: #555;
    font-size: 14px;
}

.order-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

.order-table th {
    background: #3498db;
    color: white;
    padding: 10px;
    text-align: left;
}

.order-table td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

.no-orders {
    text-align: center;
    padding: 40px;
    font-size: 20px;
    color: #888;
}
</style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
<h1>📦 Customer Orders</h1>

<%
Connection con = null;
Statement stmt = null;
ResultSet rs = null;
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

    String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";
    con = DriverManager.getConnection(url, user, password);

    String orderQuery = "SELECT orderId, customerId, totalAmount, orderDate FROM ordersummary ORDER BY orderId DESC";
    stmt = con.createStatement();
    rs = stmt.executeQuery(orderQuery);

    boolean foundOrders = false;

    while (rs.next()) {
        foundOrders = true;

        int orderId = rs.getInt("orderId");
        int customerId = rs.getInt("customerId");
        double total = rs.getDouble("totalAmount");
        Timestamp date = rs.getTimestamp("orderDate");
%>

<div class="order-card">
    <div class="order-header">
        <h3>Order #<%= orderId %></h3>
        <div class="order-meta">
            Customer ID: <b><%= customerId %></b><br>
            Date: <%= date %>
        </div>
    </div>

    <p><b>Total Amount:</b> <%= currFormat.format(total) %></p>

    <table class="order-table">
        <tr>
            <th>Product ID</th>
            <th>Name</th>
            <th>Qty</th>
            <th>Price</th>
        </tr>

        <%
        String itemQuery =
            "SELECT p.productId, p.productName, oi.quantity, oi.price " +
            "FROM orderproduct oi " +
            "JOIN product p ON oi.productId = p.productId " +
            "WHERE oi.orderId = ?";

        PreparedStatement ps = con.prepareStatement(itemQuery);
        ps.setInt(1, orderId);
        ResultSet rs2 = ps.executeQuery();

        while (rs2.next()) {
        %>

        <tr>
            <td><%= rs2.getInt("productId") %></td>
            <td><%= rs2.getString("productName") %></td>
            <td><%= rs2.getInt("quantity") %></td>
            <td><%= currFormat.format(rs2.getDouble("price")) %></td>
        </tr>

        <%
        }
        rs2.close();
        ps.close();
        %>
    </table>
</div>

<%
    } // end while

    if (!foundOrders) {
%>

<div class="no-orders">
    🚫 No orders found.
</div>

<%
    }

} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    e.printStackTrace(new java.io.PrintWriter(out));
}
%>

</div>

</body>
</html>
