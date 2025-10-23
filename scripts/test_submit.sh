#!/bin/bash

# CSES Problem Submission Test Runner
# Tests the submission-ready file (without package) against test cases
# Usage: ./scripts/test_submit.sh <ProblemName>
# Example: ./scripts/test_submit.sh WeirdAlgorithm

# Change to project root directory
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/test_submit.sh <ProblemName>"
    echo "Example: ./scripts/test_submit.sh WeirdAlgorithm"
    echo ""
    echo "Available problems:"
    find com/cses/problems -name "*.java" -type f | sed 's|com/cses/problems/||g' | sed 's|/.*||g' | sort | uniq
    exit 1
fi

PROBLEM_NAME=$1
PROBLEM_PATH="com/cses/problems/$PROBLEM_NAME"
SUBMIT_DIR="submit"
SUBMIT_FILE="$SUBMIT_DIR/$PROBLEM_NAME.java"
TESTS_PATH="$PROBLEM_PATH/tests"

# Check if submission file exists, if not generate it
if [ ! -f "$SUBMIT_FILE" ]; then
    echo "Submission file not found. Generating it first..."
    echo ""

    # Run the submit script to generate the submission file
    SCRIPT_DIR="$(dirname "$0")"
    "$SCRIPT_DIR/submit.sh" "$PROBLEM_NAME"

    # Check if generation was successful
    if [ ! -f "$SUBMIT_FILE" ]; then
        echo "Error: Failed to generate submission file"
        exit 1
    fi

    echo ""
    echo "Submission file generated. Now running tests..."
    echo ""
fi

# Check if tests directory exists
if [ ! -d "$TESTS_PATH" ]; then
    echo "Error: Tests directory not found: $TESTS_PATH"
    exit 1
fi

echo "Testing submission file for: $PROBLEM_NAME"
echo "=================================================="
echo ""

# Compile the submission file
echo "Compiling submission file..."
cd "$SUBMIT_DIR"
javac "$PROBLEM_NAME.java"

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed"
    exit 1
fi

echo "✅ Compilation successful"
echo ""

# Find all test cases
TEST_FILES=($(ls "../$TESTS_PATH"/*.in 2>/dev/null | sort -V))

if [ ${#TEST_FILES[@]} -eq 0 ]; then
    echo "No test cases found in $TESTS_PATH"
    exit 1
fi

PASSED=0
TOTAL=0

# Run each test case
for input_file in "${TEST_FILES[@]}"; do
    test_num=$(basename "$input_file" .in)
    output_file="../$TESTS_PATH/$test_num.out"

    if [ ! -f "$output_file" ]; then
        echo "Warning: Output file not found for test $test_num"
        continue
    fi

    TOTAL=$((TOTAL + 1))

    # Read expected output
    expected_output=$(cat "$output_file" | tr -d '\r' | sed 's/[[:space:]]*$//')

    # Run the program with test input (with timeout handling for macOS)
    actual_output=$(java "$PROBLEM_NAME" < "$input_file" 2>/dev/null | tr -d '\r' | sed 's/[[:space:]]*$//')
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        printf "Test %2s: ❌ RUNTIME ERROR\n" "$test_num"
    elif [ "$expected_output" = "$actual_output" ]; then
        printf "Test %2s: ✅ PASS\n" "$test_num"
        PASSED=$((PASSED + 1))
    else
        printf "Test %2s: ❌ FAIL\n" "$test_num"
        echo "  Expected: $expected_output"
        echo "  Actual:   $actual_output"
    fi
done

# Clean up
rm -f "$PROBLEM_NAME.class"
cd ..

echo ""
echo "=================================================="
printf "Results: %d/%d tests passed (%.1f%%)\n" "$PASSED" "$TOTAL" $(echo "scale=1; $PASSED * 100 / $TOTAL" | bc -l)

if [ $PASSED -eq $TOTAL ]; then
    echo "🎉 All tests passed! Submission file is ready."
else
    echo "❌ Some tests failed. Check your solution."
fi

echo ""
echo "Submission file location: $SUBMIT_FILE"
echo "Use: cat $SUBMIT_FILE | pbcopy    # (macOS) to copy to clipboard"
echo "Use: cat $SUBMIT_FILE | xclip -selection clipboard    # (Linux) to copy to clipboard"
