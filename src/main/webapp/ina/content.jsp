<%@ page import="ina.helper.LoginHelper" %>
<%@ page import="ina.objects.User" %>
<%@ page import="ina.objects.Stamp" %>
<%@ page import="ina.objects.StampsList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>Stamp collection</title>
</head>
<style>
    html{
        font-size: 24px;
    }
    body{
        margin: 0;

        background: rgba(42,21,203,1);
    }
    .user{
        position: relative;

        width: 100%;
        height: 2.5rem;

        font-size: 1rem;

        background: rgba(42,21,203,1);
    }
    .user *{
        position: absolute;

        top: 50%;
        transform: translateY(-50%);

        width: 15%;

        text-align: center;
        text-decoration: none;
        color: rgba(143,213,218,1);

        transition: 1s;
    }
    .user *:hover{
        color: white;
    }
    .user *:nth-child(1){
        left: 10%;
    }
    .user a:nth-child(2){
        transform: translate(-50%, -50%);
        left: 50%;
    }
    .user a:nth-child(3){
        transform: translate(-50%, -50%);
        left: 67.5%;
    }
    .user a:nth-child(4){
        transform: translate(-50%, -50%);
        left: 82.5%;
    }
    .dot{
        position: absolute;

        height: .125rem;
        width: 10%;

        top: 75%;

        border-radius: 16px;

        background-color: white;

        left: 10%;
        opacity: 0;
        transition: .75s;
    }
    .user a:nth-child(2):hover ~ .dot{
        transform: translate(-50%, -50%);
        left: 50%;
        opacity: 1;
    }
    .user a:nth-child(3):hover ~ .dot{
        transform: translate(-50%, -50%);
        left: 67.5%;
        opacity: 1;
    }
    .user a:nth-child(4):hover ~ .dot{
        transform: translate(-50%, -50%);
        left: 82.5%;
        opacity: 1;
    }
    #stampCollection{
        width: 100%;

        font-size: .75rem;

        border-spacing: 0;
        border-collapse: collapse;
    }
    #stampCollection th{
        background-color: rgba(143,213,218,1);
    }
    #stampCollection tr{
        height: 1.5rem;

        background-color: white;
    }
    #stampCollection tr:nth-child(2n + 1){
        background-color: lightgrey;
    }
    .button{
        position: relative;

        border: 4px solid rgba(42,21,203,1);
        border-radius: 16px;

        height: 2.5rem;
        font-size: 1.5rem;

        color: white;
        background: rgba(14,129,187,1);

        transition: 1s;
    }
    .button:hover{
        border: 4px solid rgba(14,129,187,1);

        background: rgba(42,21,203,1);
    }
    #toggleFavorite{
        width: 5%;
        color: red;
    }
    .favorite > #toggleFavorite{
        color: chartreuse;
    }
</style>
<%
    LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");

    if(loginHelper == null || loginHelper.getUser() == null){
        // User has no session
        response.sendRedirect("index.jsp");
        return;
    }

    User user = loginHelper.getUser();
%>
<body>
    <div class="user">
        <label><%= "Username: " + user.getUsername() %></label>
        <a href=<%= user.isAdmin() ? "edit.jsp" : "" %>> <%= user.isAdmin() ? "Manage inventory" : "" %></a>
        <a href="logout.jsp">Logout user</a>
        <a href="delete.jsp">Delete user</a>
        <div class="dot"></div>
    </div>
    <table id="stampCollection">
        <tr>
            <th onclick="sortTable(0)">Name</th>
            <th onclick="sortTable(1)">Value</th>
            <th onclick="sortTable(2)">Quantity</th>
            <th onclick="sortTable(3)">Published</th>
            <th onclick="sortTable(4)">Motif</th>
            <th onclick="sortTable(5)">Total value</th>
            <th></th>
        </tr>
        <%
            for(Stamp stamp : StampsList.getStamps()){
                boolean isFavorite = user.getFavoriteStamps().contains(stamp);
        %>
        <tr <%= isFavorite ? "class=\"favorite\"" : "" %>>
            <td id="stampName"><%= stamp.getName() %></td>
            <td><%= stamp.getValue() != null ? StampsList.formatNumber(stamp.getValue()) : "" %></td>
            <td><%= stamp.getQuantity() != null ? stamp.getQuantity() : ""  %></td>
            <td><%= stamp.getPublishedDate() + " " + stamp.getPublishedCountry() %></td>
            <td><%= stamp.getMotif() %></td>
            <td><%= StampsList.formatNumber(stamp.getSummedValue()) %></td>
            <td id="toggleFavorite" onclick="toggleFavorite(parentNode)"><%= isFavorite ? "Uncheck" : "Check" %></td>
        </tr>
        <%
            }
        %>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td><%= StampsList.formatNumber(StampsList.getSummedValue()) %></td>
            <td></td>
        </tr>
    </table>
    <form id="invisibleForm" action="EditServlet" method="post"></form>
    <button class="button" type="submit" form="invisibleForm">Save changes</button>
</body>
<script>
    function sortTable(n) {
        let table = document.getElementById("stampCollection");

        let shouldSwitch = false;
        let switching = true;
        let switchCount = 0;
        let ascending = true;
        let i = 0;

        while (switching) {
            switching = false;

            let rows = table.rows;

            for (i = 1; i < (rows.length - 1) - 1; i++) {
                shouldSwitch = false;

                let x = rows[i].getElementsByTagName("TD")[n];
                let y = rows[i + 1].getElementsByTagName("TD")[n];

                if(n === 1 || n === 2 || n === 5){
                    let numX, numY, factor;
                    if(n === 1 || n === 5){
                        factor = x.innerHTML.trim().endsWith("k") ? 1000 : x.innerHTML.trim().endsWith("m") ? 1000000 : -1;
                        let value = x.innerHTML.trim().substring(0, x.innerHTML.length - 1);
                        let digitAfterComma = value.includes(",") ? value.split(",")[1].length : 0;
                        numX = Number(value.replace(",", "")) * factor / (Math.pow(10, digitAfterComma));

                        factor = y.innerHTML.trim().endsWith("k") ? 1000 : y.innerHTML.trim().endsWith("m") ? 1000000 : -1;
                        value = y.innerHTML.trim().substring(0, y.innerHTML.length - 1);
                        digitAfterComma = value.includes(",") ? value.split(",")[1].length : 0;
                        numY = Number(value.replace(",", "")) * factor / (Math.pow(10, digitAfterComma));
                    } else {
                        numX = x.innerHTML;
                        numY = y.innerHTML;
                    }
                    if (ascending) {
                        [numX, numY] = [numY, numX];
                    }
                    if (Number(numX) < Number(numY)) {
                        shouldSwitch = true;
                        break;
                    }
                } else {
                    let valueX = x.innerHTML;
                    let valueY = y.innerHTML;
                    if (ascending) {
                        [valueX, valueY] = [valueY, valueX];
                    }
                    if (valueX.toLowerCase() > valueY.toLowerCase()) {
                        shouldSwitch = true;
                        break;
                    }
                }
            }

            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchCount ++;
            } else {
                if (switchCount === 0 && ascending) {
                    ascending = !ascending;
                    switching = true;
                }
            }
        }
    }

    let invisibleForm = document.getElementById("invisibleForm");

    // Mark favorites as favorites
    function updateFavorites(stamp){
        let span = stamp.querySelector('#toggleFavorite');
        if(stamp.classList.contains("favorite")){
            span.innerHTML = "Uncheck";
        } else {
            span.innerHTML = "Check";
        }
    }

    function toggleFavorite(x){
        let input = document.createElement("input");
        input.type = "hidden";

        x.classList.toggle("favorite");

        if(!x.classList.contains("favorite")){
            input.name = "uncheck";
        } else {
            input.name = "check";
        }

        let stampName = x.querySelector('#stampName').innerText;
        input.value = stampName;

        // Prevents duplicates
        let duplicate = false;
        for (let i = 0; i < invisibleForm.children.length; i++) {
            let child = invisibleForm.children.item(i);
            if(child.value === stampName) {
                if(child.name === input.name){
                    duplicate = true;
                    break;
                } else {
                    duplicate = false;
                    invisibleForm.removeChild(child);
                    break;
                }
            }
        }

        if(!duplicate) {
            invisibleForm.append(input);
        }

        updateFavorites(x);
    }
</script>
</html>
