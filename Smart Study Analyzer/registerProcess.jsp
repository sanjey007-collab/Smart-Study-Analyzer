<%@ page import="java.sql.*" %>

<%
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/study_analyzer",
        "root",
        ""
    );

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