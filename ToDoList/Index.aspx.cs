using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Web.Services;

namespace ToDoList
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //List Data Structure was imported from System.Collections.Generics
        //Here List Data Structure is used to store that Data that was type of ToDo Model class.
        //Reason for using static here is to use this list without creating object of the class and saving more memory.
        public static List<ToDo> list = new List<ToDo>();


        //Here count is used decalared and initialized to initial value.
        //It's purpose is when new task was enetered it was stored and incremented and a TaskId was assignment for the task by this variable.
        public static int count = 1;


        //Method for Inserting Task
        //Here WebMethod is used which was imported from System.Web.Services namespace.
        //WebMethod is as Web Service and its purpose is to handle the ajax request which was coming. Without this our method was not able to handle or serve the ajax request.

        //here method was defined as static because the ajax request was of POST type and if we does not use static then an 500 error code will come means that there is something wrong on the server-side.
        //If we want to remove the 500 error issue for POST type use static keyword in method.
        [WebMethod]
        public static void InsertTask(string taskName)
        {
            //here using try and catch to handle the exception
            try
            {
                //Adding elements in our list
                list.Add(new ToDo() { TaskId = count, TaskName = taskName });
                count++;
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }
            

        }

        //Method for Getting All Task
        [WebMethod]
        public static List<ToDo> GetAllTask()
        {
            //For getting all the list elements returnig the object of list.
            return list;
        }

        //Method for Deleting the task
        [WebMethod]
        public static void DeleteTask(int[] taskId)
        {
            //here using try and catch to handle the exception
            try
            {
                //Outer for loop is run until all the taskId was deleted
                for (int j = 0; j < taskId.Length; j++)
                {
                    //Here For each loop is used to fetch all the Elements from the List which was of ToDo type.
                    foreach (var todo in list.ToList())
                    {
                        //Here TaskId from List was matching with element present in particular index of taskId array
                        if (todo.TaskId == taskId[j])
                        {
                            //If element was matched then that element was deleted by remove method of list.
                            list.Remove(todo);
                            continue;
                        }
                    }
                }
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }


        /*
        [WebMethod] public static int CountTask()
        {
            int countTask = 0;

            countTask = list.Count();
            return countTask;
        }
        */

    }


}