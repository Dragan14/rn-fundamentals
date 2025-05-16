#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create a temp directory for testing
TEST_DIR="/tmp/rn-fundamentals-test"
echo -e "${YELLOW}Creating test directory at ${TEST_DIR}${NC}"
rm -rf "${TEST_DIR}"
mkdir -p "${TEST_DIR}"
cd "${TEST_DIR}"

# Function to run CLI command and check result
test_command() {
  command="$1"
  description="$2"
  expected_exit_code="${3:-0}"
  
  echo -e "\n${YELLOW}Testing: ${description}${NC}"
  echo -e "Command: node /Users/dragans/Desktop/rn-fundamentals/cli/cli.js ${command}"
  
  node /Users/dragans/Desktop/rn-fundamentals/cli/cli.js ${command}
  exit_code=$?
  
  if [ $exit_code -eq $expected_exit_code ]; then
    echo -e "${GREEN}✓ Command executed as expected${NC}"
  else
    echo -e "${RED}✗ Command failed with exit code ${exit_code}, expected ${expected_exit_code}${NC}"
  fi
}

# Function to check if a file exists
check_file() {
  file_path="$1"
  if [ -f "$file_path" ]; then
    echo -e "${GREEN}✓ File exists: ${file_path}${NC}"
  else
    echo -e "${RED}✗ File not found: ${file_path}${NC}"
  fi
}

# Test help command
test_command "help" "Help command"

# Test list command
test_command "list" "List available components"

# Test adding a single component
test_command "add Button" "Add Button component"
check_file "${TEST_DIR}/components/ui/Button.tsx"

# Test adding a theme
test_command "add blueTheme" "Add blue theme"
check_file "${TEST_DIR}/themes/blueTheme.ts"
check_file "${TEST_DIR}/context/ThemeContext.tsx"

# Test adding a component that requires context
test_command "add Toast" "Add Toast component (requires context)"
check_file "${TEST_DIR}/components/ui/Toast.tsx"
check_file "${TEST_DIR}/context/ToastContext.tsx"

# Test adding another component that requires context
test_command "add Alert" "Add Alert component (requires context)"
check_file "${TEST_DIR}/components/ui/Alert.tsx"
check_file "${TEST_DIR}/context/AlertContext.tsx"

# Test adding a component that requires dependencies
test_command "add SafeAreaView" "Add SafeAreaView component (requires dependencies)"
check_file "${TEST_DIR}/components/ui/SafeAreaView.tsx"

# Test duplicate component (should show warning but not error)
test_command "add Button" "Add duplicate component"

# Test invalid component (should show error but continue)
test_command "add InvalidComponent" "Add invalid component" 1

# Test invalid command (should show help)
test_command "invalid" "Invalid command" 1

# Clean up and create new directory for testing add all
echo -e "\n${YELLOW}Testing 'add all' command...${NC}"
rm -rf "${TEST_DIR}"
mkdir -p "${TEST_DIR}"
cd "${TEST_DIR}"

# Test add all command
test_command "add all" "Add all components at once"

# Check that all important files exist
echo -e "\n${YELLOW}Checking that all components were added:${NC}"
for component in Button TextInput Text RadioButton SegmentedControl Switch Toast Alert SafeAreaView View; do
  check_file "${TEST_DIR}/components/ui/${component}.tsx"
done

check_file "${TEST_DIR}/themes/blueTheme.ts"
check_file "${TEST_DIR}/context/ThemeContext.tsx"
check_file "${TEST_DIR}/context/ToastContext.tsx"
check_file "${TEST_DIR}/context/AlertContext.tsx"

# Clean up
echo -e "\n${YELLOW}Cleaning up test directory${NC}"
rm -rf "${TEST_DIR}"

echo -e "\n${GREEN}All tests completed!${NC}"
