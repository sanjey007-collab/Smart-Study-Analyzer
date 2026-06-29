<%@ page import="java.sql.*" %>

<%
String email = request.getParameter("email");
String password = request.getParameter("password");

try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/study_analyzer",
        "root",
        ""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM users WHERE email=? AND password=?"
    );

    ps.setString(1, email);
    ps.setString(2, password);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        String username = rs.getString("username");

        session.setAttribute("user", username);

        response.sendRedirect("home.jsp");
    }
    else{
        response.sendRedirect("login.jsp?msg=Invalid Email or Password");
    }

    con.close();
}
catch(Exception e){
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
}
%>