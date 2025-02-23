package sk.uniza.fri.alfri.util;

import lombok.extern.slf4j.Slf4j;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.stream.Collectors;

@Slf4j
public class ProcessUtils {
  private ProcessUtils() {}

  public static String getOutputFromProces(ProcessBuilder processBuilder, boolean isNeuralNetwork) throws IOException {
    processBuilder.redirectErrorStream(true);

    Process process = processBuilder.start();
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    StringBuilder output = new StringBuilder();
    String line;
      List<String> lines = new ArrayList<>();
      while ((line = reader.readLine()) != null) {
        System.out.println(line);
        lines.add(line);
      output.append(line).append("\n");
    }

    if (isNeuralNetwork) {
        ListIterator<String> iterator = lines.listIterator();
        while (iterator.hasNext()) {
            String lineIter = iterator.next();
            if (ProcessUtils.isJsonStart(lineIter)) {
                // Found the first JSON line. Remove everything before it.
                while (iterator.previousIndex() >= 0) { // Check for index boundary
                    iterator.previous();
                    iterator.remove();
                }
                break; // Stop after finding the first JSON line
            }
        }

        String outputNeural = lines.stream().collect(Collectors.joining("\n"));
        log.info("Output of script: {}", outputNeural);
        return outputNeural;
    }

    log.info("Output of script: {}", output);
    return output.toString();
  }

    private static boolean isJsonStart(String line) {
        if (line == null || line.isBlank()) {
            return false;
        }
        String trimmedLine = line.trim();
        return trimmedLine.startsWith("{") || trimmedLine.startsWith("[");
    }
}
