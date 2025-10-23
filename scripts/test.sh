#!/bin/bash

# CSES Problem Test Runner
# Usage: ./scripts/test.sh <ProblemName>
# Example: ./scripts/test.sh WeirdAlgorithm

# Change to project root directory
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/test.sh <ProblemName>"
    echo "Example: ./scripts/test.sh WeirdAlgorithm"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

PROBLEM_NAME=$1

# Check if problem exists
if [ ! -d "com/cses/problems/$PROBLEM_NAME" ]; then
    echo "Error: Problem '$PROBLEM_NAME' not found!"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

# Check if tests directory exists
if [ ! -d "com/cses/problems/$PROBLEM_NAME/tests" ]; then
    echo "Error: Tests directory not found for problem '$PROBLEM_NAME'"
    exit 1
fi

echo "Compiling TestCaseReader..."
javac com/cses/utils/TestCaseReader.java

if [ $? -ne 0 ]; then
    echo "Error: Failed to compile TestCaseReader"
    exit 1
fi

echo "Running tests for $PROBLEM_NAME..."
echo ""

java -cp . com.cses.utils.TestCaseReader "$PROBLEM_NAME"
