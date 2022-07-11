<%@ page import="ina.helper.LoginHelper" %>
<%@ page import="ina.objects.User" %>
<%@ page import="ina.objects.Stamp" %>
<%@ page import="ina.objects.StampsList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage inventory</title>
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
    #editBtn, #removeBtn, #saveBtn{
        position: relative;

        width: 100%;
        height: 1.5rem;

        font-size: 0.75rem;

        border: none;
        background-color: rgba(143,213,218,1);

        transition: .5s;
    }
    #editBtn:hover, #removeBtn:hover, #saveBtn:hover{
        background-color: rgba(14,129,187,1);
    }
    input{
        height: 1.5rem;
        width: 100%;

        font-size: .75rem;
    }
    .button{
        position: relative;

        border: 4px solid rgba(42,21,203,1);
        border-radius: 16px;

        height: 2.5rem;
        font-size: 1.5rem;

        color: white;
        background-color: rgba(14,129,187,1);

        transition: 1s;
    }
    .button:hover{
        border: 4px solid rgba(14,129,187,1);

        background-color: rgba(42,21,203,1);
    }
</style>
<%
    LoginHelper loginHelper = (LoginHelper) request.getSession().getAttribute("loginHelper");

    if(loginHelper == null || loginHelper.getUser() == null || !loginHelper.getUser().isAdmin()){
        // User has no session or isn't an admin
        response.sendRedirect("index.jsp");
        return;
    }

    User user = loginHelper.getUser();
%>
<body>
<div class="user">
    <label><%= "Username: " + user.getUsername() %></label>
    <a href="content.jsp">Stamp collection</a>
    <a href="logout.jsp">Logout user</a>
    <a href="delete.jsp">Delete user</a>
    <div class="dot"></div>
</div>
    <div>
        <table id="stampCollection">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Value</th>
                <th>Quantity</th>
                <th>Published</th>
                <th>Motif</th>
                <th></th>
                <th></th>
                <th></th>
            </tr>
            <%
                for(Stamp stamp : StampsList.getStamps()){
            %>
            <tr>
                <td><%= "#" + stamp.getStampID() %></td>
                <td><%= stamp.getName() %></td>
                <td><%= stamp.getValue() != null ? stamp.getValue() : "" %></td>
                <td><%= stamp.getQuantity() != null ? stamp.getQuantity() : "" %></td>
                <td><%= stamp.getPublishedDate() + " " + stamp.getPublishedCountry() %></td>
                <td><%= stamp.getMotif() %></td>
                <td><button id="editBtn" type="button" onclick="editStamp(this)">Edit</button></td>
                <td><button id="removeBtn" type="button" onclick="removeStamp(this)">Remove</button></td>
                <td><button style="visibility: hidden" id="saveBtn" type="button" onclick="saveStamp(this)">Save</button></td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
    <form id="invisibleForm" action="EditServlet" method="post"></form>
    <button class="button" type="submit" form="invisibleForm">Save changes</button>
    <button style="float: right" class="button" type="button" onclick="addStamp()">Add stamp</button>
</body>
<script>
    let table = document.getElementById("stampCollection");

    let invisibleForm = document.getElementById("invisibleForm");

    function updateRow(row, mode){
        let stampString = "";
        for (let i = 0; i < row.children.length; i++) {
            let cell = row.cells[i];

            let x = cell.children.length;

            if(x === 0){
                stampString += cell.innerText + "|";
            } else {
                stampString += cell.children[0].value + "|";
            }
        }

        let input = document.createElement("input");
        input.type = "hidden";
        if(mode === "add"){
            input.name = "addStamp";
        }
        else if(mode === "del"){
            input.name = "deleteStamp";
        }
        input.value = stampString;

        invisibleForm.append(input);
    }


    function removeStamp(x){
        let row = x.parentNode.parentNode;

        updateRow(row, "del");

        table.deleteRow(row.rowIndex);
    }

    function addStamp(){
        let row = table.insertRow();

        let cell = row.insertCell(0);
        cell.append("#");

        cell = row.insertCell(1);
        let input = document.createElement("input")
        input.placeholder = "name";
        cell.appendChild(input);

        cell = row.insertCell(2);
        input = document.createElement("input")
        input.placeholder = "value";
        cell.appendChild(input);

        cell = row.insertCell(3);
        input = document.createElement("input")
        input.placeholder = "quantity";
        cell.appendChild(input);

        cell = row.insertCell(4);
        input = document.createElement("input")
        input.placeholder = "year location";
        cell.appendChild(input);

        cell = row.insertCell(5);
        input = document.createElement("input")
        input.placeholder = "motif";
        cell.appendChild(input);

        // Only for style purposes
        cell = row.insertCell(6);
        let button = document.createElement("button");
        button.id = "editBtn";
        button.type = "button";
        button.setAttribute("onclick", "removeStamp(this);");
        button.innerHTML = "Edit";
        cell.appendChild(button);

        button.style.visibility = "hidden";

        cell = row.insertCell(7);
        button = document.createElement("button");
        button.id = "removeBtn";
        button.type = "button";
        button.setAttribute("onclick", "removeStamp(this);");
        button.innerHTML = "Remove";
        cell.appendChild(button);

        cell = row.insertCell(8);
        button = document.createElement("button");
        button.id = "saveBtn";
        button.type = "button";
        button.setAttribute("onclick", "saveStamp(this);");
        button.innerHTML = "Save";
        cell.appendChild(button);
    }

    function saveStamp(x){
        // TODO: If clicking save when nothing was changed server redirect you to content.jsp but you should stay on edit.jsp

        let row = x.parentNode.parentNode;

        // Get values
        let valueArray = [];
        //valueArray[0] = row.cells[0].children[0].value;
        if(row.cells[0].children.length === 0){
            valueArray[0] = row.cells[0].innerText;
        }
        else if(row.cells[0].children.length === 1){
            valueArray[0] = row.cells[0].children[0].value;
        }
        valueArray[1] = row.cells[1].children[0].value;
        valueArray[2] = row.cells[2].children[0].value;
        valueArray[3] = row.cells[3].children[0].value;
        valueArray[4] = row.cells[4].children[0].value;
        valueArray[5] = row.cells[5].children[0].value;

        // Delete old cells
        row.innerHTML = "";

        // Add new cells as label fields
        let cell = row.insertCell(0);
        cell.append(valueArray[0]);

        cell = row.insertCell(1);
        cell.append(valueArray[1]);

        cell = row.insertCell(2);
        cell.append(valueArray[2]);

        cell = row.insertCell(3);
        cell.append(valueArray[3]);

        cell = row.insertCell(4);
        cell.append(valueArray[4]);

        cell = row.insertCell(5);
        cell.append(valueArray[5]);

        cell = row.insertCell(6);
        let button = document.createElement("button")
        button.id = "editBtn";
        button.type = "button";
        button.setAttribute("onclick", "editStamp(this);");
        button.innerHTML = "Edit";
        cell.appendChild(button);

        cell = row.insertCell(7);
        button = document.createElement("button");
        button.id = "removeBtn";
        button.type = "button";
        button.setAttribute("onclick", "removeStamp(this);");
        button.innerHTML = "Remove";
        cell.appendChild(button);

        // Only for style purposes
        cell = row.insertCell(8);
        button = document.createElement("button");
        button.id = "saveBtn";
        button.type = "button";
        button.setAttribute("onclick", "saveBtn(this);");
        button.innerHTML = "Save";
        cell.appendChild(button);

        button.style.visibility = "hidden";

        updateRow(row, "add");
    }

    function editStamp(x){
        let row = x.parentNode.parentNode;

        // Get values
        let valueArray = [];
        valueArray[0] = row.cells[0].innerText;
        valueArray[1] = row.cells[1].innerText;
        valueArray[2] = row.cells[2].innerText;
        valueArray[3] = row.cells[3].innerText;
        valueArray[4] = row.cells[4].innerText;
        valueArray[5] = row.cells[5].innerText;

        // Delete old cells
        row.innerHTML = "";

        let cell = row.insertCell(0);
        cell.append(valueArray[0]);

        // Add new cells as input fields
        cell = row.insertCell(1);
        let input = document.createElement("input")
        input.placeholder = "name";
        input.value = valueArray[1];
        cell.appendChild(input);

        cell = row.insertCell(2);
        input = document.createElement("input")
        input.placeholder = "value";
        input.value = valueArray[2];
        cell.appendChild(input);

        cell = row.insertCell(3);
        input = document.createElement("input")
        input.placeholder = "quantity";
        input.value = valueArray[3];
        cell.appendChild(input);

        cell = row.insertCell(4);
        input = document.createElement("input")
        input.placeholder = "year location";
        input.value = valueArray[4];
        cell.appendChild(input);

        cell = row.insertCell(5);
        input = document.createElement("input")
        input.placeholder = "motif";
        input.value = valueArray[5];
        cell.appendChild(input);

        // Only for style purposes
        cell = row.insertCell(6);
        let button = document.createElement("button");
        button.id = "editBtn";
        button.type = "button";
        button.setAttribute("onclick", "removeStamp(this);");
        button.innerHTML = "Edit";
        cell.appendChild(button);

        button.style.visibility = "hidden";

        cell = row.insertCell(7);
        button = document.createElement("button");
        button.id = "removeBtn";
        button.type = "button";
        button.setAttribute("onclick", "removeStamp(this);");
        button.innerHTML = "Remove";
        cell.appendChild(button);

        cell = row.insertCell(8);
        button = document.createElement("button");
        button.id = "saveBtn";
        button.type = "button";
        button.setAttribute("onclick", "saveStamp(this);");
        button.innerHTML = "Save";
        cell.appendChild(button);
    }
</script>
</html>
