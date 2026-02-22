import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

class AnswerLog {
	private boolean writingInProgress = false;
	private boolean writingDone = false;
	private final String filename = "answerlog.txt";

	public synchronized void writeAnswer(String answer) {
		while (writingInProgress) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		writingInProgress = true;

		try (FileWriter fw = new FileWriter(filename, true)) {
			System.out.println("Sent: " + answer);
			fw.write(answer + "\n");
		} catch (IOException e) {
			e.printStackTrace();
		}

		writingInProgress = false;
		notifyAll();
	}

	public synchronized void readAnswer() {
		while (writingInProgress) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		System.out.println("\nReading...");

		try (FileReader fr = new FileReader(filename)) {
			int ch;
			StringBuilder line = new StringBuilder();

			while ((ch = fr.read()) != -1) {
				if (ch == '\n') {
					System.out.println("Received: " + line.toString());
					line.setLength(0);
				} else {
					line.append((char) ch);
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

		writingDone = true;
		notifyAll();
	}

	public synchronized void waitForCompletion() {
		while (!writingDone) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("\nAll answers have been successfully read and written.");
	}
}

class SenderThread extends Thread {
	private final AnswerLog answerLog;

	public SenderThread(AnswerLog answerLog) {
		this.answerLog = answerLog;
	}

	@Override
	public void run() {
		String[] answers = { "Answer 1", "Answer 2", "Answer 3", "Answer 4", "Answer 5" };
		for (String ans : answers) {
			answerLog.writeAnswer(ans);
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}

class ReceiverThread extends Thread {
	private final AnswerLog answerLog;

	public ReceiverThread(AnswerLog answerLog) {
		this.answerLog = answerLog;
	}

	@Override
	public void run() {
		try {
			Thread.sleep(2500);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		answerLog.readAnswer();
	}
}

class SupervisorThread extends Thread {
	private final AnswerLog answerLog;

	public SupervisorThread(AnswerLog answerLog) {
		this.answerLog = answerLog;
	}

	@Override
	public void run() {
		answerLog.waitForCompletion();
	}
}

public class AnswerLogDemo {
	public static void main(String[] args) {
		AnswerLog answerLog = new AnswerLog();

		SenderThread sender = new SenderThread(answerLog);
		ReceiverThread receiver = new ReceiverThread(answerLog);
		SupervisorThread supervisor = new SupervisorThread(answerLog);

		sender.start();
		receiver.start();
		supervisor.start();

		try {
			sender.join();
			receiver.join();
			supervisor.join();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}