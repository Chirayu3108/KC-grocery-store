<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String customerId = request.getParameter("customerId");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");

String sql = "UPDATE customer SET firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=? WHERE customerId=?";

try {
    getConnection();

    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, firstName);
    pstmt.setString(2, lastName);
    pstmt.setString(3, email);
    pstmt.setString(4, phone);
    pstmt.setString(5, address);
    pstmt.setString(6, city);
    pstmt.setString(7, state);
    pstmt.setString(8, postalCode);
    pstmt.setString(9, country);
    pstmt.setString(10, customerId);

    int rows = pstmt.executeUpdate();

    if (rows > 0) {
        out.println("<script>alert('Profile updated successfully!'); window.location='customer.jsp';</script>");
    } else {
        out.println("<script>alert('Error updating account.'); window.location='customer.jsp';</script>");
    }

} catch (SQLException e) {
    out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
} finally {
    closeConnection();
}
%>
