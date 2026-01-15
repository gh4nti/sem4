// Design and implement a Java-based hotel room management application that simulates concurrent room booking and room release operations using  multiple threads. The system must ensure data consistency when multiple  customers attempt to book or release rooms simultaneously. A hotel has a limited  number of rooms. Multiple customer threads attempt to book rooms at the same  time. If no rooms are available, the booking thread must wait.  When a room is released by another thread, the waiting booking thread must be  notified and allowed to proceed.

class Hotel {

    private int rooms;

    public Hotel(int rooms) {
        this.rooms = rooms;
    }

    public synchronized void bookRoom(String name) {
        System.out.println("Room booking for: " + name);

        while (rooms == 0) {
            try {
                System.out.println("No rooms available.\n");
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        rooms--;
        System.out.println("Room successfully booked for: " + name + ". Rooms available: " + rooms + "\n");
    }

    public synchronized void releaseRoom(String name) {
        rooms++;
        System.out.println("Room successfully released for: " + name + ". Rooms available: " + rooms);
        notifyAll();
    }
}

class BookingThread extends Thread {

    private final Hotel hotel;
    private final String name;

    public BookingThread(Hotel hotel, String name) {
        this.hotel = hotel;
        this.name = name;
    }

    @Override
    public void run() {
        hotel.bookRoom(name);
    }
}

class ReleaseThread extends Thread {

    private final Hotel hotel;
    private final String name;

    public ReleaseThread(Hotel hotel, String name) {
        this.hotel = hotel;
        this.name = name;
    }

    @Override
    public void run() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        hotel.releaseRoom(name);
    }
}

public class Program4_1 {

    public static void main(String[] args) {
        Hotel hotel = new Hotel(2);

        BookingThread c1 = new BookingThread(hotel, "Customer 1");
        BookingThread c2 = new BookingThread(hotel, "Customer 2");
        BookingThread c3 = new BookingThread(hotel, "Customer 3");

        ReleaseThread r1 = new ReleaseThread(hotel, "Customer 1");

        c1.start();
        c2.start();
        c3.start();

        r1.start();
    }
}
