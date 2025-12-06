<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Checkout | Kinjal & Chirayu Grocery</title>

<style>
    body { font-family: Arial; background: #f4f4f4; margin: 0; }
    .container { width: 60%; margin: 40px auto; background: white; padding: 25px;
                 border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    h1, h3 { text-align: center; color: #333; }
    .total-box { text-align: center; background: #e8f5e9; padding: 12px;
                 border-radius: 8px; margin-bottom: 25px; color: #2e7d32; font-size: 20px; }
    input[type=text] { padding: 10px; width: 250px; margin: 10px; border-radius: 5px; border: 1px solid #aaa; }
    input[type=submit], input[type=reset] {
        padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; margin: 10px;
    }
    input[type=submit] { background: #4CAF50; color: white; }
    input[type=reset] { background: #f44336; color: white; }
    .error { color: red; text-align: center; font-size: 18px; margin-top: 10px; }
</style>

</head>
<body>

<div class="container">

<h1>Checkout</h1>

<%
    String error = request.getParameter("error");

    if (error != null) {
%>
        <p class="error"><%= error %></p>
<%
    }

    HashMap<String, ArrayList<Object>> productList =
        (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
%>
        <h3>Your cart is empty.</h3>
        <center><a href="listprod.jsp">Return to Shopping</a></center>
<%
    } else {

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        double total = 0;

        for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {

            ArrayList<Object> p = entry.getValue();
            double price = Double.parseDouble((String)p.get(2));
            int qty = (Integer) p.get(3);
            total += price * qty;
        }
%>

<div class="total-box">
    Total Amount: <strong><%= currFormat.format(total) %></strong>
</div>

<h3>Enter Your Customer ID</h3>

<form method="post" action="validateCheckout.jsp">
    <center>
        <input type="text" name="customerId" placeholder="e.g., 1">
        <br>
        <input type="submit" value="Proceed">
        <input type="reset" value="Clear">
    </center>
</form>

<%
    }
%>

</div>
</body>
</html>
