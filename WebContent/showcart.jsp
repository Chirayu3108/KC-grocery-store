<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    h1 {
        text-align: center;
        margin-top: 20px;
        color: #333;
    }

    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background: white;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    th {
        background: #3498db;
        color: white;
        padding: 12px;
    }

    td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #eee;
    }

    .subtotal {
        font-weight: bold;
    }

    .total-row td {
        background: #f0f8ff;
        font-size: 18px;
        font-weight: bold;
    }

    .btn-remove {
        background: #e74c3c;
        color: white;
        padding: 6px 12px;
        border-radius: 4px;
        text-decoration: none;
    }

    .btn-remove:hover {
        background: #c0392b;
    }

    .btn-checkout {
        display: block;
        width: 200px;
        margin: 25px auto;
        padding: 12px;
        background: #2ecc71;
        color: white;
        text-align: center;
        text-decoration: none;
        border-radius: 6px;
        font-size: 18px;
    }

    .btn-checkout:hover {
        background: #27ae60;
    }

    .btn-shopping {
        display: block;
        width: 200px;
        margin: 10px auto;
        padding: 10px;
        background: #3498db;
        color: white;
        text-align: center;
        text-decoration: none;
        border-radius: 6px;
    }

    .btn-shopping:hover {
        background: #2980b9;
    }
</style>

</head>
<body>

<jsp:include page="header.jsp" />

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null || productList.isEmpty()) {
    out.println("<h1>Your shopping cart is empty! 🛒</h1>");
    out.println("<a class='btn-shopping' href='listprod.jsp'>Start Shopping</a>");
} else {

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>

<h1>Your Shopping Cart</h1>

<table>
    <tr>
        <th>Product Id</th>
        <th>Name</th>
        <th>Qty</th>
        <th>Price</th>
        <th>Subtotal</th>
        <th>Remove</th>
    </tr>

<%
    double total = 0;

    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        ArrayList<Object> product = entry.getValue();
        String productId = product.get(0).toString();
        String name = product.get(1).toString();
        double price = Double.parseDouble(product.get(2).toString());
        int qty = Integer.parseInt(product.get(3).toString());
        double subtotal = price * qty;

        total += subtotal;
%>

<tr>
    <td><%= productId %></td>
    <td><%= name %></td>

    <!-- Quantity Update Form -->
    <td>
        <form action="updatecart.jsp" method="post" style="display:flex; gap:5px; justify-content:center;">
            <input type="hidden" name="id" value="<%= productId %>">
            <input type="number" name="qty" value="<%= qty %>" min="1" max="99" 
                   style="width:60px; padding:6px; border:1px solid #ccc; border-radius:4px;">
            <button style="padding:6px 10px; background:#27ae60; color:white; border:none; border-radius:4px;">
                Update
            </button>
        </form>
    </td>

    <td><%= currFormat.format(price) %></td>
    <td class="subtotal"><%= currFormat.format(subtotal) %></td>

    <td>
        <a class='btn-remove' href='removecart.jsp?id=<%= productId %>'>Remove</a>
    </td>
</tr>

<%
    }
%>

<tr class="total-row">
    <td colspan="4">Total</td>
    <td colspan="2"><%= currFormat.format(total) %></td>
</tr>

</table>

<a class="btn-checkout" href="checkout.jsp">Proceed to Checkout</a>
<a class="btn-shopping" href="listprod.jsp">Continue Shopping</a>

<%
}
%>

</body>
</html>
