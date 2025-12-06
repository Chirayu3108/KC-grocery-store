<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>

    <style>
        body { font-family: Arial, sans-serif; background-color: #f7f7f7; margin: 0; padding: 0; }
        h1, h2 { text-align: center; color: #2c3e50; }
        .profile-container {
            width: 55%; margin: 30px auto; background: #fff;
            padding: 25px 35px; border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 15px; }
        label { font-weight: bold; color: #555; }
        input[type=text], input[type=email], input[type=tel] {
            width: 100%; padding: 10px; border-radius: 6px;
            border: 1px solid #ddd; margin-top: 5px;
        }
        input[type=submit] {
            width: 100%; padding: 12px; background: #3498db;
            border: none; border-radius: 6px; color: white;
            cursor: pointer; font-size: 16px; margin-top: 10px;
        }
        input[type=submit]:hover { background: #2980b9; }
        .readonly { background: #eee; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<%
    

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Variables for user data
    String firstName="", lastName="", email="", phone="", address="", city="", state="", postalCode="", country="";

    try {
        getConnection();
        String sql = "SELECT * FROM customer WHERE customerId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            phone = rs.getString("phonenum");
            address = rs.getString("address");
            city = rs.getString("city");
            state = rs.getString("state");
            postalCode = rs.getString("postalCode");
            country = rs.getString("country");
        }
    } catch (SQLException e) {
        out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
%>

<h1>Your Profile</h1>
<h2>Edit Your Information</h2>

<div class="profile-container">
    <form action="updateUser.jsp" method="post">

        <div class="form-group">
            <label>Customer ID</label>
            <input type="text" name="customerId" class="readonly" readonly value="<%= userId %>">
        </div>

        <div class="form-group"><label>First Name</label>
            <input type="text" name="firstName" value="<%= firstName %>" required></div>

        <div class="form-group"><label>Last Name</label>
            <input type="text" name="lastName" value="<%= lastName %>" required></div>

        <div class="form-group"><label>Email</label>
            <input type="email" name="email" value="<%= email %>" required></div>

        <div class="form-group"><label>Phone</label>
            <input type="tel" name="phone" value="<%= phone %>"></div>

        <div class="form-group"><label>Address</label>
            <input type="text" name="address" value="<%= address %>" required></div>

        <div class="form-group"><label>City</label>
            <input type="text" name="city" value="<%= city %>" required></div>

        <div class="form-group"><label>State</label>
            <input type="text" name="state" value="<%= state %>" required></div>

        <div class="form-group"><label>Postal Code</label>
            <input type="text" name="postalCode" value="<%= postalCode %>" required></div>

        <div class="form-group"><label>Country</label>
            <input type="text" name="country" value="<%= country %>" required></div>

        <input type="submit" value="Save Changes">

    </form>
</div>

</body>
</html>
