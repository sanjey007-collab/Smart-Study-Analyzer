<%@ page import="java.util.*,java.sql.*" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Study Insights</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{min-height:100vh;background:linear-gradient(135deg,#fff1eb,#ace0f9,#fbc2eb);display:flex}
.sidebar{width:260px;background:linear-gradient(180deg,#7c3aed,#ec4899,#f97316);color:white;padding:30px 20px}
.logo{font-size:26px;font-weight:bold;margin-bottom:40px}
.menu a{display:block;padding:15px;margin:14px 0;color:white;text-decoration:none;border-radius:14px;background:rgba(255,255,255,0.18)}
.main{flex:1;padding:35px}
.header,.section,.card{background:white;padding:28px;border-radius:25px;box-shadow:0 10px 30px rgba(0,0,0,0.10);margin-bottom:25px}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-bottom:25px}
.card h2{font-size:34px;color:#ec4899}
.card p{color:#6b7280}
.success{color:#16a34a;font-weight:bold}
.warning{color:#d97706;font-weight:bold}
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
    <h1>Study Insights</h1>
</div>

<%
int totalSubjects = 0;
int totalTopics = 0;
int completedTopics = 0;
int totalHours = 0;
double overall = 0;
%>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/study_analyzer",
        "root",
        ""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM study_reports WHERE username=?"
    );

    ps.setString(1, session.getAttribute("user").toString());

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
        totalSubjects++;
        totalTopics += rs.getInt("total_topics");
        completedTopics += rs.getInt("completed_topics");
        totalHours += rs.getInt("total_time");
    }

    if(totalTopics > 0){
        overall = ((double)completedTopics / totalTopics) * 100;
    }

    con.close();

}catch(Exception e){
    out.println("<pre>");
    e.printStackTrace(new java.io.PrintWriter(out));
    out.println("</pre>");
}
%>

<div class="cards">
    <div class="card"><h2><%= totalSubjects %></h2><p>Total Subjects</p></div>
    <div class="card"><h2><%= totalHours %></h2><p>Total Study Hours</p></div>
    <div class="card"><h2><%= String.format("%.0f",overall) %>%</h2><p>Overall Progress</p></div>
</div>

<div class="section">
<h2>Study Suggestion</h2>

<%
if(overall >= 90){
%>
<p class="success">Excellent! Your study progress is very good.</p>
<%
}else if(overall >= 60){
%>
<p class="warning">Good progress. Try to complete the remaining topics soon.</p>
<%
}else{
%>
<p class="warning">You need to improve your study progress. Spend more time on pending topics.</p>
<%
}
%>

</div>

</div>
</body>
</html>