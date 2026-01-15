/*
Design and implement a Java application to simulate an Online Order Processing System where multiple customer orders are processed simultaneously using multithreading. 

i. In an e-commerce platform, several operations such as order validation, payment processing, and order shipment must be handled concurrently for different customers. To improve system performance and responsiveness, each order processing task should be executed in a separate thread. 

ii. Create individual threads for handling different customer orders or different stages of order processing. Each thread should simulate processing by displaying status messages and using the sleep() method to represent time-consuming operations. 

iii. The main program should start multiple threads at the same time and demonstrate concurrent execution of order-related tasks.
 */

class OrderProcessingTask implements Runnable {

    private final int ID;
    private final String name;

    public OrderProcessingTask(int ID, String name) {
        this.ID = ID;
        this.name = name;
    }

    @Override
    public void run() {
        try {
            System.out.println("Order " + ID + " | Customer: " + name + " | Validation started");
            Thread.sleep(2000);

            System.out.println("Order " + ID + " | Payment processing started");
            Thread.sleep(3000);

            System.out.println("Order " + ID + " | Shipment initiated");
            Thread.sleep(2000);

            System.out.println("Order " + ID + " | COMPLETED successfully\n");
        } catch (InterruptedException e) {
            System.out.println("Order " + ID + " interrupted.");
        }
    }
}

public class Program3_2 {

    public static void main(String[] args) {
        OrderProcessingTask o1 = new OrderProcessingTask(101, "abc");
        OrderProcessingTask o2 = new OrderProcessingTask(102, "def");
        OrderProcessingTask o3 = new OrderProcessingTask(103, "ghi");

        Thread t1 = new Thread(o1, "Thread1");
        Thread t2 = new Thread(o2, "Thread2");
        Thread t3 = new Thread(o3, "Thread3");

        t1.start();
        t2.start();
        t3.start();
    }
}
