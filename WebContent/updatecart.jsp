<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList =
    (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {
    response.sendRedirect("showcart.jsp");
    return;
}

String id = request.getParameter("id");
String qtyStr = request.getParameter("qty");

int qty = 1;

// VALIDATION
try {
    qty = Integer.parseInt(qtyStr);

    if (qty < 1) qty = 1;           // Prevent zero or negative
    if (qty > 99) qty = 99;         // Prevent insanely large numbers
} 
catch (Exception e) {
    qty = 1;  // Invalid input fallback
}

// Apply update
if (productList.containsKey(id)) {
    ArrayList<Object> product = productList.get(id);
    product.set(3, qty);
}

session.setAttribute("productList", productList);

// Redirect user back to cart
response.sendRedirect("showcart.jsp");
%>
