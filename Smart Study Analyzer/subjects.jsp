<%@ page import="java.util.*,java.sql.*" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Subjects</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{min-height:100vh;background:linear-gradient(135deg,#fff1eb,#ace0f9,#fbc2eb);display:flex}
.sidebar{width:260px;background:linear-gradient(180deg,#7c3aed,#ec4899,#f97316);color:white;padding:30px 20px}
.logo{font-size:26px;font-weight:bold;margin-bottom:40px}
.menu a{display:block;padding:15px;margin:14px 0;color:white;text-decoration:none;border-radius:14px;background:rgba(255,255,255,0.18)}
.main{flex:1;padding:35px}
.header,.section{background:white;padding:28px;border-radius:25px;box-shadow:0 10px 30px rgba(0,0,0,0.10);margin-bottom:25px}
table{width:100%;border-collapse:collapse;margin-top:15px}
th,td{padding:14px;border-bottom:1px solid #e5e7eb;text-align:left}
th{background:#fdf2f8;color:#7c3aed}
</style>
</head>

<body>

<div class="sidebar">
    <div class="logo">Smart Study Analyzer</div>
    <div class="menu">
        <a href="home.jsp">Dashboard</a>
        <a href="subjects.jsp">Subjects</a>
        <a href="progressReports.jsp">Progress Reports</a>
        <a href="studyInsights.jsp">Study Insights</a>
        <a href="logout.jsp">Logout</a>
    </div>
</div>

<div class="main">

<div class="header">
    <h1>Subjects</h1>
</div>

<div class="section">
<h2>Your Subject Details</h2>

<table>
<tr>
    <th>Subject</th>
    <th>Total Topics</th>
    <th>Completed Topics</th>
</tr>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/study_analyzer",
        "root",
        ""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT subject_name,total_topics,completed_topics FROM study_reports WHERE username=?"
    );

    ps.setString(1, session.getAttribute("user").toString());

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>
    <td><%= rs.getString("subject_name") %></td>
    <td><%= rs.getInt("total_topics") %></td>
    <td><%= rs.getInt("completed_topics") %></td>
</tr>

<%
    }

    con.close();

}catch(Exception e){
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
}
%>

</table>
</div>

</div>
</body>
</html>