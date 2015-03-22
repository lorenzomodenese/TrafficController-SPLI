import java.io.*;
import java.net.*;



public class IterativeRcpServer {

    public static void main(String args[]) {
        int BUFDIM = 1024;

        if (args.length != 1)  {
            System.err.println("Uso: java IterativeRcpServer porta");
            System.exit(1);
        }

        try
        {
            ServerSocket ss = new ServerSocket(Integer.parseInt(args[0]));
            System.out.println("Attesa connessione su porta " + ss.getLocalPort());
            while (true) {
                Socket s = ss.accept();
                BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
                DataOutputStream out = new DataOutputStream(s.getOutputStream());

                File file = new File(in.readLine());
                if (file.exists()) {
                    out.writeChar('S');
                    out.flush();
                    byte buffer[] = new byte[BUFDIM];
                    int bytesRead;
                    FileInputStream fileIn = new FileInputStream(file);
                    while ((bytesRead = fileIn.read(buffer, 0, BUFDIM)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    fileIn.close();
                    out.flush();
                } else {
                    out.writeChar('N');
                    out.flush();
                }
                s.close();
            }
        }
        catch (IOException e) {
            System.err.println(e);
            System.exit(2);
        }
    }
}

