// Write a Java program to create a Student class with data members such as studentID, name, and marks. Create multiple objects of the class, initialize them using methods or constructors, and display the details of each student.

class Student {

    int studentID;
    String name;
    float marks;

    void set(int id, String n, float m) {
        studentID = id;
        name = n;
        marks = m;
    }

    void display() {
        System.out.println(studentID + " " + name + " " + marks);
    }
}

public class Program10_a1 {

    public static void main(String[] args) {
        Student s1 = new Student();
        Student s2 = new Student();

        s1.set(101, "Adarsh", 88.5f);
        s2.set(102, "Priya", 92.0f);

        s1.display();
        s2.display();
    }
}
