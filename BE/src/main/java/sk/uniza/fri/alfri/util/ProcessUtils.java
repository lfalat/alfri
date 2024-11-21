package sk.uniza.fri.alfri.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ProcessUtils {
  private ProcessUtils() {}

  public static String getOutputFromProces(ProcessBuilder processBuilder) throws IOException {
    processBuilder.redirectErrorStream(true);

    Process process = processBuilder.start();
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    StringBuilder output = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      output.append(line).append("\n");
    }

    return output.toString();
  }
}
