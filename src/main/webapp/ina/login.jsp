<%@ page import="ina.helper.LoginHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<style>
    html{
        font-size: 24px;
    }
    body{
        display: flex;
        justify-content: center;
        align-items: center;

        background-color: rgba(14,129,187,1);
    }
    .container{
        position: relative;

        height: 50%;
        width: 40%;

        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;

        border-radius: 24px;

        background-color: white;
    }
    .loginForm{
        position: relative;

        display: flex;
        justify-items: center;
        align-items: center;
        flex-direction: column;

        background-color: white;
    }
    .input{
        border: none;
        border-bottom: .1rem solid rgba(14,129,187,1);

        height: 2.5rem;
        margin: .5rem;
        font-size: 1.5rem;
    }
    .input:focus{
        border: none;
    }
    .button{
        border: none;
        border-radius: 16px;

        margin: .5rem;
        height: 2.5rem;
        font-size: 1.5rem;

        color: white;
        background: rgba(14,129,187,1);

        transition: 1s;
    }
    .button:hover{
        background: rgba(42,21,203,1);
    }
    .status{
        color: red;
        animation: shake 0.2s;
    }
    @keyframes shake {
        0% { transform: translate(1px, 1px) rotate(0deg); }
        10% { transform: translate(-1px, -2px) rotate(-1deg); }
        20% { transform: translate(-3px, 0px) rotate(1deg); }
        30% { transform: translate(3px, 2px) rotate(0deg); }
        40% { transform: translate(1px, -1px) rotate(1deg); }
        50% { transform: translate(-1px, 2px) rotate(-1deg); }
        60% { transform: translate(-3px, 1px) rotate(0deg); }
        70% { transform: translate(3px, 1px) rotate(-1deg); }
        80% { transform: translate(-1px, -1px) rotate(1deg); }
        90% { transform: translate(1px, 2px) rotate(0deg); }
        100% { transform: translate(1px, -2px) rotate(-1deg); }
    }
    .watermark{
        position: absolute;

        bottom: 0;
        left: 0;
    }
</style>
<%
    // If session has user redirect to content.jsp
    LoginHelper loginHelper = (LoginHelper) session.getAttribute("loginHelper");

    String unmatchedUser = "";
    String loginStatusMessage = "";

    if(loginHelper != null){
        if(loginHelper.getUser() != null){
            // User is logged in
            response.sendRedirect("content.jsp");
            return;
        }

        unmatchedUser = loginHelper.getUnmatchedUser();
        loginStatusMessage = loginHelper.getStatus();
    }
%>
<body>
    <div class="container">
        <h1>Stamp collectors Bocholt</h1>
        <label>Login with your credentials.</label>
        <form class="loginForm" action="LoginServlet" method="get">
            <label>
                <input class="input" type="text" name="username" placeholder="username" value=<%= unmatchedUser %>>
            </label>
            <label>
                <input class="input" type="password" name="password" placeholder="password">
            </label>
            <button class="button" type="submit">Login or Register</button>
            <label class="status">
                <%= loginStatusMessage %>
            </label>
        </form>
    </div>
    <label class="watermark">INA Prüfung SS22 - Adrian Kaminski</label>
</body>
</html>
