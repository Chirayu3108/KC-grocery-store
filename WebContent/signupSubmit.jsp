<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String sql = "INSERT INTO customer (firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid,password) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

try {
    getConnection();
    PreparedStatement stmt = con.prepareStatement(sql);

    stmt.setString(1, request.getParameter("firstName"));
    stmt.setString(2, request.getParameter("lastName"));
    stmt.setString(3, request.getParameter("email"));
    stmt.setString(4, request.getParameter("phonenum"));
    stmt.setString(5, request.getParameter("address"));
    stmt.setString(6, request.getParameter("city"));
    stmt.setString(7, request.getParameter("state"));
    stmt.setString(8, request.getParameter("postalCode"));
    stmt.setString(9, request.getParameter("country"));
    stmt.setString(10, request.getParameter("userid"));
    stmt.setString(11, request.getParameter("password"));

    stmt.executeUpdate();

    out.println("<h2>Account created successfully!</h2>");
    out.println("<a href='login.jsp'>Click here to login</a>");

} catch(Exception e) {
    out.println("<h2>Error creating account.</h2>");
    out.println(e.getMessage());
}
%>
