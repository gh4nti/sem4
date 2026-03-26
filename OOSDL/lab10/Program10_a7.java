// Write a Java program to demonstrate multiple inheritance using interfaces. Create two interfaces Printable and Scannable with appropriate methods. Implement both interfaces in a class MultiFunctionPrinter and demonstrate method implementation through an object of the class.

interface Printable {

    void print();
}

interface Scannable {

    void scan();
}

class MultiFunctionPrinter implements Printable, Scannable {

    @Override
    public void print() {
        System.out.println("Printing document...");
    }

    @Override
    public void scan() {
        System.out.println("Scanning document...");
    }
}

public class Program10_a7 {

    public static void main(String[] args) {

        MultiFunctionPrinter mfp = new MultiFunctionPrinter();

        mfp.print();
        mfp.scan();
    }
}
