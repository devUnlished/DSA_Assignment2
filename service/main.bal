import ballerina/graphql;
import ballerina/io;
 
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;


                                                          
type serverResponse record {|
    record {|Response theResponse;|} data;
|};

type Response record {
    string result;
};

type User record {
    string firstname;
    string lastname;
    string password;
    string jobtitle;
    string position;
    string role;
    string kpi;
    string score;
    string grade;
    string objective;
    string supervisor;
};

type thePassword record {
    string password;
};


type userResponse record {|
  record {|User theUser;|} data;  
|};

type Objectives record {
    string ObjId;
    string objective;
};





// Service attached to a GraphQL listener exposes a GraphQL service on the provided port.
service /Performance_manager on new graphql:Listener(9090) {

    // A resource method with `get` accessor inside a `graphql:Service` represents a field in the
    // root `Query` type.


     private final mysql:Client db;


    function init() returns error?{
        
        self.db = check new ("localhost", "root", "softwarebaby@02", "Department", 3306);
         
    }



    resource function get greeting() returns string {
        return "Hello, World";
    }

    resource function get createUser(
                                        string firstName, 
                                        string lastName,
                                        string Password,
                                        string jobTitle,
                                        string Position,
                                        string Role,
                                        string Objective
                                     ) returns User {

      
     userResponse resp = { 
                                     data :  {theUser: {firstname: firstName, 
                                                        lastname: lastName,
                                                        password: Password, 
                                                        jobtitle: jobTitle,
                                                        position: Position, 
                                                        role: Role, 
                                                        kpi: "",
                                                        score: "",
                                                        grade: "" ,
                                                        objective: Objective,
                                                        supervisor: ""
                                                        } 
                                             }
                                    
                         }; 

User user = resp.data.theUser;


io:println(resp.data.theUser);
      
      
        return resp.data.theUser;
        
    }

    resource function get authentication( string password ) returns Response {

        serverResponse resp = { 
                                     data :  {theResponse: {result: password} }
                                    
                             };
       
      
   
        io:println("--server--");
        io:println(resp.data.theResponse);

        if(password == "user") {
           return resp.data.theResponse;
        }

        return  {result: "Access Denied"};
    }

   

    resource function get getPassword( string username) returns string|error {

        User usr;

            stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees
                                                             WHERE LastName = ${username};`);
      
            return from User us in users
            select us.password; 
      
    }


     resource function get getPosition(string username) returns string|error {

        User usr;

            stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees
                                                             WHERE LastName = ${username};`);
      
            return from User us in users
            select us.position; 
      
    }




    


    resource function get createObjectives(string id,string obj) returns string|error {

      

        sql:ExecutionResult result = check self.db->execute(`INSERT INTO Objectives
                                                             VALUES (${id},${obj});`);

        return obj;

    }

    resource function get viewTotalScores() returns string|error {

      
         stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees`);
         // Process the stream and convert results to Album[] or return error.
         return from User usr in users
         select "\n|Name: "+usr.firstname+" "+usr.lastname+"| Total Score: "+usr.score;


    }

    resource function get assign(string empId, string super) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET Supervisor = ${super}
                                              WHERE UserId = ${empId};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();



    }


    resource function get EmployeeScores(string super) returns string|error{

     stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees 
                                                          WHERE Supervisor =${super}`);

     // Process the stream and convert results to Album[] or return error.
         return from User usr in users
         select "\n|Name: "+usr.firstname+" "+usr.lastname+"| Total Score: "+usr.score+"| KPI |"+usr.kpi;
   
    
    }


  resource function get deleteKPI(string empId) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET KPI = "0"
                                              WHERE UserId = ${empId};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();



    }
    
     resource function get ApproveKPI(string empId, string status) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET KPIStatus = ${status}
                                              WHERE UserId = ${empId};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();



    }

    resource function get updateKPI(string empId, string KPI) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET KPI = ${KPI}
                                              WHERE UserId = ${empId};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();

    }

    resource function get gradeKPI(string empId, string grade) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET Grade = ${grade}
                                              WHERE UserId = ${empId};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();

    }

    resource function get createKPI(string username, string KPI) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET KPI = ${KPI}
                                              WHERE LastName = ${username};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();

    }


    resource function get gradeSup(string sup, string grade) returns string|error {


             sql:ParameterizedQuery  query = `UPDATE Employees
                                              SET Grade = ${grade}
                                              WHERE Supervisor = ${sup};`;

             sql:ExecutionResult result = check self.db->execute(query);

             return result.toString();

    }


    resource function get viewKPI(string username) returns string|error {

      
         stream<User, sql:Error?> users = self.db->query(`SELECT * FROM Employees 
                                                          WHERE LastName = ${username}`);
         // Process the stream and convert results to Album[] or return error.
         return from User usr in users
         select "\n|Name: "+usr.firstname+" "+usr.lastname+"| KPI : "+usr.kpi;

    }


















}