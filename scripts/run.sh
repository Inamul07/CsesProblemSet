#!/bin/bash

# CSES Problem Interactive Runner
# Usage: ./scripts/run.sh <ProblemName>
# Example: ./scripts/run.sh WeirdAlgorithm

# Change to project root directory
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/run.sh <ProblemName>"
    echo "Example: ./scripts/run.sh WeirdAlgorithm"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

PROBLEM_NAME=$1
PROBLEM_DIR=$(echo $PROBLEM_NAME | tr '[:upper:]' '[:lower:]')
PROBLEM_PATH="com/cses/problems/$PROBLEM_DIR"
JAVA_FILE="$PROBLEM_PATH/$PROBLEM_NAME.java"

# Check if problem exists
if [ ! -f "$JAVA_FILE" ]; then
    echo "Error: Problem '$PROBLEM_NAME' not found!"
    echo "Expected file: $JAVA_FILE"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

echo "Compiling $PROBLEM_NAME..."
javac "$JAVA_FILE"

if [ $? -ne 0 ]; then
    echo "Error: Failed to compile $PROBLEM_NAME"
    exit 1
fi

echo "Running $PROBLEM_NAME (enter your input, press Ctrl+D when done):"
echo "----------------------------------------"

java -cp . "com.cses.problems.$PROBLEM_DIR.$PROBLEM_NAME"
