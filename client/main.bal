import ballerina/graphql;
import ballerina/io;

 
type serverResponse record {|
    *graphql:GenericResponseWithErrors;
    record {|Response theResponse;|} data;
|};

 
type Response record {
    string result;
};



type User record {
    string firstname;
    string lastname;
    string jobtitle;
    string position;
    string role;
    string kpi;
    string score;
    string grade;
    string objective;
};

type userResponse record {|
  record {|User theUser;|} data;  
|};





graphql:Client graphqlClient = check new ("localhost:9090/Performance_manager");


public function main() returns error? {
    
    io:println(SignIn());
}


function MainMenu() returns string|error{
    io:println("==MAIN MENU== |");
    io:println("\n\n 1) SignIn");
    io:println("\n 2) SignUp");

    string input =io:readln("select an option__:");

    if input == "1" {
        return SignIn();
    }
    else if input == "2" {
        return Register();
    }
    else {
        return MainMenu();
    }

      
}





function Login() returns string|error? {

    string user = io:readln("Enter Password");
    string password = "\""+user;

    string document = " { authentication(username:\"user\") { result } } ";
    string document2 = " { authentication(password:"+password+"\") { result } } ";

    map<json> response = check graphqlClient->execute(document2); 
    json|error resultValue = response.data.authentication.result;

    


    io:println("--<json>");
    io:println(resultValue);
    if resultValue == "user" {
        io:println("Access granted");
    }
    //io:println("--String--");
    //io:println(response.data.authentication.result);

    return "";

};

function SignIn() returns string|error {

    string user = io:readln("Enter Username");
    string username = "\""+user;

    string pswrd = io:readln("Enter Password");
     
   
    string document = " { getPassword(username:"+username+"\") } ";

    map<json> response = check graphqlClient->execute(document); 
    json|error resultValue = response.data.getPassword;

    io:println("--<json>");
    io:println(resultValue);
    
    if resultValue == "password" {
        io:println("Access granted");
        io:println(menuSelect(user));


    } else {
        io:println("Access Denied");
    }
    //io:println("--String--");
    //io:println(response.data.authentication.result);

    return "";


};

function menuSelect(string usr) returns string|error {

    string user = usr;
    string username = "\""+user;

    string document = " { getPosition(username:"+username+"\") } ";

    map<json> response = check graphqlClient->execute(document); 
    json|error resultValue = response.data.getPosition;

    if resultValue == "supervisor" {
        return SupervisorMenu(user);

    } 
    else if resultValue == "hod" {
        return hodMenu();
    }
    else if resultValue == "employee" {
        return EmployeeMenu(user);
    }
    else {
        return menuSelect(user);
    }

    

}


function hodMenu() returns string|error{
    io:println("==HOD MENU== |");
    io:println("\n\n 1) Create Objectives");
    io:println("\n 2) Delete Objectives");
    io:println("\n 3) View Total Scores");
    io:println("\n 4) Assign Employee");
   
    string input =io:readln("select an option__:");

    if input == "1" {
        return createObj();
    }
    else if input == "2" {
        return " ";
    }
    else if input == "3" {
        return totalScores();
    }
    else if input == "4" {
        return assign();
    }
    else {
        return MainMenu();
    }

      
}

function SupervisorMenu(string user) returns string|error{
    io:println("==SuperVisor MENU== |");
    io:println("\n\n 1) Approve KPI");
    io:println("\n 2) Delete KPI");
    io:println("\n 3) Update KPI");
    io:println("\n 4) View Scores");
    io:println("\n 5) Grade KPI");

    string input =io:readln("select an option__:");

    if input == "1" {
        return ApproveKPI(user);
    }
    else if input == "2" {
        return DeleteKPI(user);
    }
    else if input == "3" {
        return UpdateKPI(user);
    }
    else if input == "4" {
        return EmployeeScores(user);
    }
    else if input == "5" {
        return gradeKPI(user);
    }
    else {
        return MainMenu();
    }

      
}


function EmployeeMenu(string user) returns string|error{
    io:println("==Employee MENU== |");
    io:println("\n\n 1) Create KPI");
    io:println("\n 2) Grade Supervisor");
    io:println("\n 3) View Total Scores");
    
    string input =io:readln("select an option__:");

    if input == "1" {
        return CreateKPI(user);
    }
    else if input == "2" {
        return GradeSup(user);
    }
    else if input == "3" {
        return ViewScore(user);
    }
    else {
        return MainMenu();
    }

      
}
