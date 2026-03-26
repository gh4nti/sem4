// Write a Java progra to create a class Book with data members bookID, title, and price. Initialize these values using a parameterized constructor and the this keyword. Create  multiple objects and display the book details.

class Book {

    int bookID;
    String title;
    double price;

    Book(int bookID, String title, double price) {
        this.bookID = bookID;
        this.title = title;
        this.price = price;
    }

    void display() {
        System.out.println("Book ID: " + bookID);
        System.out.println("Title: " + title);
        System.out.println("Price: " + price + "\n");
    }
}

public class Program10_a6 {

    public static void main(String[] args) {

        Book b1 = new Book(101, "Java Programming", 499.99);
        Book b2 = new Book(102, "Data Structures", 599.50);
        Book b3 = new Book(103, "Operating Systems", 450.75);

        b1.display();
        b2.display();
        b3.display();
    }
}
