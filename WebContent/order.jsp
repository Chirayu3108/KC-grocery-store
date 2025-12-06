<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Order Processing - KC Grocery</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f3f6fa;
    margin: 0;
    padding: 0;
}

.container {
    max-width: 900px;
    margin: 30px auto;
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

h2 {
    margin-top: 0;
}

.success-box {
    background: #d4edda;
    padding: 15px;
    border-left: 6px solid #28a745;
    border-radius: 6px;
    margin-bottom: 20px;
}

.error-box {
    background: #f8d7da;
    padding: 15px;
    border-left: 6px solid #c82333;
    border-radius: 6px;
    margin-bottom: 20px;
}

.order-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

.order-table th, .order-table td {
    padding: 10px;
    border: 1px solid #ccc;
}

.order-table th {
    background: #3498db;
    color: white;
}

.total-row {
    background: #eef6ff;
    font-weight: bold;
}

</style>
</head>
<body>

    <jsp:include page="header.jsp" />

<div class="container">

<%
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (ClassNotFoundException e) {
    out.println("<div class='error-box'>Database driver error: " + e + "</div>");
}

String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

String custId = request.getParameter("customerId");
String password = request.getParameter("password");

boolean isAuthenticated = false;

@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement()) {

    // Validate customer ID exists
    boolean validCustomer = false;
    ResultSet allCustomers = stmt.executeQuery("SELECT customerId FROM customer");

    while (allCustomers.next()) {
        if (allCustomers.getInt("customerId") == Integer.parseInt(custId)) {
            validCustomer = true;
            break;
        }
    }

    if (!validCustomer) {
        out.println("<div class='error-box'>❌ Invalid Customer ID.</div>");
        return;
    }

    // Authenticate customer
    PreparedStatement authStmt =
        con.prepareStatement("SELECT password FROM customer WHERE customerId=?");
    authStmt.setString(1, custId);
    ResultSet rsAuth = authStmt.executeQuery();

    if (rsAuth.next() && rsAuth.getString("password").equals(password)) {
        isAuthenticated = true;
    }

    if (!isAuthenticated) {
        out.println("<div class='error-box'>❌ Authentication failed. Wrong ID or password.</div>");
        return;
    }

    if (productList == null || productList.isEmpty()) {
        out.println("<div class='error-box'>🛒 Your shopping cart is empty.</div>");
        return;
    }

    // Calculate total
    double total = 0;
    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        ArrayList<Object> p = entry.getValue();
        total += Double.parseDouble(p.get(2).toString()) * Integer.parseInt(p.get(3).toString());
    }

    // Retrieve customer shipping info
    PreparedStatement custStmt = con.prepareStatement(
        "SELECT address, city, state, postalCode, country FROM customer WHERE customerId=?");
    custStmt.setString(1, custId);
    ResultSet custInfo = custStmt.executeQuery();

    if (!custInfo.next()) {
        out.println("<div class='error-box'>❌ Customer not found.</div>");
        return;
    }

    // Insert order
    PreparedStatement orderStmt = con.prepareStatement(
        "INSERT INTO ordersummary (totalAmount, customerId, orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) "
      + "VALUES (?, ?, GETDATE(), ?, ?, ?, ?, ?)",
        Statement.RETURN_GENERATED_KEYS);

    orderStmt.setDouble(1, total);
    orderStmt.setString(2, custId);
    orderStmt.setString(3, custInfo.getString("address"));
    orderStmt.setString(4, custInfo.getString("city"));
    orderStmt.setString(5, custInfo.getString("state"));
    orderStmt.setString(6, custInfo.getString("postalCode"));
    orderStmt.setString(7, custInfo.getString("country"));
    orderStmt.executeUpdate();

    ResultSet keys = orderStmt.getGeneratedKeys();
    int orderId = keys.next() ? keys.getInt(1) : -1;

    if (orderId < 0) {
        out.println("<div class='error-box'>❌ Order could not be created.</div>");
        return;
    }
%>

<div class="success-box">
    ✅ <strong>Your order has been placed successfully!</strong><br>
    Your Order ID is <strong><%= orderId %></strong>.
</div>

<h2>Order Summary</h2>

<table class="order-table">
<tr>
    <th>Product ID</th>
    <th>Name</th>
    <th>Qty</th>
    <th>Price</th>
    <th>Subtotal</th>
</tr>

<%
PreparedStatement productInsert =
    con.prepareStatement("INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");

for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
    ArrayList<Object> p = entry.getValue();

    String pid = p.get(0).toString();
    String name = p.get(1).toString();
    double price = Double.parseDouble(p.get(2).toString());
    int qty = Integer.parseInt(p.get(3).toString());
    double subtotal = price * qty;

    productInsert.setInt(1, orderId);
    productInsert.setString(2, pid);
    productInsert.setInt(3, qty);
    productInsert.setDouble(4, price);
    productInsert.executeUpdate();
%>

<tr>
    <td><%= pid %></td>
    <td><%= name %></td>
    <td><%= qty %></td>
    <td>$<%= price %></td>
    <td>$<%= subtotal %></td>
</tr>

<%
}
%>

<tr class="total-row">
    <td colspan="4">TOTAL</td>
    <td>$<%= total %></td>
</tr>
</table>

<%
    // Clear cart
    session.setAttribute("productList", null);

} catch (Exception e) {
    out.println("<div class='error-box'>Error: " + e + "</div>");
}
%>

</div> <!-- END container -->

</body>
</html>
