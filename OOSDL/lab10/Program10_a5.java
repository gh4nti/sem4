// Write a Java program using an abstract class Vehicle with an abstract method fuelEfficiency(). Implement this method in subclasses Car and Bike. Display fuel efficiency  for different vehicle objects.

abstract class Vehicle {

    String name;

    Vehicle(String name) {
        this.name = name;
    }

    abstract void fuelEfficiency();
}

class Car extends Vehicle {

    double mileage;

    Car(String name, double mileage) {
        super(name);
        this.mileage = mileage;
    }

    @Override
    void fuelEfficiency() {
        System.out.println(name + " (Car) Mileage: " + mileage + " km/l");
    }
}

class Bike extends Vehicle {

    double mileage;

    Bike(String name, double mileage) {
        super(name);
        this.mileage = mileage;
    }

    @Override
    void fuelEfficiency() {
        System.out.println(name + " (Bike) Mileage: " + mileage + " km/l");
    }
}

public class Program10_a5 {

    public static void main(String[] args) {

        Vehicle v1 = new Car("Honda City", 18.5);
        Vehicle v2 = new Bike("Yamaha R15", 45.0);

        v1.fuelEfficiency();
        v2.fuelEfficiency();
    }
}
