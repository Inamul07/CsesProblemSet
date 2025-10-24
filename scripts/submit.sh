#!/bin/bash

# CSES Problem Submission Generator
# Usage: ./scripts/submit.sh <ProblemName>
# Example: ./scripts/submit.sh WeirdAlgorithm

# Change to project root directory
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/submit.sh <ProblemName>"
    echo "Example: ./scripts/submit.sh WeirdAlgorithm"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

PROBLEM_NAME=$1
PROBLEM_DIR=$(echo $PROBLEM_NAME | tr '[:upper:]' '[:lower:]')
PROBLEM_PATH="com/cses/problems/$PROBLEM_DIR"
JAVA_FILE="$PROBLEM_PATH/$PROBLEM_NAME.java"
SUBMIT_DIR="submit"
SUBMIT_FILE="$SUBMIT_DIR/$PROBLEM_NAME.java"

# Check if problem exists
if [ ! -f "$JAVA_FILE" ]; then
    echo "Error: Problem '$PROBLEM_NAME' not found!"
    echo "Expected file: $JAVA_FILE"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

# Create submit directory if it doesn't exist
mkdir -p "$SUBMIT_DIR"

echo "Generating submission file for $PROBLEM_NAME..."

# Remove package declaration and create submission-ready file
sed '/^package /d' "$JAVA_FILE" > "$SUBMIT_FILE"

echo "✅ Submission file created: $SUBMIT_FILE"
echo ""
echo "File contents:"
echo "=========================="
cat "$SUBMIT_FILE"
echo "=========================="
echo ""
echo "This file is ready for submission (no package declaration)."
echo "You can copy the contents above or use: cat $SUBMIT_FILE"

# Test compilation to make sure it works without package
echo ""
echo "Testing compilation without package..."
cd "$SUBMIT_DIR"
javac "$PROBLEM_NAME.java" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful - ready for submission!"

    # Clean up compiled class file
    rm -f "$PROBLEM_NAME.class"
else
    echo "❌ Compilation failed - please check the code"
    javac "$PROBLEM_NAME.java"
fi

cd ..
