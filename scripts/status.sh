#!/bin/bash

# CSES Problem Status Overview
# Shows all problems and their current test status

# Change to project root directory
cd "$(dirname "$0")/.."

echo "CSES Problem Status Overview"
echo "==========================================="
echo ""

# Find all problems
PROBLEMS_DIR="com/cses/problems"

if [ ! -d "$PROBLEMS_DIR" ]; then
    echo "Error: Problems directory not found!"
    exit 1
fi

# Get list of all problems (extract class names from Java files)
PROBLEMS=$(find "$PROBLEMS_DIR" -name "*.java" -type f | sed 's|.*/||g' | sed 's|\.java$||g' | sort | uniq)

if [ -z "$PROBLEMS" ]; then
    echo "No problems found!"
    echo ""
    echo "Create a new problem with: ./new_problem.sh ProblemName"
    exit 0
fi

echo "Found $(echo "$PROBLEMS" | wc -l) problem(s):"
echo ""

# Compile TestCaseReader if needed
if [ ! -f "com/cses/utils/TestCaseReader.class" ] || [ "com/cses/utils/TestCaseReader.java" -nt "com/cses/utils/TestCaseReader.class" ]; then
    echo "Compiling TestCaseReader..."
    javac com/cses/utils/TestCaseReader.java
    if [ $? -ne 0 ]; then
        echo "Error: Failed to compile TestCaseReader"
        exit 1
    fi
    echo ""
fi

# Check each problem
for PROBLEM in $PROBLEMS; do
    PROBLEM_DIR=$(echo $PROBLEM | tr '[:upper:]' '[:lower:]')
    PROBLEM_PATH="$PROBLEMS_DIR/$PROBLEM_DIR"
    TESTS_PATH="$PROBLEM_PATH/tests"

    printf "%-20s" "$PROBLEM:"

    # Check if tests directory exists
    if [ ! -d "$TESTS_PATH" ]; then
        echo " ❌ No tests directory"
        continue
    fi

    # Count test cases
    TEST_COUNT=$(ls "$TESTS_PATH"/*.in 2>/dev/null | wc -l)
    if [ "$TEST_COUNT" -eq 0 ]; then
        echo " ❌ No test cases"
        continue
    fi

    # Try to compile the solution
    JAVA_FILE="$PROBLEM_PATH/$PROBLEM.java"
    if [ ! -f "$JAVA_FILE" ]; then
        echo " ❌ No solution file"
        continue
    fi

    javac "$JAVA_FILE" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo " ❌ Compilation failed"
        continue
    fi

    # Run tests quietly and get results
    RESULTS=$(java -cp . com.cses.utils.TestCaseReader "$PROBLEM" 2>/dev/null | grep "Results:" | sed 's/Results: //' | sed 's/ tests passed.*//')

    if [ -n "$RESULTS" ]; then
        PASSED=$(echo "$RESULTS" | cut -d'/' -f1)
        TOTAL=$(echo "$RESULTS" | cut -d'/' -f2)

        if [ "$PASSED" -eq "$TOTAL" ]; then
            echo " ✅ $PASSED/$TOTAL tests passed"
        else
            echo " ❌ $PASSED/$TOTAL tests passed"
        fi
    else
        echo " ❓ Could not run tests"
    fi
done

echo ""
echo "Commands:"
echo "  ./scripts/test.sh <ProblemName>    - Run tests for a specific problem"
echo "  ./scripts/run.sh <ProblemName>     - Run problem interactively"
echo "  ./scripts/new_problem.sh <Name>    - Create a new problem"
echo "  ./scripts/status.sh                - Show this overview"
