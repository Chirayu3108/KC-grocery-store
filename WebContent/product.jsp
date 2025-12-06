<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>KC's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%

  NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");

String prodString = request.getParameter("productId");
if(prodString == null){
  out.println("<h3>Error: product id missing</h3>");
  return;
}

int productId = Integer.parseInt(prodString);

String sql = "SELECT productId, productName, productPrice, productDesc, " +
                 "productImageURL, productImage " +
                 "FROM product WHERE productId = ?";;

Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement pstmt = con.prepareStatement(sql)) {

        pstmt.setInt(1, productId);
        ResultSet rs = pstmt.executeQuery();

        if (!rs.next()) {
            out.println("<h3>No product found.</h3>");
        } else {
%>

<!-- PRODUCT NAME -->
<h2><%= rs.getString("productName") %></h2>

<!-- PRICE -->
<p><b>Price:</b> <%= currFormat.format(rs.getDouble("productPrice")) %></p>

<!-- DESCRIPTION -->
<p><b>Description:</b> <%= rs.getString("productDesc") %></p>

<hr>

<h3>Images</h3>


<%
String imageURL = rs.getString("productImageURL");
            if (imageURL != null && !imageURL.trim().equals("")) {
              %>

              <p><b>Image URL:</b></p>
    <img src="<%= imageURL %>" width="200">
    <br><br>
		

    <%
            }

            Blob blob = rs.getBlob("productImage");
            if (blob != null) {
%>
    <p><b>Stored Image:</b></p>
    <img src="displayImage.jsp?id=<%= productId %>" width="200">
<%
            }
%>

<hr>

<p>
    <a href="addcart.jsp?id=<%= productId %>&name=<%= java.net.URLEncoder.encode(rs.getString("productName"), "UTF-8") %>&price=<%= rs.getDouble("productPrice") %>"
       class="btn btn-primary">Add to Cart</a>

    <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
</p>

<%
        }
    }
%>



</body>
</html>

