package com.cses.utils;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.*;

public class TestCaseReader {

	public static class TestResult {

		public final boolean passed;
		public final String expected;
		public final String actual;
		public final long executionTime;
		public final String error;

		public TestResult(
			boolean passed,
			String expected,
			String actual,
			long executionTime,
			String error
		) {
			this.passed = passed;
			this.expected = expected;
			this.actual = actual;
			this.executionTime = executionTime;
			this.error = error;
		}
	}

	/**
	 * Runs all test cases for a given problem
	 * @param problemName The name of the problem (e.g., "WeirdAlgorithm")
	 * @return Map of test case number to TestResult
	 */
	public static Map<Integer, TestResult> runAllTests(String problemName) {
		Map<Integer, TestResult> results = new TreeMap<>();

		try {
			String problemPath = "com/cses/problems/" + problemName;
			String testsPath = problemPath + "/tests";

			// Find all .in files
			File testsDir = new File(testsPath);
			if (!testsDir.exists()) {
				throw new RuntimeException(
					"Tests directory not found: " + testsPath
				);
			}

			File[] inputFiles = testsDir.listFiles((dir, name) ->
				name.endsWith(".in")
			);
			if (inputFiles == null) {
				throw new RuntimeException(
					"No test files found in: " + testsPath
				);
			}

			// Sort test files by number
			Arrays.sort(inputFiles, (a, b) -> {
				int numA = Integer.parseInt(a.getName().replace(".in", ""));
				int numB = Integer.parseInt(b.getName().replace(".in", ""));
				return Integer.compare(numA, numB);
			});

			for (File inputFile : inputFiles) {
				String testNumber = inputFile.getName().replace(".in", "");
				int testNum = Integer.parseInt(testNumber);

				TestResult result = runSingleTest(problemName, testNum);
				results.put(testNum, result);
			}
		} catch (Exception e) {
			System.err.println("Error running tests: " + e.getMessage());
			e.printStackTrace();
		}

		return results;
	}

	/**
	 * Runs a single test case
	 * @param problemName The name of the problem
	 * @param testNumber The test case number
	 * @return TestResult containing the result
	 */
	public static TestResult runSingleTest(String problemName, int testNumber) {
		try {
			String problemPath = "com/cses/problems/" + problemName;
			String inputFile = problemPath + "/tests/" + testNumber + ".in";
			String expectedOutputFile =
				problemPath + "/tests/" + testNumber + ".out";

			// Read expected output
			String expectedOutput = readFile(expectedOutputFile).trim();

			// Compile and run the Java program
			String className = problemName;
			String javaFile = problemPath + "/" + className + ".java";

			// Compile
			ProcessBuilder compileBuilder = new ProcessBuilder(
				"javac",
				javaFile
			);
			Process compileProcess = compileBuilder.start();
			int compileResult = compileProcess.waitFor();

			if (compileResult != 0) {
				String compileError = readStream(
					compileProcess.getErrorStream()
				);
				return new TestResult(
					false,
					expectedOutput,
					"",
					0,
					"Compilation failed: " + compileError
				);
			}

			// Run with input
			long startTime = System.nanoTime();
			ProcessBuilder runBuilder = new ProcessBuilder(
				"java",
				"-cp",
				".",
				"com.cses.problems." + problemName + "." + className
			);
			Process runProcess = runBuilder.start();

			// Send input
			String input = readFile(inputFile);
			try (
				PrintWriter writer = new PrintWriter(
					runProcess.getOutputStream()
				)
			) {
				writer.print(input);
				writer.flush();
			}

			// Wait for completion with timeout
			boolean finished = runProcess.waitFor(5, TimeUnit.SECONDS);
			long endTime = System.nanoTime();
			long executionTime = (endTime - startTime) / 1_000_000; // Convert to milliseconds

			if (!finished) {
				runProcess.destroyForcibly();
				return new TestResult(
					false,
					expectedOutput,
					"",
					executionTime,
					"Timeout (>5 seconds)"
				);
			}

			int exitCode = runProcess.exitValue();
			if (exitCode != 0) {
				String error = readStream(runProcess.getErrorStream());
				return new TestResult(
					false,
					expectedOutput,
					"",
					executionTime,
					"Runtime error: " + error
				);
			}

			// Read actual output
			String actualOutput = readStream(
				runProcess.getInputStream()
			).trim();

			// Compare outputs
			boolean passed = expectedOutput.equals(actualOutput);

			return new TestResult(
				passed,
				expectedOutput,
				actualOutput,
				executionTime,
				null
			);
		} catch (Exception e) {
			return new TestResult(
				false,
				"",
				"",
				0,
				"Exception: " + e.getMessage()
			);
		}
	}

	/**
	 * Runs tests and prints detailed results
	 * @param problemName The name of the problem to test
	 */
	public static void testProblem(String problemName) {
		System.out.println("Testing problem: " + problemName);
		System.out.println("=" + "=".repeat(50));

		Map<Integer, TestResult> results = runAllTests(problemName);

		int passed = 0;
		int total = results.size();

		for (Map.Entry<Integer, TestResult> entry : results.entrySet()) {
			int testNum = entry.getKey();
			TestResult result = entry.getValue();

			String status = result.passed ? "PASS" : "FAIL";
			String timeStr = String.format("%dms", result.executionTime);

			System.out.printf(
				"Test %2d: %-4s (%s)%n",
				testNum,
				status,
				timeStr
			);

			if (!result.passed) {
				if (result.error != null) {
					System.out.println("  Error: " + result.error);
				} else {
					System.out.println(
						"  Expected: " + result.expected.replace("\n", "\\n")
					);
					System.out.println(
						"  Actual:   " + result.actual.replace("\n", "\\n")
					);
				}
			}

			if (result.passed) {
				passed++;
			}
		}

		System.out.println("=" + "=".repeat(50));
		System.out.printf(
			"Results: %d/%d tests passed (%.1f%%)%n",
			passed,
			total,
			((100.0 * passed) / total)
		);

		if (passed == total) {
			System.out.println("🎉 All tests passed!");
		} else {
			System.out.println("❌ Some tests failed.");
		}
	}

	/**
	 * Reads a file and returns its content as a string
	 */
	private static String readFile(String filename) throws IOException {
		return new String(Files.readAllBytes(Paths.get(filename)));
	}

	/**
	 * Reads an InputStream and returns its content as a string
	 */
	private static String readStream(InputStream stream) throws IOException {
		StringBuilder sb = new StringBuilder();
		try (
			BufferedReader reader = new BufferedReader(
				new InputStreamReader(stream)
			)
		) {
			String line;
			while ((line = reader.readLine()) != null) {
				if (sb.length() > 0) {
					sb.append("\n");
				}
				sb.append(line);
			}
		}
		return sb.toString();
	}

	/**
	 * Main method for running tests from command line
	 * Usage: java com.cses.utils.TestCaseReader <ProblemName>
	 */
	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println(
				"Usage: java com.cses.utils.TestCaseReader <ProblemName>"
			);
			System.out.println(
				"Example: java com.cses.utils.TestCaseReader WeirdAlgorithm"
			);
			return;
		}

		String problemName = args[0];
		testProblem(problemName);
	}
}
