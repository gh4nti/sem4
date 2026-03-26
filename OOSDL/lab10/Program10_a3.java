// Write a Java program illustrating inheritance by creating a base class Employee with attributes empID and name. Derive a class PermanentEmployee that includes basicSalary and calculates the total salary. Demonstrate the use of super keyword.

class Employee {

    int empID;
    String name;

    Employee(int empID, String name) {
        this.empID = empID;
        this.name = name;
    }

    void display() {
        System.out.println("Employee ID: " + empID);
        System.out.println("Name: " + name);
    }
}

class PermanentEmployee extends Employee {

    double basic, total;

    PermanentEmployee(int empID, String name, double basic) {
        super(empID, name);
        this.basic = basic;
    }

    void calc() {
        double HRA = 0.20 * basic;
        double DA = 0.10 * basic;
        total = basic + HRA + DA;
    }

    @Override
    void display() {
        super.display();
        System.out.println("Basic Salary: " + basic);
        System.out.println("Total Salary: " + total);
        System.out.println("---------------------------");
    }
}

public class Program10_a3 {

    public static void main(String[] args) {
        PermanentEmployee emp1 = new PermanentEmployee(101, "Adarsh", 50000);

        emp1.calc();
        emp1.display();
    }
}
