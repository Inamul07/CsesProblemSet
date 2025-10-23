#!/bin/bash

# CSES New Problem Setup Script
# Usage: ./scripts/new_problem.sh <ProblemName>
# Example: ./scripts/new_problem.sh TwoSum

# Change to project root directory
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/new_problem.sh <ProblemName>"
    echo "Example: ./scripts/new_problem.sh TwoSum"
    exit 1
fi

PROBLEM_NAME=$1
PROBLEM_PATH="com/cses/problems/$PROBLEM_NAME"

# Check if problem already exists
if [ -d "$PROBLEM_PATH" ]; then
    echo "Error: Problem '$PROBLEM_NAME' already exists!"
    exit 1
fi

# Validate problem name (should be valid Java class name)
if [[ ! $PROBLEM_NAME =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo "Error: Problem name must be a valid Java class name (start with uppercase letter, no spaces or special characters)"
    echo "Example: TwoSum, WeirdAlgorithm, DynamicRangeSum"
    exit 1
fi

echo "Creating new problem: $PROBLEM_NAME"

# Create problem directory structure
mkdir -p "$PROBLEM_PATH/tests"

# Create Java template file
cat > "$PROBLEM_PATH/$PROBLEM_NAME.java" << EOF
package com.cses.problems.$PROBLEM_NAME;

import java.util.Scanner;

public class $PROBLEM_NAME {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

    }
}
EOF

# Create sample test case
cat > "$PROBLEM_PATH/tests/1.in" << EOF
5
EOF

cat > "$PROBLEM_PATH/tests/1.out" << EOF
5
EOF

echo "✅ Problem '$PROBLEM_NAME' created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit $PROBLEM_PATH/$PROBLEM_NAME.java to implement your solution"
echo "  2. Add test cases in $PROBLEM_PATH/tests/"
echo "  3. Test your solution with: ./scripts/test.sh $PROBLEM_NAME"
echo "  4. Run interactively with: ./scripts/run.sh $PROBLEM_NAME"
echo ""
echo "Happy coding! 🚀"
