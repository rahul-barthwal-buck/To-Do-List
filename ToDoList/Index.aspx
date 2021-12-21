<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ToDoList.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>To-Do List</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
</head>
<body>
    <form id="form1" runat="server">
         <h1>To-Do List</h1>
        <div>
            <input type="text" id="txtTaskName" runat="server" placeholder="Please Enter Task Name" />
            &nbsp;&nbsp;
            <input  type="button" id="btnAddList" value="Add List"/>
            &nbsp;&nbsp;
            <input  type="button" id="btnDeleteList" value="Delete List"/>
        </div>
        <%----task class is used to add table and it's content and data dynamically---%>
        <div class="task"></div>  
        <%-----TotalTask will  show the the total number of task was pending-----%>
        <p>Total Work pending <span id="TotalTask"></span></p>
    </form>
     <script type="text/javascript">

         $(document).ready(function () {



             //btnAddList event is trigger  when Add button is clicked
             $("#btnAddList").click(function () {
                 //Taking value from input
                 var taskName = $("#txtTaskName").val();
                 var regex = /^[a-zA-Z]{3,200}$/i;
                 //Checking whether the value is empty or not
                 if (taskName == "") {
                     alert("TaskName is required");
                 } else if (!regex.test(taskName)) {
                     alert("TaskName only contain alphabets and Length must between 3 to 200 characters ");
                 } else {
                     //If the input value is not empty then ajax method was called
                     //ajax method provides the core functionality of ajax in jQuery and sends asynchronous requests to the server
                     $.ajax({
                         //url is used to specify the URL to send the request. Here i was sending the request for InsertTask method.
                         url: "Index.aspx/InsertTask",
                         //type is used to specify the type of request we was sending. Here POST is using because it's safer than get and does not store the value in the browser history
                         type: 'POST',
                         //contentType is used to specify what type fo content we are sending.Here json type content was sending.
                         contentType: "application/json",
                         //Data is used to specify the data to be sent to ther server.Here JSON.stringify is used to convert the data into string format.
                         data: JSON.stringify({ taskName: taskName }),
                         // success hold a function which will be executed when the request succeeds.
                         success: function (data) {
                             if (data.d == 0) {
                                 alert("Task already pending");
                             } else {
                                 //TotalTask();

                                 //GetAllTask function will be called when new value entered and it display the old and also the new value.
                                 GetAllTask();

                                 // Here Total number of task will be printed
                                 $("#TotalTask").text($(".task table tr").length + 1);
                             // console.log($(".task table tr").length + 1);

                             }

                         },

                         //error hold a function which will be executed when the request fails.
                         error: function (error) {
                             console.log(error);
                         }
                     });
                 }
             });


             //btnDeleteList event is trigger  when Delete button is clicked
             $("#btnDeleteList").click(function () {
                 //checkedId is an array to store mutiple id's of checkbox
                 var checkedId = [];

                 //here we are checking which checkbox is checked and accessing them one by one
                 $('#CheckId:checked').each(function () {
                     //Here we are inserting the value of checkbox into our array with the help of push method.
                     checkedId.push(this.value);
                 });

                 //If checkedId array is null then printing message.
                 if (checkedId.length == 0) {
                     alert("Please check the chekbox to delete task.");
                 } else {

                     //if checkedId array is not null then ajax request was called.
                     //below ajax request is used to request the DeleteTask method for deleting the task.
                     $.ajax({
                         url: "Index.aspx/DeleteTask",
                         type: 'POST',
                         contentType: "application/json",
                         data: JSON.stringify({ taskId: checkedId }),
                         success: function () {
                             //Whenever value is deleted the GetAllTask method will be called and fetch the new element list.
                             GetAllTask();
                             // TotalTask();

                             // Here Total number of task will be printed
                             $("#TotalTask").text($(".task table tr").length - checkedId.length);
                             //console.log($(".task table tr").length - checkedId.length);

                         },
                         error: function (error) {
                             //if error comes then its print in the console screen
                             console.log(error);
                         }
                     });
                 }


             });


             //getAllTask function is called when any Add and Delete event is triggered
             function GetAllTask() {
                 //Here ajax request is called and request for GetAllTask method to get object of List.
                 $.ajax({
                     url: "Index.aspx/GetAllTask",
                     type: 'POST',
                     contentType: "application/json",
                     dataType: 'json',
                     success: function (data) {
                         //Here .task class which contain table was emptied because whenver new value is inserted and old value is deleted it append the table with new value with old value.
                         //So to avoid the cloning of old value we first need to empty the .task class.
                         $('.task').empty();

                         //items is an array which is used to stored the returned data which was of  json type which contain array
                         var items = [];

                         //each method is used to fetch the element one by one
                         $.each(data.d, function (key, val) {
                             //each fetched elements was stored in the items array and stored it as string
                             items.push("<tr><td style='width: 320px;border:1px solid black;font-size:16px;'><input type= 'text' style='width: 315px;font-size:16px;' id='taskname' value='" + val.TaskName + "'/></td><td style='border:1px solid black;'><input type= 'checkbox' id='CheckId' value='" + val.TaskId + "'/></td></tr>");

                         });

                         //Here a table is created dynamically
                         $("<table/>", {
                             //here using html attribute and the elements of items will be joined without any space and with appendTo method it was appended on the .task class.
                             html: items.join("")
                         }).appendTo(".task");

                     },
                     error: function (error) {
                         //if error comes then its print in the tag which has #TotalTask as id
                         $("#TotalTask").text(error);
                     }

                 });
             };



              <%--function TotalTask() {
                 $.ajax({
                     url: "Index.aspx/CountTask",
                        type: 'POST',
                        contentType: "application/json",
                        dataType: 'json',
                        success: function (data) {
                            //console.log(data.d);
                            $("#TotalTask").text(data.d);
                        },
                        error: function (error) {

                            $("#TotalTask").text(error);
                        }

                    });
             };--%>


         });
     </script>
</body>
</html>
