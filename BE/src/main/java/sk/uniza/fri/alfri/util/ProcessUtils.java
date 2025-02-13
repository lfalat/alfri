package sk.uniza.fri.alfri.util;

import lombok.extern.slf4j.Slf4j;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

@Slf4j
public class ProcessUtils {
  private ProcessUtils() {}

  public static String getOutputFromProces(ProcessBuilder processBuilder) throws IOException {
    processBuilder.redirectErrorStream(true);

    Process process = processBuilder.start();
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    StringBuilder output = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
      output.append(line).append("\n");
    }

    log.info("Output of script: {}", output);
    return output.toString();
  }
}
