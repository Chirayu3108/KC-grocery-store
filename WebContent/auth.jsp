<%
	String username = (String) session.getAttribute("username");
    String userId = (String) session.getAttribute("userId");

    if (username == null || userId == null) {
        String loginMessage = "You must log in before accessing: " + request.getRequestURL();
        session.setAttribute("loginMessage", loginMessage);
        response.sendRedirect("login.jsp");
        return;
    }
%>
