#!/bin/bash

# Best-Practice IaC Security Scanner
# Runs Checkov, TFLint, Trivy, and Gitleaks with baseline support and multi-format outputs.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
REPORTS_BASE_DIR="${REPO_ROOT}/security-reports"
REPORTS_DIR="${REPORTS_BASE_DIR}/${TIMESTAMP}"

echo "🛡️  Starting Best-Practice IaC Security Scans..."
echo "📂 Repository: ${REPO_ROOT}"

# Detect Operating System
OS="$(uname -s)"
echo "🖥️  Detected OS: ${OS}"

install_tool() {
    local tool=$1
    echo "⚙️  Installing ${tool}..."
    if [ "${OS}" = "Darwin" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "❌ Homebrew is required on macOS to install ${tool}. Please install it first."
            exit 1
        fi
        if [ "${tool}" = "checkov" ]; then
            brew install checkov || pip3 install checkov
        elif [ "${tool}" = "tflint" ]; then
            brew install tflint || (brew tap terraform-linters/tap && brew trust terraform-linters/tap && brew install tflint)
        elif [ "${tool}" = "trivy" ]; then
            brew install aquasecurity/trivy/trivy || (brew tap aquasecurity/trivy && brew trust aquasecurity/trivy && brew install aquasecurity/trivy/trivy) || curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        else
            brew install "${tool}"
        fi
    elif [ "${OS}" = "Linux" ]; then
        if [ "${tool}" = "checkov" ]; then
            pip3 install checkov
        elif [ "${tool}" = "tflint" ]; then
            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
        elif [ "${tool}" = "trivy" ]; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        elif [ "${tool}" = "gitleaks" ]; then
            echo "⚠️  Please install Gitleaks manually on Linux: https://github.com/gitleaks/gitleaks/releases"
            exit 1
        elif [ "${tool}" = "jq" ]; then
            # Attempt apt-get for debian/ubuntu
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y jq
            else
                echo "⚠️  Please install jq manually on Linux"
                exit 1
            fi
        fi
    else
        echo "❌ Unsupported OS for automatic installation: ${OS}"
        exit 1
    fi
}

# Ensure all tools are installed
for tool in checkov tflint trivy gitleaks jq; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "⚠️  $tool is not installed."
        install_tool "$tool"
    fi
done

# Create reports directories
mkdir -p "${REPORTS_DIR}"
rm -f "${REPORTS_BASE_DIR}/latest"
ln -s "${TIMESTAMP}" "${REPORTS_BASE_DIR}/latest"
echo "📁 Reports will be saved to: ${REPORTS_DIR}"
echo "----------------------------------------------------"

# Set target directories (only scan real code, not terragrunt caches)
TARGET_DIRS="${REPO_ROOT}/modules ${REPO_ROOT}/root-modules"
# Filter targets that actually exist
ACTUAL_TARGETS=""
for dir in $TARGET_DIRS; do
    if [ -d "$dir" ]; then
        ACTUAL_TARGETS="$ACTUAL_TARGETS $dir"
    fi
done

if [ -z "$ACTUAL_TARGETS" ]; then
    echo "❌ No target directories (modules/, root-modules/) found to scan."
    exit 1
fi
echo "🎯 Scanning targets:${ACTUAL_TARGETS}"
echo "----------------------------------------------------"

# 1. Gitleaks (Secrets)
echo "🔍 Running Gitleaks..."
set +e
gitleaks detect --source "${REPO_ROOT}" -v --report-format json --report-path "${REPORTS_DIR}/gitleaks.json" > "${REPORTS_DIR}/gitleaks.txt" 2>&1
set -e
echo "✅ Gitleaks complete."
echo "----------------------------------------------------"

# 2. Checkov (Primary Policy Gate)
echo "🔍 Running Checkov..."
BASELINE_ARG=""
if [ -f "${REPO_ROOT}/.checkov.baseline" ]; then
    echo "ℹ️  Using existing .checkov.baseline"
    BASELINE_ARG="--baseline ${REPO_ROOT}/.checkov.baseline"
fi

# Build multiple -d arguments for Checkov
CHECKOV_TARGETS=""
for dir in $ACTUAL_TARGETS; do
    CHECKOV_TARGETS="$CHECKOV_TARGETS -d $dir"
done

set +e
# Run with CLI output to terminal/text, and SARIF/JSON outputs
checkov $CHECKOV_TARGETS ${BASELINE_ARG} --output cli --output sarif --output json \
    --output-file-path console,"${REPORTS_DIR}/checkov.sarif","${REPORTS_DIR}/checkov.json" \
    > "${REPORTS_DIR}/checkov.txt" 2>&1
set -e
echo "✅ Checkov scan complete."
echo "----------------------------------------------------"

# 3. TFLint (Linter)
echo "🔍 Running TFLint..."
set +e
echo "Initializing TFLint plugins..."
tflint --init --config "${REPO_ROOT}/.tflint.hcl" >/dev/null 2>&1

tflint --recursive --config "${REPO_ROOT}/.tflint.hcl" > "${REPORTS_DIR}/tflint.txt" 2>&1
tflint --recursive --config "${REPO_ROOT}/.tflint.hcl" -f json > "${REPORTS_DIR}/tflint.json" 2>&1
set -e
echo "✅ TFLint scan complete."
echo "----------------------------------------------------"

# 4. Trivy (Second Opinion)
echo "🔍 Running Trivy..."
set +e
# Trivy only accepts a single target directory, so we scan the root and skip the noisy dirs
TRIVY_SKIP="--skip-dirs ${REPO_ROOT}/aws --skip-dirs ${REPO_ROOT}/.terragrunt-cache --skip-dirs ${REPO_ROOT}/docs --skip-dirs ${REPO_ROOT}/.git --skip-dirs ${REPO_ROOT}/security-reports"

# Run table, JSON, and SARIF
trivy config ${REPO_ROOT} ${TRIVY_SKIP} --severity HIGH,CRITICAL --skip-version-check > "${REPORTS_DIR}/trivy.txt" 2>&1
trivy config ${REPO_ROOT} ${TRIVY_SKIP} --severity HIGH,CRITICAL --format json --skip-version-check > "${REPORTS_DIR}/trivy.json" 2>&1
trivy config ${REPO_ROOT} ${TRIVY_SKIP} --severity HIGH,CRITICAL --format sarif --skip-version-check > "${REPORTS_DIR}/trivy.sarif" 2>&1
set -e
echo "✅ Trivy scan complete."
echo "----------------------------------------------------"

# Generate SUMMARY.md
echo "📊 Generating Summary..."
SUMMARY_FILE="${REPORTS_DIR}/SUMMARY.md"

cat <<EOF > "${SUMMARY_FILE}"
# Security Scan Summary
**Timestamp:** ${TIMESTAMP}

## Checkov (Primary Policy Gate)
*See \`checkov.txt\`, \`checkov.json\`, \`checkov.sarif\` for details.*
EOF

# Parse Checkov JSON safely (handle case where no json is produced or it's empty)
if [ -f "${REPORTS_DIR}/checkov.json" ] && [ -s "${REPORTS_DIR}/checkov.json" ]; then
    FAILED_CHECKS=$(jq '.results.failed_checks | length' "${REPORTS_DIR}/checkov.json" 2>/dev/null || echo "0")
    PASSED_CHECKS=$(jq '.results.passed_checks | length' "${REPORTS_DIR}/checkov.json" 2>/dev/null || echo "0")
    echo "- **Failed Checks:** ${FAILED_CHECKS}" >> "${SUMMARY_FILE}"
    echo "- **Passed Checks:** ${PASSED_CHECKS}" >> "${SUMMARY_FILE}"
else
    echo "- No JSON results produced (Checkov may have failed to execute or found 0 target files)." >> "${SUMMARY_FILE}"
fi

cat <<EOF >> "${SUMMARY_FILE}"

## Trivy (Second Opinion - High/Critical Only)
*See \`trivy.txt\`, \`trivy.json\`, \`trivy.sarif\` for details.*
EOF

if [ -f "${REPORTS_DIR}/trivy.json" ] && [ -s "${REPORTS_DIR}/trivy.json" ]; then
    TRIVY_VULNS=$(jq '[.Results[]? | .Misconfigurations[]?] | length' "${REPORTS_DIR}/trivy.json" 2>/dev/null || echo "0")
    echo "- **Misconfigurations (High/Critical):** ${TRIVY_VULNS}" >> "${SUMMARY_FILE}"
else
    echo "- No High/Critical misconfigurations found." >> "${SUMMARY_FILE}"
fi

cat <<EOF >> "${SUMMARY_FILE}"

## TFLint (Linter)
*See \`tflint.txt\`, \`tflint.json\` for details.*
EOF

if [ -f "${REPORTS_DIR}/tflint.json" ] && [ -s "${REPORTS_DIR}/tflint.json" ]; then
    TFLINT_ISSUES=$(jq '.issues | length' "${REPORTS_DIR}/tflint.json" 2>/dev/null || echo "0")
    echo "- **Lint Issues:** ${TFLINT_ISSUES}" >> "${SUMMARY_FILE}"
else
    echo "- No JSON results produced." >> "${SUMMARY_FILE}"
fi

cat <<EOF >> "${SUMMARY_FILE}"

## Gitleaks (Secrets)
*See \`gitleaks.txt\`, \`gitleaks.json\` for details.*
EOF

if [ -f "${REPORTS_DIR}/gitleaks.json" ] && [ -s "${REPORTS_DIR}/gitleaks.json" ]; then
    SECRETS_FOUND=$(jq 'length' "${REPORTS_DIR}/gitleaks.json" 2>/dev/null || echo "0")
    echo "- **Hardcoded Secrets Found:** ${SECRETS_FOUND}" >> "${SUMMARY_FILE}"
else
    echo "- No hardcoded secrets found." >> "${SUMMARY_FILE}"
fi

echo "🎉 All requested security scans have finished!"
echo "📄 View your summary at: ${SUMMARY_FILE}"
