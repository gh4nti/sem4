// Create a Book class with private data members including book ID, book title, author name, price, and availability status. Provide public setter methods to assign values to these data members and public getter methods to retrieve their values. Include validation in setter methods to ensure that the price is a positive value.

class Book {

    private int ID;
    private String title, author;
    private double price;
    private boolean availability;

    // setter
    public void setID(int ID) {
        this.ID = ID;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setPrice(double price) {
        if (price > 0) {
            this.price = price;
        }
    }

    public void setAvailability(boolean availability) {
        this.availability = availability;
    }

    // getter
    public int getID() {
        return ID;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public double getPrice() {
        return price;
    }

    public boolean getAvailability() {
        return availability;
    }
}

public class Program1_1 {

    public static void main(String[] args) {
        Book b1 = new Book();

        b1.setID(0);
        b1.setTitle("abc");
        b1.setAuthor("a1");
        b1.setPrice(500);
        b1.setAvailability(true);

        System.out.println("ID: " + b1.getID());
        System.out.println("Title: " + b1.getTitle());
        System.out.println("Author: " + b1.getAuthor());
        System.out.println("Price: " + b1.getPrice());
        System.out.println("Availability: " + b1.getAvailability());
    }
}
