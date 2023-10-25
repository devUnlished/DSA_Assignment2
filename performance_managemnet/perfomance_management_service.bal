import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

// Define your data models
type Department record {
    string id;
    string name;
    // Other department attributes
};

type Employee record {
    string id;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    // Other employee attributes
};

type KPI record {
    string id;
    string name;
    float weight;
    string unit;
    // Other KPI attributes
};

type Objective record {
    string id;
    string name;
    float weight;
    // Other objective attributes
};

// Define user roles
enum UserRole {
    HoD,
    Supervisor,
    Employee
}

// Define user details
type UserDetails record {
    string username;
    string password;
    UserRole role;
    string departmentId; // Add departmentId to UserDetails
};

// Define KPI assessment
type KPIAssessment record {
    string id;
    float value;
    // Other KPI assessment attributes
};

// Define department objectives
type DepartmentObjective record {
    string id;
    string departmentId;
    string objectiveId;
    // Other department objective attributes
};

type EmployeeAssignment record {
    string id;
    string employeeId;
    string supervisorId;
    // Other assignment attributes
};

type DepartmentObjectiveAssignment record {
    string id;
    string departmentId;
    string objectiveId;
    // Other department objective assignment attributes
};

type TotalScores record {
    float score;
    // Other total scores attributes
};

// Define the MongoDB connection configuration
mongodb:ConnectionConfig mongoConfig = {
    // Configure your MongoDB connection details here
    connection: {
        host: "localhost",
        port: 3000,
        auth: {
            username: "Softbaby",
            password: "Tysen@02"
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "Performance-Management-System."
};

// Create a MongoDB client
mongodb:Client db = check new (mongoConfig);

// Define GraphQL schemas and resolvers
@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        path: "/graphql"
    }
}
service /performanceManagement on new graphql:Listener(8080) {
    // Implement the checkUserAuthorization function
    function checkUserAuthorization(UserDetails user, UserRole requiredRole) returns boolean {
        match user.role {
            UserRole.HoD => return requiredRole == UserRole.HoD;
            UserRole.Supervisor => return requiredRole == UserRole.Supervisor;
            UserRole.Employee => return requiredRole == UserRole.Employee;
            _ => return false; // Default case, unauthorized
        }
    }
    
    // Mutations for HoD
    remote function createDepartmentObjective(Objective objective) returns Objective|error {
        if (checkUserAuthorization(user, UserRole.HoD)) {
            // Check if the user is authorized as an HoD

            // You can add additional validation here to ensure the objective data is valid

            // Generate a unique ID for the new department objective (you can use UUID or any other method)
            string objectiveId = generateUniqueObjectiveId();

            // Create a new DepartmentObjective record
            DepartmentObjective newObjective = {
                id: objectiveId,
                departmentId: user.departmentId, // Assuming the user's department ID is available in UserDetails
                objectiveId: objectiveId, // Use the same ID for department objective and objective
            };

            // Add the new objective to the MongoDB collection
            var result = db->insert(newObjective, "DepartmentObjectives");

            if (result is int) {
                // Successfully inserted
                return objective;
            } else {
                // Failed to insert
                return error("Failed to create department objective");
            }
        } else {
            return error("Unauthorized"); // User is not authorized to create department objectives
        }
    }

    remote function deleteDepartmentObjective(string objectiveId) returns boolean|error {
        if (checkUserAuthorization(user, UserRole.HoD)) {
            // Check if the user is authorized as an HoD

            // Implement logic to delete the department objective with the given ID from the MongoDB collection

            return true; // Return true if the deletion is successful
        } else {
            return error("Unauthorized"); // User is not authorized to delete department objectives
        }
    }

    remote function assignEmployeeToSupervisor(EmployeeAssignment assignment) returns EmployeeAssignment|error {
        if (checkUserAuthorization(user, UserRole.HoD)) {
            // Check if the user is authorized as an HoD

            // Implement logic to assign an employee to a supervisor and store the assignment details in MongoDB

            return assignment; // Return the assignment details if successful
        } else {
            return error("Unauthorized"); // User is not authorized to assign employees to supervisors
        }
    }

    remote function viewEmployeesTotalScores(UserDetails user) returns TotalScores|error {
        if (checkUserAuthorization(user, UserRole.HoD)) {
            // Check if the user is authorized as an HoD

            // Implement logic to calculate and return total scores for employees

            TotalScores scores = calculateTotalScores(); // You need to implement this function

            return scores;
        } else {
            return error("Unauthorized"); // User is not authorized to view total scores
        }
    }

    // Mutations for Supervisor
    remote function approveEmployeeKPIs(string employeeId, KPIAssessment[] assessments) returns boolean|error {
        if (checkUserAuthorization(user, UserRole.Supervisor)) {
            // Check if the user is authorized as a Supervisor

            // Implement logic to approve KPI assessments for the specified employee

            return true; // Return true if the approvals are successful
        } else {
            return error("Unauthorized"); // User is not authorized to approve KPI assessments
        }
    }

    remote function deleteEmployeeKPIs(string employeeId) returns boolean|error {
        if (checkUserAuthorization(user, UserRole.Supervisor)) {
            // Check if the user is authorized as a Supervisor

            // Implement logic to delete KPI assessments for the specified employee

            return true; // Return true if the deletions are successful
        } else {
            return error("Unauthorized"); // User is not authorized to delete KPI assessments
        }
    }

    remote function updateEmployeeKPIs(string employeeId, KPIAssessment[] assessments) returns KPIAssessment[]|error {
        if (checkUserAuthorization(user, UserRole.Supervisor)) {
            // Check if the user is authorized as a Supervisor

            // Implement logic to update KPI assessments for the specified employee

            return assessments; // Return the updated assessments if successful
        } else {
            return error("Unauthorized"); // User is not authorized to update KPI assessments
        }
    }

    remote function viewEmployeeScores(UserDetails user, string employeeId) returns TotalScores|error {
        if (checkUserAuthorization(user, UserRole.Supervisor)) {
            // Check if the user is authorized as a Supervisor

            // Implement logic to fetch and calculate scores for the specified employee

            TotalScores scores = calculateEmployeeScores(employeeId); // You need to implement this function

            return scores;
        } else {
            return error("Unauthorized"); // User is not authorized to view employee scores
        }
    }

    remote function gradeEmployeeKPIs(string employeeId, KPIAssessment[] assessments) returns KPIAssessment[]|error {
        if (checkUserAuthorization(user, UserRole.Supervisor)) {
            // Check if the user is authorized as a Supervisor

            // Implement logic to grade KPI assessments for the specified employee

            return assessments; // Return the graded assessments if successful
        } else {
            return error("Unauthorized"); // User is not authorized to grade KPI assessments
        }
    }

    // Mutations for Employee
    remote function createKPIs(KPI[] kpis) returns KPI[]|error {
        if (checkUserAuthorization(user, UserRole.Employee)) {
            // Check if the user is authorized as an Employee

            // Implement logic to create personal KPIs for the employee

            return kpis; // Return the created KPIs if successful
        } else {
            return error("Unauthorized"); // User is not authorized to create personal KPIs
        }
    }

    remote function gradeSupervisor(UserDetails user, string supervisorId, float score) returns boolean|error {
        if (checkUserAuthorization(user, UserRole.Employee)) {
            // Check if the user is authorized as an Employee

            // Implement logic to grade the supervisor

            return true; // Return true if the grading is successful
        } else {
            return error("Unauthorized"); // User is not authorized to grade the supervisor
        }
    }

    remote function viewPersonalScores(UserDetails user) returns TotalScores|error {
        if (checkUserAuthorization(user, UserRole.Employee)) {
            // Check if the user is authorized as an Employee

            // Implement logic to fetch and calculate personal scores for the employee

            TotalScores scores = calculatePersonalScores(user.username); // You need to implement this function

            return scores;
        } else {
            return error("Unauthorized"); // User is not authorized to view personal scores
        }
    }
}
