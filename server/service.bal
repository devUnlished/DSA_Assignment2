import ballerina/graphql;
import ballerinax/mongodb;

mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "PMS"
};

mongodb:Client db = check new (mongoConfig);

configurable string departmentCollection = "Departments";
configurable string userCollection = "Users";
configurable string KPIcollection = "KPIs";
configurable string databaseName = "PMS";


type User record {
    string staffNo;
    string password;
    string firstName;
    string lastName;
    string jobTitle;
    string role;
};

type Department record {
    string id;
    string name;
    Objective objectives;
};

type Objective record {
    string id;
    string description;
};

type KPI record {
    string id;
    string description;
    string grade;
    string employee_staffNo;
    string supervisor_staffNo;
    string department_id;
};

service / on new graphql:Listener(9090) {

    remote function addUser(User user) returns string|error {
        map<json> doc = <map<json>>{staffNo: user.staffNo, password: user.password, firstName: user.firstName, lastName: user.lastName, jobTitle: user.jobTitle, role: user.role};
        _ = check db->insert(doc, userCollection, "");
        return string `${user.staffNo} added successfully`;
    }

    remote function createDepartmentObjectives(string departmentId, Objective objective) returns string|error {

        var filter = {id: departmentId};
        map<json> newObjective = <map<json>>{"$push": {"objectives": {id: objective.id, description: objective.description}}};

        int updatedCount = check db->update(newObjective, departmentCollection, databaseName, filter, true, false);

        if updatedCount > 0 {
            return string `Objective has been added successfully`;
        }
        return "Failed to add the Objective";
    }
