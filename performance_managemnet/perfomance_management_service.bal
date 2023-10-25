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
