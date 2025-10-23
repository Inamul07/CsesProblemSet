# CSES Problem Testing System

This project provides an automated testing system for CSES (Competitive Programming) problems written in Java.

## Project Structure

```
CSES/
├── com/cses/
│   ├── problems/
│   │   └── [ProblemName]/
│   │       ├── [ProblemName].java    # Solution file
│   │       └── tests/
│   │           ├── 1.in              # Test input files
│   │           ├── 1.out             # Expected output files
│   │           ├── 2.in
│   │           ├── 2.out
│   │           └── ...
│   └── utils/
│       └── TestCaseReader.java       # Test runner utility
├── scripts/
│   ├── test.sh                       # Script to run all tests
│   ├── run.sh                        # Script to run problem interactively
│   ├── new_problem.sh                # Script to create new problems
│   ├── submit.sh                     # Script to generate submission-ready code
│   ├── test_submit.sh                # Script to test submission-ready code
│   └── status.sh                     # Script to show overview of all problems
├── submit/                           # Generated submission files (no packages)
├── cses                              # Main runner script (convenience wrapper)
└── README.md                         # This file
```

## Usage

### Running Tests

To run all test cases for a specific problem:

```bash
./cses test ProblemName
```
or
```bash
./scripts/test.sh ProblemName
```

Example:
```bash
./cses test WeirdAlgorithm
./scripts/test.sh WeirdAlgorithm
```

This will:
1. Compile your Java solution
2. Run it against all test cases in the `tests/` directory
3. Compare outputs with expected results
4. Show a detailed report

### Interactive Testing

To run a problem interactively (manually enter input):

```bash
./cses run ProblemName
```
or
```bash
./scripts/run.sh ProblemName
```

Example:
```bash
./cses run WeirdAlgorithm
./scripts/run.sh WeirdAlgorithm
```

This will compile and run your solution, allowing you to enter input manually from stdin.

### Creating New Problems

To create a new problem with the proper directory structure and template:

```bash
./cses new ProblemName
```
or
```bash
./scripts/new_problem.sh ProblemName
```

Example:
```bash
./cses new TwoSum
./scripts/new_problem.sh TwoSum
```

This will:
1. Create the directory structure
2. Generate a Java template file
3. Create sample test case files
4. Show next steps

### Problem Status Overview

To see the status of all problems at once:

```bash
./cses status
```
or
```bash
./scripts/status.sh
```

This will show:
- All available problems
- Number of test cases for each
- Current test results (passed/failed)
- Compilation status

### Generating Submission Files

For competitive programming submissions, you typically need to remove package declarations. To generate a submission-ready file:

```bash
./cses submit ProblemName
```
or
```bash
./scripts/submit.sh ProblemName
```

Example:
```bash
./cses submit WeirdAlgorithm
./scripts/submit.sh WeirdAlgorithm
```

This will:
1. Remove the package declaration from your solution
2. Create a submission-ready file in the `submit/` directory
3. Test compilation to ensure it works
4. Display the file contents for easy copying

### Testing Submission Files

To test your submission-ready code against test cases:

```bash
./cses test-submit ProblemName
```
or
```bash
./scripts/test_submit.sh ProblemName
```

Example:
```bash
./cses test-submit WeirdAlgorithm
./scripts/test_submit.sh WeirdAlgorithm
```

**Note**: If no submission file exists, `test-submit` will automatically generate it first by calling the submit command, then run the tests. This ensures your submission file works correctly without package declarations.

### Sample Output

```
Testing problem: WeirdAlgorithm
===================================================
Test  1: PASS (53ms)
Test  2: PASS (54ms)
Test  3: FAIL (52ms)
  Expected: 7 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1 
  Actual:   7 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1
Test  4: PASS (54ms)
===================================================
Results: 3/4 tests passed (75.0%)
❌ Some tests failed.
```

## Adding New Problems

1. Create a new directory under `com/cses/problems/` with your problem name
2. Create your Java solution file with the same name as the directory
3. Create a `tests/` subdirectory
4. Add test cases as numbered pairs: `1.in`, `1.out`, `2.in`, `2.out`, etc.

### Java Solution Template

```java
package com.cses.problems.ProblemName;

import java.util.Scanner;

public class ProblemName {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        // Read input
        // Your solution logic here
        
        scanner.close();
    }
}
```

## Test Case Format

- **Input files** (`.in`): Contains the input data for each test case
- **Output files** (`.out`): Contains the expected output for each test case
- Files should be numbered starting from 1: `1.in`, `1.out`, `2.in`, `2.out`, etc.

## Features

- **Automatic compilation**: Compiles Java files before running tests
- **Timeout protection**: Tests timeout after 5 seconds to prevent infinite loops (regular tests)
- **Detailed reporting**: Shows execution time and detailed failure information
- **Error handling**: Captures compilation errors and runtime exceptions
- **Submission generation**: Creates package-free versions ready for competitive programming
- **Flexible**: Works with any number of test cases
- **Cross-platform**: Works on macOS, Linux, and WSL

## Requirements

- Java Development Kit (JDK) 8 or higher
- Bash shell (for the provided scripts)
- Unix-like environment (Linux, macOS, WSL on Windows)

## Troubleshooting

### Compilation Errors
If you get compilation errors, check:
- Package declaration matches the directory structure
- Class name matches the file name
- All required imports are included

### Test Failures
If tests fail, check:
- Output format matches exactly (including spaces and newlines)
- Input parsing is correct
- Algorithm logic is implemented properly

### Submission Issues
If submission files don't work:
- Ensure your original solution works with the regular test command
- Check that the generated file in `submit/` directory compiles correctly
- Verify output format matches expected results exactly

### Permission Errors
If you get permission errors, make the scripts executable:
```bash
chmod +x test.sh run.sh
```

## Manual Testing

You can also use the TestCaseReader class directly:

```bash
javac com/cses/utils/TestCaseReader.java
java com.cses.utils.TestCaseReader ProblemName
```

This provides the same functionality as the `test.sh` script but without the convenience wrapper.

## Available Commands

### Main Runner (Recommended)
- **`./cses test <ProblemName>`** - Run all test cases for a problem
- **`./cses run <ProblemName>`** - Run a problem interactively
- **`./cses new <ProblemName>`** - Create a new problem with template
- **`./cses submit <ProblemName>`** - Generate submission-ready code (no package)
- **`./cses test-submit <ProblemName>`** - Test submission-ready code (auto-generates if needed)
- **`./cses status`** - Show overview of all problems and their test status
- **`./cses help`** - Show help message

### Direct Script Access
- **`./scripts/test.sh <ProblemName>`** - Run all test cases for a problem
- **`./scripts/run.sh <ProblemName>`** - Run a problem interactively
- **`./scripts/new_problem.sh <ProblemName>`** - Create a new problem with template
- **`./scripts/submit.sh <ProblemName>`** - Generate submission-ready code (no package)
- **`./scripts/test_submit.sh <ProblemName>`** - Test submission-ready code (auto-generates if needed)
- **`./scripts/status.sh`** - Show overview of all problems and their test status

All commands include help text when run without arguments.