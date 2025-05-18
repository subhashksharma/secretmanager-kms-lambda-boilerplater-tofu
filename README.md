# lambda-boilerplate-code

This project provides an enterprise-grade Python boilerplate for managing multiple AWS Lambda functions using Infrastructure as Code (IaaC). It supports packaging Lambda functions as zip files and deploying to multiple environments (dev, staging, prod).

## Features
- Modular structure for multiple Lambda functions
- Environment-based configuration (dev, staging, prod)
- IaaC templates (Terraform, AWS SAM, or OpenTofu)
- Python best practices: virtualenv, requirements.txt, unit tests
- Automated Lambda packaging (zip)

## Local Development & Getting Started

To run this project locally after cloning from GitHub:

1. **Clone the repository:**
   ```zsh
   git clone <your-repo-url>
   cd lambda-boilerplate-code
   ```

2. **Set up a Python virtual environment:**
   ```zsh
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Install global dependencies:**
   ```zsh
   pip install -r requirements.txt
   ```

4. **Install Lambda dependencies:**
   For each Lambda in `lambdas/<lambda_name>/`, if a `requirements.txt` exists, run:
   ```zsh
   cd lambdas/<lambda_name>
   pip install -r requirements.txt -t .
   cd ../..
   ```

5. **Package Lambda functions:**
   ```zsh
   zsh package_lambdas.sh
   ```
   This will create zip files in the `dist/` directory, ready for deployment.

6. **Configure your environment:**
   - Edit `iac/terraform.tfvars` for infrastructure variables.

7. **Deploy infrastructure (OpenTofu/Terraform):**
   ```zsh
   cd iac
   tofu init
   tofu apply
   ```

8. **Run tests:**
   ```zsh
   pytest tests/
   ```

## Setting Up OpenTofu Locally

To use OpenTofu (an open-source Terraform alternative) for infrastructure management, follow these steps:

1. **Install OpenTofu:**
   - On macOS (using Homebrew):
     ```zsh
     brew install opentofu/tap/opentofu
     ```
   - Or download from: https://opentofu.org/download/

2. **Verify installation:**
   ```zsh
   tofu --version
   ```
   You should see the installed version printed.

3. **Initialize and apply infrastructure:**
   ```zsh
   cd iac
   tofu init
   tofu apply
   ```

## Directory Structure
- `lambdas/` - Source code for individual Lambda functions
- `iac/` - Infrastructure as Code templates
- `tests/` - Unit tests

## Packaging Lambda Functions
Each Lambda function should be placed in its own folder under `lambdas/`. To package all Lambda functions as zip files for deployment, you have two options:

### Option 1: Using VS Code Task
1. Open the Command Palette (⇧⌘P) and type “Run Task”.
2. Select “Package Lambda Functions”.
3. The zip files will be created in the `dist/` directory.

### Option 2: Using Terminal
1. Make sure you are in your project root directory.
2. Run:
   ```zsh
   zsh package_lambdas.sh
   ```
3. The zip files will be created in the `dist/` directory.

## Contributing
Contributions are welcome! Please open issues or submit pull requests.

## License
MIT License
