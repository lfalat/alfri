package sk.uniza.fri.alfri;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class AlfriApplication {

  public static void main(String[] args) {
    SpringApplication.run(AlfriApplication.class, args);
  }
}
