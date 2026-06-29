<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Smart Study Analyzer - Login</title>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#7c3aed,#ec4899,#f97316,#06b6d4);
    overflow:hidden;
}

body::before{
    content:"";
    position:absolute;
    width:350px;
    height:350px;
    background:rgba(255,255,255,0.15);
    border-radius:50%;
    top:-100px;
    left:-80px;
}

body::after{
    content:"";
    position:absolute;
    width:300px;
    height:300px;
    background:rgba(255,255,255,0.15);
    border-radius:50%;
    bottom:-100px;
    right:-80px;
}

.container{
    width:950px;
    height:550px;
    display:flex;
    backdrop-filter:blur(15px);
    background:rgba(255,255,255,0.10);
    border-radius:30px;
    overflow:hidden;
    box-shadow:0px 10px 40px rgba(0,0,0,0.25);
    z-index:1;
}

.left{
    width:50%;
    padding:60px;
    color:white;
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.left h1{
    font-size:48px;
    margin-bottom:20px;
}

.features{
    margin-top:30px;
}

.features li{
    list-style:none;
    margin:15px 0;
    font-size:17px;
}

.right{
    width:50%;
    background:white;
    display:flex;
    justify-content:center;
    align-items:center;
}

.login-box{
    width:80%;
}

.login-box h2{
    text-align:center;
    color:#7c3aed;
    margin-bottom:30px;
    font-size:34px;
}

.input-box{
    margin-bottom:18px;
}

.input-box input{
    width:100%;
    padding:14px;
    border:none;
    border-radius:12px;
    background:#f4f4f4;
    font-size:16px;
}

.input-box input:focus{
    outline:none;
    border:2px solid #7c3aed;
}
.password-box{
    position:relative;
}

.password-box input{
    width:100%;
    padding:14px;
    padding-right:50px;
}

.password-box i{
    position:absolute;
    right:18px;
    top:50%;
    transform:translateY(-50%);
    cursor:pointer;
    color:#666;
    font-size:18px;
}

.password-box i:hover{
    color:#7c3aed;
}

button{
    width:100%;
    padding:14px;
    border:none;
    border-radius:12px;
    color:white;
    font-size:18px;
    cursor:pointer;
    background:linear-gradient(135deg,#7c3aed,#ec4899);
}

button:hover{
    transform:scale(1.03);
    transition:0.3s;
}

.footer{
    text-align:center;
    margin-top:20px;
    color:#777;
}

.footer a{
    color:#7c3aed;
    text-decoration:none;
    font-weight:bold;
}

.error{
    color:red;
    text-align:center;
    margin-bottom:15px;
    font-weight:bold;
}

.success{
    color:green;
    text-align:center;
    margin-bottom:15px;
    font-weight:bold;
}
</style>
</head>

<body>

<div class="container">

    <div class="left">
        <h1>Smart Study Analyzer</h1>

        <ul class="features">
            <li>Subject Progress Tracking</li>
            <li>Performance Analytics</li>
            <li>Study Time Monitoring</li>
            <li>Goal Achievement Reports</li>
        </ul>
    </div>

    <div class="right">

        <div class="login-box">

            <h2>Sign In</h2>

            <%
            String msg = request.getParameter("msg");

            if(msg != null){
                if(msg.equals("Registration Successful. Please Login")){
            %>
                    <div class="success"><%= msg %></div>
            <%
                } else {
            %>
                    <div class="error"><%= msg %></div>
            <%
                }
            }
            %>

            <form action="loginProcess.jsp" method="post">

                <div class="input-box">
                    <input type="email" name="email" placeholder="Email Address" required>
                </div>

                <div class="input-box password-box">

    <input
    type="password"
    id="password"
    name="password"
    placeholder="Password"
    required>

    <i class="fa-solid fa-eye"
       id="togglePassword"
       onclick="togglePassword()"></i>

</div>

                <button type="submit">Login</button>

            </form>

            <div class="footer">
                Don't have an account?
                <a href="signup.jsp">Sign Up</a>
            </div>

        </div>

    </div>

</div>
<script>

function togglePassword(){

    var password = document.getElementById("password");
    var eye = document.getElementById("togglePassword");

    if(password.type === "password"){

        password.type = "text";

        eye.classList.remove("fa-eye");
        eye.classList.add("fa-eye-slash");

    }else{

        password.type = "password";

        eye.classList.remove("fa-eye-slash");
        eye.classList.add("fa-eye");

    }

}

</script>

</body>
</html>