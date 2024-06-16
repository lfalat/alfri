package sk.uniza.fri.alfri.startup;

import jakarta.annotation.PostConstruct;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

@Component
public class PythonDependencyChecker {
    private final ResourceLoader resourceLoader;

    public PythonDependencyChecker(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @PostConstruct
    public void checkAndInstallDependencies() throws IOException {
        printPythonVersion();

        Resource requirementsResource = resourceLoader.getResource("classpath:python_scripts/requirements.txt");
        String requirementsPath = requirementsResource.getFile().getAbsolutePath();

        List<String> missingDependencies = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(requirementsPath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] dependency = line.split("==");
                String packageName = dependency[0];
                String packageVersion = dependency.length > 1 ? dependency[1] : null;

                if (!isPackageInstalled(packageName, packageVersion)) {
                    missingDependencies.add(line);
                }
            }

            if (!missingDependencies.isEmpty()) {
                System.out.println("Installing missing dependencies...");
                for (String dependency : missingDependencies) {
                    installPackage(dependency);
                }
                System.out.println("Dependencies installation completed.");
            } else {
                System.out.println("All dependencies are already installed.");
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void printPythonVersion() {
        try {
            Process process = new ProcessBuilder("python3", "--version")
                    .redirectErrorStream(true)
                    .start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("Python version: " + line);
            }
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    private boolean isPackageInstalled(String packageName, String packageVersion) {
        try {
            Process process = new ProcessBuilder("pip", "show", packageName)
                    .redirectErrorStream(true)
                    .start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("Version:")) {
                    if (packageVersion == null || line.split(" ")[1].equals(packageVersion)) {
                        return true;
                    }
                }
            }
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void installPackage(String packageName) {
        try {
            Process process = new ProcessBuilder("pip", "install", packageName)
                    .redirectErrorStream(true)
                    .start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
