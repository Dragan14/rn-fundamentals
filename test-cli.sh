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

# Function to check if a file does NOT exist
check_file_absent() {
  file_path="$1"
  if [ ! -f "$file_path" ]; then
    echo -e "${GREEN}✓ File absent (as expected): ${file_path}${NC}"
  else
    echo -e "${RED}✗ File should not exist: ${file_path}${NC}"
  fi
}

# ---------------------------------------------------------------------------
# help / list / unknown command
# ---------------------------------------------------------------------------

test_command "help" "Help command"
test_command "list" "List available components"
test_command "invalid" "Unknown command"

# ---------------------------------------------------------------------------
# add — error cases
# ---------------------------------------------------------------------------

test_command "add" "Add with no component name"
test_command "add InvalidComponent" "Add invalid component"

# ---------------------------------------------------------------------------
# add — single components
# ---------------------------------------------------------------------------

test_command "add Button" "Add Button component"
check_file "${TEST_DIR}/components/ui/Button.tsx"

test_command "add TextInput" "Add TextInput component"
check_file "${TEST_DIR}/components/ui/TextInput.tsx"

test_command "add Text" "Add Text component"
check_file "${TEST_DIR}/components/ui/Text.tsx"

test_command "add RadioButton" "Add RadioButton component"
check_file "${TEST_DIR}/components/ui/RadioButton.tsx"

test_command "add SegmentedControl" "Add SegmentedControl component"
check_file "${TEST_DIR}/components/ui/SegmentedControl.tsx"

test_command "add Switch" "Add Switch component"
check_file "${TEST_DIR}/components/ui/Switch.tsx"

test_command "add View" "Add View component"
check_file "${TEST_DIR}/components/ui/View.tsx"

test_command "add SafeAreaView" "Add SafeAreaView component (requires react-native-safe-area-context)"
check_file "${TEST_DIR}/components/ui/SafeAreaView.tsx"

# Components that auto-add their context
test_command "add Toast" "Add Toast component (auto-adds ToastContext)"
check_file "${TEST_DIR}/components/ui/Toast.tsx"
check_file "${TEST_DIR}/context/ui/ToastContext.tsx"

test_command "add Alert" "Add Alert component (auto-adds AlertContext)"
check_file "${TEST_DIR}/components/ui/Alert.tsx"
check_file "${TEST_DIR}/context/ui/AlertContext.tsx"

# ---------------------------------------------------------------------------
# add — themes (auto-adds ThemeContext)
# ---------------------------------------------------------------------------

test_command "add blueTheme" "Add blueTheme"
check_file "${TEST_DIR}/themes/blueTheme.ts"
check_file "${TEST_DIR}/context/ui/ThemeContext.tsx"

# ---------------------------------------------------------------------------
# add — contexts directly
# ---------------------------------------------------------------------------

# Remove the contexts that were auto-added so we can test adding them directly
rm -f "${TEST_DIR}/context/ui/ThemeContext.tsx"
rm -f "${TEST_DIR}/context/ui/ToastContext.tsx"
rm -f "${TEST_DIR}/context/ui/AlertContext.tsx"

test_command "add ThemeContext" "Add ThemeContext directly"
check_file "${TEST_DIR}/context/ui/ThemeContext.tsx"

test_command "add ToastContext" "Add ToastContext directly"
check_file "${TEST_DIR}/context/ui/ToastContext.tsx"

test_command "add AlertContext" "Add AlertContext directly"
check_file "${TEST_DIR}/context/ui/AlertContext.tsx"

# ---------------------------------------------------------------------------
# add — duplicate (should warn, not error)
# ---------------------------------------------------------------------------

test_command "add Button" "Add duplicate Button (should warn)"
test_command "add blueTheme" "Add duplicate blueTheme (should warn)"
test_command "add ThemeContext" "Add duplicate ThemeContext (should warn)"

# ---------------------------------------------------------------------------
# update — error cases
# ---------------------------------------------------------------------------

test_command "update" "Update with no component name"
test_command "update InvalidComponent" "Update invalid component"

# Test update on a component that doesn't exist in the project yet
rm -f "${TEST_DIR}/components/ui/Text.tsx"
test_command "update Text" "Update component not yet in project (should prompt to add first)"
check_file_absent "${TEST_DIR}/components/ui/Text.tsx"

# ---------------------------------------------------------------------------
# update — single components
# ---------------------------------------------------------------------------

test_command "update Button" "Update existing Button component"
check_file "${TEST_DIR}/components/ui/Button.tsx"

test_command "update blueTheme" "Update existing blueTheme"
check_file "${TEST_DIR}/themes/blueTheme.ts"

test_command "update ThemeContext" "Update existing ThemeContext"
check_file "${TEST_DIR}/context/ui/ThemeContext.tsx"

test_command "update Toast" "Update existing Toast component"
check_file "${TEST_DIR}/components/ui/Toast.tsx"

test_command "update Alert" "Update existing Alert component"
check_file "${TEST_DIR}/components/ui/Alert.tsx"

# ---------------------------------------------------------------------------
# remove — error cases
# ---------------------------------------------------------------------------

test_command "remove" "Remove with no component name"
test_command "remove InvalidComponent" "Remove invalid component"

# Remove a component that doesn't exist in the project
test_command "remove Text" "Remove component not in project (should warn)"

# ---------------------------------------------------------------------------
# remove — single components
# ---------------------------------------------------------------------------

test_command "remove Button" "Remove Button component"
check_file_absent "${TEST_DIR}/components/ui/Button.tsx"

test_command "remove blueTheme" "Remove blueTheme"
check_file_absent "${TEST_DIR}/themes/blueTheme.ts"

test_command "remove ThemeContext" "Remove ThemeContext"
check_file_absent "${TEST_DIR}/context/ui/ThemeContext.tsx"

test_command "remove Toast" "Remove Toast component"
check_file_absent "${TEST_DIR}/components/ui/Toast.tsx"

test_command "remove Alert" "Remove Alert component"
check_file_absent "${TEST_DIR}/components/ui/Alert.tsx"

# ---------------------------------------------------------------------------
# add all / update all / remove all
# ---------------------------------------------------------------------------

echo -e "\n${YELLOW}Testing 'add all' command...${NC}"
rm -rf "${TEST_DIR}"
mkdir -p "${TEST_DIR}"
cd "${TEST_DIR}"

test_command "add all" "Add all components, contexts, and themes"

echo -e "\n${YELLOW}Checking all components were added:${NC}"
for component in Button TextInput Text RadioButton SegmentedControl Switch Toast Alert SafeAreaView View; do
  check_file "${TEST_DIR}/components/ui/${component}.tsx"
done
check_file "${TEST_DIR}/themes/blueTheme.ts"
check_file "${TEST_DIR}/context/ui/ThemeContext.tsx"
check_file "${TEST_DIR}/context/ui/ToastContext.tsx"
check_file "${TEST_DIR}/context/ui/AlertContext.tsx"

echo -e "\n${YELLOW}Testing 'update all' command...${NC}"
test_command "update all" "Update all components, contexts, and themes"

echo -e "\n${YELLOW}Checking all components still exist after update:${NC}"
for component in Button TextInput Text RadioButton SegmentedControl Switch Toast Alert SafeAreaView View; do
  check_file "${TEST_DIR}/components/ui/${component}.tsx"
done
check_file "${TEST_DIR}/themes/blueTheme.ts"
check_file "${TEST_DIR}/context/ui/ThemeContext.tsx"
check_file "${TEST_DIR}/context/ui/ToastContext.tsx"
check_file "${TEST_DIR}/context/ui/AlertContext.tsx"

echo -e "\n${YELLOW}Testing 'remove all' command...${NC}"
test_command "remove all" "Remove all components, contexts, and themes"

echo -e "\n${YELLOW}Checking all components were removed:${NC}"
for component in Button TextInput Text RadioButton SegmentedControl Switch Toast Alert SafeAreaView View; do
  check_file_absent "${TEST_DIR}/components/ui/${component}.tsx"
done
check_file_absent "${TEST_DIR}/themes/blueTheme.ts"
check_file_absent "${TEST_DIR}/context/ui/ThemeContext.tsx"
check_file_absent "${TEST_DIR}/context/ui/ToastContext.tsx"
check_file_absent "${TEST_DIR}/context/ui/AlertContext.tsx"

# ---------------------------------------------------------------------------
# Clean up
# ---------------------------------------------------------------------------

echo -e "\n${YELLOW}Cleaning up test directory${NC}"
rm -rf "${TEST_DIR}"

echo -e "\n${GREEN}All tests completed!${NC}"
