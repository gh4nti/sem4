/*
Design and implement a Java application to simulate a Hotel Room Service Management System where multiple service requests are handled concurrently using multithreading.

i. In a hotel, different room service tasks such as room cleaning, food delivery, and maintenance may occur at the same time. To efficiently manage these tasks, the application should create separate threads for each service request so that they can execute concurrently rather than sequentially. 

ii. Create individual threads for different service operations using Java thread creation techniques (Thread class or Runnable interface). Each thread should simulate a service task by displaying status messages and pausing execution using the sleep() method to represent processing time.

iii. The main program should start multiple threads simultaneously and demonstrate concurrent execution of hotel service tasks.
 */

class ServiceTask implements Runnable {

    private final String name;
    private final int no, duration;

    public ServiceTask(String name, int no, int duration) {
        this.name = name;
        this.no = no;
        this.duration = duration;
    }

    @Override
    public void run() {
        try {
            System.out.println(name + " started for Room " + no + " | Thread: " + Thread.currentThread().getName());
            Thread.sleep(duration);
            System.out.println(name + " completed for Room " + no + " | Thread: " + Thread.currentThread().getName());
        } catch (InterruptedException e) {
            System.out.println(name + " interrupted for Room " + no);
        }
    }
}

public class Program3_1 {

    public static void main(String[] args) {
        ServiceTask task1 = new ServiceTask("Task 1", 101, 3000);
        ServiceTask task2 = new ServiceTask("Task 2", 102, 2000);
        ServiceTask task3 = new ServiceTask("Task 3", 103, 4000);

        Thread t1 = new Thread(task1, "Thread1");
        Thread t2 = new Thread(task2, "Thread2");
        Thread t3 = new Thread(task3, "Thread3");

        t1.start();
        t2.start();
        t3.start();
    }
}
