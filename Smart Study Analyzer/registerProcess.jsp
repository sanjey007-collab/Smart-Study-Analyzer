<%@ page import="java.sql.*" %>

<%
String username = request.getParameter("username");

String email = request.getParameter("email");
String password = request.getParameter("password");

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    // Get environment variables
    String dbHost = System.getenv("DB_HOST");
    String dbPort = System.getenv("DB_PORT");
    String dbName = System.getenv("DB_NAME");
    String dbUser = System.getenv("DB_USER");
    String dbPass = System.getenv("DB_PASSWORD");

    // Build URL with SSL
    String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=true&requireSSL=true";

    Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

    // ---------- AUTO-CREATE TABLES (copy this block) ----------
    try {
        Statement stmt = con.createStatement();
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "username VARCHAR(50) UNIQUE NOT NULL, " +
            "email VARCHAR(100) UNIQUE NOT NULL, " +
            "password VARCHAR(255) NOT NULL)");
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS analyzer_reports (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "username VARCHAR(50) NOT NULL, " +
            "subject_name VARCHAR(100) NOT NULL, " +
            "total_topics INT NOT NULL, " +
            "completed_topics INT NOT NULL, " +
            "topics TEXT, " +
            "times TEXT, " +
            "total_time INT DEFAULT 0, " +
            "progress DECIMAL(5,2) DEFAULT 0, " +
            "FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE)");
        stmt.close();
    } catch (Exception e) {
        // ignore if tables already exist
    }
    // ---------- END OF AUTO-CREATE ----------

    PreparedStatement check = con.prepareStatement(
        "SELECT * FROM users WHERE email=?"
    );

    check.setString(1, email);
    ResultSet rs = check.executeQuery();

    if(rs.next()){
        response.sendRedirect("signup.jsp?msg=Email Already Registered");
    }
    else{
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO users(username,email,password) VALUES(?,?,?)"
        );

        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, password);

        int i = ps.executeUpdate();

        if(i > 0){
            response.sendRedirect("login.jsp?msg=Registration Successful. Please Login");
        }
        else{
            response.sendRedirect("signup.jsp?msg=Registration Failed");
        }
    }

    con.close();
}
catch(Exception e){
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
}
%>
