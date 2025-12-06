
<style>
  body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #f4f6f9;
    margin: 0;
    padding: 0;
}

/* HEADER BAR */
.navbar {
    background: #2c3e50;
    padding: 15px;
    text-align: center;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
}
.navbar a {
    color: white;
    margin: 0 15px;
    font-size: 17px;
    text-decoration: none;
    font-weight: 500;
}
.navbar a:hover {
    color: #1abc9c;
}

/* PRODUCT GRID */
.product-grid {
    width: 90%;
    margin: auto;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 25px;
    margin-top: 30px;
}

.product-card {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    transition: .2s;
}
.product-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 18px rgba(0,0,0,0.15);
}

.product-card h3 {
    margin: 0;
    color: #2c3e50;
}
.product-card p {
    color: #666;
}

.price {
    font-size: 20px;
    font-weight: bold;
    color: #27ae60;
}

.btn-add {
    display: inline-block;
    background: #3498db;
    color: white;
    padding: 8px 14px;
    border-radius: 6px;
    margin-top: 12px;
    text-decoration: none;
    transition: .2s;
}
.btn-add:hover {
    background: #2980b9;
}

/* SEARCH BAR */
.search-box {
    text-align: center;
    margin-top: 20px;
}
.search-box input[type=text] {
    width: 350px;
    padding: 10px;
    border-radius: 6px;
    border: 1px solid #bbb;
}
.search-box input[type=submit] {
    padding: 10px 15px;
    background: #27ae60;
    border: none;
    border-radius: 6px;
    color: white;
    cursor: pointer;
}
.search-box input[type=submit]:hover {
    background: #219150;
}

    .nav-header {
        width: 100%;
        background: #3498db;
        padding: 15px 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        margin-bottom: 20px;
        font-family: Arial, sans-serif;
    }

    .nav-container {
        width: 90%;
        margin: auto;
        display: flex;
        align-items: center;
        justify-content: space-between;
        color: white;
    }

    .nav-logo a {
        font-size: 24px;
        font-weight: bold;
        color: white;
        text-decoration: none;
    }

    .nav-menu a {
        color: white;
        text-decoration: none;
        margin-left: 25px;
        font-size: 17px;
        font-weight: bold;
    }

    .nav-menu a:hover {
        text-decoration: underline;
        opacity: 0.85;
    }

    .username {
        margin-left: 20px;
        font-weight: bold;
    }
</style>

<div class="nav-header">
    <div class="nav-container">

        <div class="nav-logo">
            <a href="index.jsp">KC Grocery</a>
        </div>

        <div class="nav-menu">
            <a href="index.jsp">Home</a>
            <a href="listprod.jsp">Products</a>
            <a href="showcart.jsp">Cart</a>
            <a href="customer.jsp">My Profile</a>
            <a href="listorder.jsp">Orders</a>
            <a href="admin.jsp">Admin</a>
            <a href="myOrders.jsp">My Orders</a>

            <% 
                String userNameHeader = (String) session.getAttribute("username");
                if (userNameHeader == null) {
            %>
                <a href="login.jsp">Login</a>
            <% } else { %>
                <span class="username">Hello, <%= userNameHeader %></span>
                <a href="logout.jsp">Logout</a>
            <% } %>
        </div>

    </div>
</div>
