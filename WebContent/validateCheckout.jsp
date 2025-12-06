<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String input = request.getParameter("customerId");

// 1. Empty input validation
if (input == null || input.trim().equals("")) {
    response.sendRedirect("checkout.jsp?error=Customer ID cannot be empty");
    return;
}

// 2. Must be a number
int customerId = 0;
try {
    customerId = Integer.parseInt(input);
} catch (NumberFormatException e) {
    response.sendRedirect("checkout.jsp?error=Customer ID must be numeric");
    return;
}

// 3. Check database
try {
    getConnection();
    String sql = "SELECT * FROM customer WHERE customerId = ?";
    PreparedStatement stmt = con.prepareStatement(sql);
    stmt.setInt(1, customerId);

    ResultSet rs = stmt.executeQuery();

    if (!rs.next()) {
        // Customer does not exist
        response.sendRedirect("checkout.jsp?error=Customer ID not found");
        return;
    }

    // Customer exists — continue to order.jsp
    response.sendRedirect("order.jsp?customerId=" + customerId);

} catch (Exception e) {
    response.sendRedirect("checkout.jsp?error=Database error");
}
%>
