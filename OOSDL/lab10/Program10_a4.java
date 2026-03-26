// Create a Java program to demonstrate runtime polymorphism by defining a base class Shape with a method calculateArea(). Override this method in derived classes such as Rectangle and Circle, and invoke it using a base class reference.

class Shape {

    void calculateArea() {
        System.out.println("Area not defined for generic shape.");
    }
}

class Rectangle extends Shape {

    double length, width;

    public Rectangle(double l, double w) {
        length = l;
        width = w;
    }

    @Override
    void calculateArea() {
        double area = length * width;
        System.out.println("Area of Rectangle: " + area);
    }
}

class Circle extends Shape {

    double radius;

    Circle(double r) {
        radius = r;
    }

    @Override
    void calculateArea() {
        double area = Math.PI * radius * radius;
        System.out.println("Area of Circle: " + area);
    }
}

public class Program10_a4 {

    public static void main(String[] args) {
        Shape s;

        s = new Rectangle(5, 4);
        s.calculateArea();

        s = new Circle(3);
        s.calculateArea();
    }
}
