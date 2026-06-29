import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        // Create Tomcat instance
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(8080);

        // Set base directory
        String baseDir = new File(".").getAbsolutePath();
        tomcat.setBaseDir(baseDir);

        // Add webapp (pointing to current directory)
        tomcat.addWebapp("/", baseDir);

        // Start server
        tomcat.start();
        System.out.println("Server started at http://localhost:8080");
        tomcat.getServer().await();
    }
}