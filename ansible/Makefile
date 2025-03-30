# Variables
VENV_DIR ?= .venv
PYTHON ?= python3
PIP ?= $(VENV_DIR)/bin/pip
ANSIBLE_PLAYBOOK ?= $(VENV_DIR)/bin/ansible-playbook

# Default target
all: venv

# Create a Python virtual environment and install dependencies
venv:
	@echo "Creating Python virtual environment..."
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "Installing dependencies..."
	$(PIP) install --upgrade pip
	$(PIP) install ansible boto3 botocore
	@echo "Virtual environment setup complete."

# Clean up the virtual environment
clean:
	@echo "Removing virtual environment..."
	rm -rf $(VENV_DIR)
	@echo "Virtual environment removed."

# Run the Ansible playbook
run:
	@echo "Running Ansible playbook..."
	$(ANSIBLE_PLAYBOOK) plays/jenkins.yml

run-tag:
		@echo "Running Ansible playbook with tags: $(TAGS)"
		$(ANSIBLE_PLAYBOOK) plays/jenkins.yml --tags "$(TAGS)"

# Help message
help:
	@echo "Available targets:"
	@echo "  make venv    - Create a Python virtual environment and install dependencies"
	@echo "  make clean   - Remove the virtual environment"
	@echo "  make run     - Run the Ansible playbook"
	@echo "  make run-tag TAGS=<tags> - Run the Ansible playbook with specific tags"
	@echo "  make help    - Show this help message"