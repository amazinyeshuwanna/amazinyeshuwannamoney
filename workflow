# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# A sample workflow which checks out your Infrastructure as Code Configuration files,
# such as Kubernetes, Helm & Terraform and scans them for any security issues.
# The results are then uploaded to GitHub Security Code Scanning
#
# For more examples, including how to limit scans to only high-severity issues
# and fail PR checks, see https://github.com/snyk/actions/

name: Snyk Infrastructure as Code

on:
  push:
    branches: [ master ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ master ]
  schedule:
    - cron: '41 9 * * 0'

jobs:
  snyk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Snyk to check configuration files for security issues
        # Snyk can be used to break the build when it detects security issues.
        # In this case we want to upload the issues to GitHub Code Scanning
        continue-on-error: true
        uses: snyk/actions/iac@14818c4695ecc4045f33c9cee9e795a788711ca4
        env:
          # In order to use the Snyk Action you will need to have a Snyk API token.
          # More details in https://github.com/snyk/actions#getting-your-snyk-token
          # or you can signup for free at https://snyk.io/login
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          # Add the path to the configuration file that you would like to test.
          # For example `deployment.yaml` for a Kubernetes deployment manifest
          # or `main.tf` for a Terraform configuration file
          file: your-file-to-test.yaml
      - name: Upload result to GitHub Code Scanning
        uses: github/codeql-action/upload-sarif@v1
        with:
          sarif_file: snyk.sarif
