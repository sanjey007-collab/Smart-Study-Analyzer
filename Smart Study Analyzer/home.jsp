<%@ page import="java.util.*,java.sql.*" %>

<%
if(session.getAttribute("user") == null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Smart Study Analyzer</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif}
body{min-height:100vh;background:linear-gradient(135deg,#fff1eb,#ace0f9,#fbc2eb);display:flex}
.sidebar{width:260px;background:linear-gradient(180deg,#7c3aed,#ec4899,#f97316);color:white;padding:30px 20px}
.logo{font-size:26px;font-weight:bold;margin-bottom:40px}
.menu a{display:block;padding:15px;margin:14px 0;color:white;text-decoration:none;border-radius:14px;background:rgba(255,255,255,0.18)}
.main{flex:1;padding:35px}
.header,.form-box,.section,.card{background:white;padding:28px;border-radius:25px;box-shadow:0 10px 30px rgba(0,0,0,0.10);margin-bottom:25px}
.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
label{font-weight:bold;color:#374151}
input{width:100%;padding:13px;margin:8px 0 15px;border:2px solid #e5e7eb;border-radius:14px;background:#fafafa;font-size:15px}
.subject-card{margin-top:25px;padding:22px;border-radius:22px;background:linear-gradient(135deg,#fdf2f8,#eef2ff);border:2px solid #f0abfc}
.subject-card h3{color:#7c3aed;margin-bottom:18px}
button{width:100%;margin-top:20px;padding:15px;border:none;border-radius:15px;background:linear-gradient(135deg,#ec4899,#8b5cf6,#06b6d4);color:white;font-size:18px;font-weight:bold;cursor:pointer}
.cards{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:25px}
.card h2{font-size:34px;color:#ec4899}
.card p{color:#6b7280}
.bar{height:30px;background:#e5e7eb;border-radius:30px;overflow:hidden;margin-top:10px}
.fill{height:100%;background:linear-gradient(90deg,#22c55e,#06b6d4,#8b5cf6);color:white;text-align:right;padding-right:12px;line-height:30px;font-weight:bold}
table{width:100%;border-collapse:collapse;margin-top:15px}
th,td{padding:14px;border-bottom:1px solid #e5e7eb;text-align:left}
th{background:#fdf2f8;color:#7c3aed}
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
    <h1>Structured Study Dashboard</h1>
</div>

<%
String step = request.getParameter("step");
String countValue = request.getParameter("subjectCount");
%>

<div class="form-box">

<%
if(step == null){
%>

<h2>Step 1: Enter Number of Subjects</h2>

<form method="post">
    <div class="grid">
        <div>
            <label>Number of Subjects</label>
            <input type="number" name="subjectCount" min="1" required>
        </div>
    </div>

    <input type="hidden" name="step" value="create">
    <button type="submit">Create Subject Input Form</button>
</form>

<%
}
else if(step.equals("create")){
    int subjectCount = Integer.parseInt(countValue);
%>

<h2>Step 2: Enter Subject Details</h2>

<form method="post">

<input type="hidden" name="subjectCount" value="<%= subjectCount %>">
<input type="hidden" name="step" value="report">

<%
for(int i=1;i<=subjectCount;i++){
%>

<div class="subject-card">
    <h3>Subject <%= i %></h3>

    <div class="grid">
        <div>
            <label>Subject Name</label>
            <input type="text" name="subject<%= i %>" required>
        </div>

        <div>
            <label>Total Topics</label>
            <input type="number" name="total<%= i %>" required>
        </div>

        <div>
            <label>Completed Topics</label>
            <input type="number" name="completed<%= i %>" required>
        </div>
    </div>

    <label>Completed Topic Names</label>
    <input type="text" name="topics<%= i %>"
    placeholder="Example: OOP, Inheritance, Threads" required>

    <label>Time Spent for Each Topic</label>
    <input type="text" name="time<%= i %>"
    placeholder="Example: 2, 3, 4" required>
</div>

<%
}
%>

<button type="submit">Generate Complete Report</button>
</form>

<%
}
%>

<%
if(step != null && step.equals("report")){

    int subjectCount = Integer.parseInt(countValue);

    int totalAllTopics = 0;
    int totalCompleted = 0;
    int totalHours = 0;

    ArrayList<String> subjects = new ArrayList<String>();

    HashMap<String, String[]> studyData = new HashMap<String, String[]>();

    HashSet<String> completedSubjects = new HashSet<String>();

    for(int i=1;i<=subjectCount;i++){

        String sub = request.getParameter("subject"+i);

        int total = Integer.parseInt(request.getParameter("total"+i));
        int completed = Integer.parseInt(request.getParameter("completed"+i));

        String topicText = request.getParameter("topics"+i);
        String timeText = request.getParameter("time"+i);

        String topics[] = topicText.split(",");
        String times[] = timeText.split(",");

        int subTime = 0;

        for(String t: times){
            subTime += Integer.parseInt(t.trim());
        }

        double progress = ((double)completed / total) * 100;

        subjects.add(sub);

        studyData.put(sub, new String[]{
            String.valueOf(total),
            String.valueOf(completed),
            String.valueOf(progress),
            topicText,
            timeText,
            String.valueOf(subTime)
        });

        if(progress >= 90){
            completedSubjects.add(sub);
        }

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/study_analyzer",
                "root",
                ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO study_reports(username, subject_name, total_topics, completed_topics, topics, times, total_time, progress) VALUES(?,?,?,?,?,?,?,?)"
            );

            ps.setString(1, session.getAttribute("user").toString());
            ps.setString(2, sub);
            ps.setInt(3, total);
            ps.setInt(4, completed);
            ps.setString(5, topicText);
            ps.setString(6, timeText);
            ps.setInt(7, subTime);
            ps.setDouble(8, progress);

            ps.executeUpdate();

            con.close();

        }catch(Exception e){
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }

        totalAllTopics += total;
        totalCompleted += completed;
        totalHours += subTime;
    }

    double overall = ((double)totalCompleted / totalAllTopics) * 100;
%>

<div class="cards">
    <div class="card"><h2><%= subjects.size() %></h2><p>Total Subjects</p></div>
    <div class="card"><h2><%= totalAllTopics %></h2><p>Total Topics</p></div>
    <div class="card"><h2><%= totalCompleted %></h2><p>Completed Topics</p></div>
    <div class="card"><h2><%= totalHours %></h2><p>Total Study Hours</p></div>
</div>

<div class="section">
    <h2>Overall Progress Graph</h2>
    <div class="bar">
        <div class="fill" style="width:<%= overall %>%;">
            <%= String.format("%.0f",overall) %>%
        </div>
    </div>
</div>

<div class="section">
    <h2>Subject-wise Progress Graph</h2>

<%
for(String subjectName : subjects){

    String data[] = studyData.get(subjectName);
    double progress = Double.parseDouble(data[2]);
%>

    <h3 style="margin-top:20px;">
        <%= subjectName %> - <%= String.format("%.2f",progress) %>%
    </h3>

    <div class="bar">
        <div class="fill" style="width:<%= progress %>%;">
            <%= String.format("%.0f",progress) %>%
        </div>
    </div>

<%
}
%>
</div>

<div class="section">
<h2>Subject Report</h2>

<table>
<tr>
    <th>Subject</th>
    <th>Total Topics</th>
    <th>Completed</th>
    <th>Progress</th>
    <th>Status</th>
</tr>

<%
for(String subjectName : subjects){

    String data[] = studyData.get(subjectName);

    int total = Integer.parseInt(data[0]);
    int completed = Integer.parseInt(data[1]);
    double progress = Double.parseDouble(data[2]);
%>

<tr>
    <td><%= subjectName %></td>
    <td><%= total %></td>
    <td><%= completed %></td>
    <td><%= String.format("%.2f",progress) %>%</td>
    <td>
        <% if(progress >= 90){ %>
            <span class="success">Completed</span>
        <% }else{ %>
            <span class="warning">Need Improvement</span>
        <% } %>
    </td>
</tr>

<%
}
%>
</table>
</div>

<div class="section">
<h2>Completed Subjects</h2>

<%
if(completedSubjects.isEmpty()){
%>

<p class="warning">No subject has reached 90% yet.</p>

<%
}else{
    for(String completedSubject : completedSubjects){
%>

<p class="success"><%= completedSubject %></p>

<%
    }
}
%>
</div>

<div class="section">
<h2>Topic-wise Time Report</h2>

<%
for(String subjectName : subjects){

    String data[] = studyData.get(subjectName);

    String topics[] = data[3].split(",");
    String times[] = data[4].split(",");
%>

<h3 style="margin-top:20px;color:#ec4899;">
    <%= subjectName %>
</h3>

<table>
<tr>
    <th>No</th>
    <th>Topic</th>
    <th>Time Spent</th>
</tr>

<%
for(int j=0;j<topics.length;j++){
%>

<tr>
    <td><%= j+1 %></td>
    <td><%= topics[j].trim() %></td>
    <td><%= times[j].trim() %> Hours</td>
</tr>

<%
}
%>
</table>

<%
}
%>
</div>

<%
}
%>

</div>
</body>
</html>