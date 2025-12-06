<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>KC Grocery - Products</title>

<!-- ======= MODERN UI STYLES ======= -->
<style>

body {
    font-family: Arial, sans-serif;
    background: #f3f6fa;
    margin: 0;
    padding: 0;
}

.page-container {
    max-width: 1200px;
    margin: auto;
    padding: 20px;
}

/* SEARCH BAR */
.search-box {
    display: flex;
    justify-content: center;
    margin: 20px 0;
}

.search-box input[type="text"] {
    width: 400px;
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.search-box input[type="submit"] {
    background: #28a745;
    border: none;
    color: white;
    padding: 10px 18px;
    margin-left: 8px;
    border-radius: 6px;
    cursor: pointer;
}

/* SECTION TITLES */
.section-title {
    font-size: 24px;
    font-weight: bold;
    margin: 25px 0 10px 0;
}

/* PRODUCT GRID */
.product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
    gap: 20px;
}

.product-card {
    background: white;
    padding: 15px;
    border-radius: 12px;
    box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
    transition: transform .2s;
}

.product-card:hover {
    transform: translateY(-4px);
}

.product-card h3 a {
    text-decoration: none;
    color: #007bff;
    font-size: 18px;
}

.product-card h3 a:hover {
    text-decoration: underline;
}

.price {
    color: #555;
    font-size: 17px;
    margin-bottom: 10px;
}

.btn-add {
    display: inline-block;
    padding: 10px 14px;
    background: #3498db;
    color: white;
    border-radius: 8px;
    text-decoration: none;
}

.btn-add:hover {
    background: #2c80b8;
}

/* TOP SELLING SECTION CARDS */
.top-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0px 2px 5px rgba(0,0,0,0.12);
}

/* CHAT TOGGLE BUTTON */
#chat-toggle {
    position: fixed;
    bottom: 25px;
    right: 25px;
    background: #3498db;
    color: white;
    width: 55px;
    height: 55px;
    border-radius: 50%;
    border: none;
    cursor: pointer;
    font-size: 26px;
    box-shadow: 0 0 10px rgba(0,0,0,0.25);
}

/* CHATBOX */
#chat-container {
    width: 350px;
    height: 450px;
    border: 1px solid #ccc;
    position: fixed;
    right: 20px;
    bottom: 95px;
    background: white;
    display: none;
    flex-direction: column;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 0 10px rgba(0,0,0,0.15);
}

#chat-window {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
}

.message {
    margin: 8px 0;
    padding: 10px;
    border-radius: 8px;
    max-width: 80%;
}

.user { background: #3498db; color: white; margin-left: auto; }
.bot { background: #eee; color: black; }

#chat-input-area { display: flex; }
#chat-input {
    flex: 1;
    padding: 10px;
    border: none;
    border-top: 1px solid #ddd;
}

#chat-container button {
    padding: 10px;
    background: #3498db;
    border: none;
    color: white;
}

</style>

</head>
<body>

<jsp:include page="header.jsp" />

<div class="page-container">

<!-- SEARCH BAR -->
<div class="search-box">
<form method="get" action="listprod.jsp">
    <input type="text" name="productName" placeholder="Search products…">
    <input type="submit" value="Search">
</form>
</div>

<%
String name = request.getParameter("productName");
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://cosc304-sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try(Connection con = DriverManager.getConnection(url,uid,pw)) {

        // -------- TOP SELLING PRODUCTS --------
        out.println("<div class='section-title'>🔥 Top Selling Products</div>");

        String topSql =
            "SELECT TOP 4 p.productId, p.productName, SUM(o.quantity) AS totalSold " +
            "FROM product p JOIN orderproduct o ON p.productId = o.productId " +
            "GROUP BY p.productId, p.productName ORDER BY totalSold DESC";

        PreparedStatement topStmt = con.prepareStatement(topSql);
        ResultSet topRs = topStmt.executeQuery();

        out.println("<div class='product-grid'>");

        while (topRs.next()) {
            int tid = topRs.getInt("productId");
            String tname = topRs.getString("productName");
            int sold = topRs.getInt("totalSold");

            out.println("<div class='top-card'>");
            out.println("<h3><a href='product.jsp?productId=" + tid + "'>" + tname + "</a></h3>");
            out.println("<p><strong>Sold:</strong> " + sold + "</p>");
            out.println("</div>");
        }

        out.println("</div>");

        // -------- PRODUCT LISTING --------
        out.println("<div class='section-title'>✨ All Products</div>");

        PreparedStatement pstmt;
        String filter = request.getParameter("filter");

        if ("cheap".equals(filter)) {
            pstmt = con.prepareStatement("SELECT * FROM product WHERE productPrice < 20");
        }
        else if (name != null && !name.trim().equals("")) {
            pstmt = con.prepareStatement("SELECT * FROM product WHERE productName LIKE ?");
            pstmt.setString(1, "%" + name + "%");
        }
        else {
            pstmt = con.prepareStatement("SELECT * FROM product");
        }

        ResultSet rst = pstmt.executeQuery();

        out.println("<div class='product-grid'>");

        while (rst.next()) {
            int id = rst.getInt("productId");
            String pname = rst.getString("productName");
            double price = rst.getDouble("productPrice");

            String urlAdd = "addcart.jsp?id=" + id 
                + "&name=" + URLEncoder.encode(pname, "UTF-8") 
                + "&price=" + price;

            out.println("<div class='product-card'>");
            out.println("<h3><a href='product.jsp?productId=" + id + "'>" + pname + "</a></h3>");
            out.println("<p class='price'>" + currFormat.format(price) + "</p>");
            out.println("<a class='btn-add' href='" + urlAdd + "'>Add to Cart</a>");
            out.println("</div>");
        }

        out.println("</div>");
    }

} catch (Exception e) {
    out.println("Error: " + e);
}
%>

</div>

<!-- CHAT TOGGLE BUTTON -->
<button id="chat-toggle" onclick="toggleChat()">💬</button>

<!-- CHAT BOX -->
<div id="chat-container">
    <div id="chat-window"></div>
    <div id="chat-input-area">
        <input type="text" id="chat-input" placeholder="Ask me anything...">
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<script>
function toggleChat() {
    let box = document.getElementById("chat-container");
    box.style.display = (box.style.display === "flex") ? "none" : "flex";
}

function sendMessage() {
    let input = document.getElementById("chat-input");
    let text = input.value.trim();
    if (text === "") return;

    addMsg(text, "user");
    input.value = "";

    setTimeout(() => {
        let reply = botReply(text);
        addMsg(reply, "bot");
    }, 600);
}

function addMsg(msg, type) {
    let win = document.getElementById("chat-window");
    let div = document.createElement("div");
    div.className = "message " + type;
    div.innerText = msg;
    win.appendChild(div);
    win.scrollTop = win.scrollHeight;
}

function botReply(text) {
    text = text.toLowerCase();

    if (text.includes("cheap")) {
        setTimeout(() => { window.location = "listprod.jsp?filter=cheap"; }, 500);
        return "Showing cheap products!";
    }

    if (text.includes("hello") || text.includes("hi"))
        return "Hello! How can I help you today? 😊";

    if (text.includes("recommend"))
        return "I recommend checking the 🔥 Top Selling Products above!";

    return "I'm still learning, but I’ll improve soon!";
}
</script>

</body>
</html>
