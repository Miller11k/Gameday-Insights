#!/bin/bash

# Set variables for operating systems
MACOS="MacOS"
WINDOWS="Windows"
LINUX_GENERIC="Linux (Generic)"
UBUNTU="Linux (Ubuntu)"
FEDORA="Linux (Fedora)"
DEBIAN="Linux (Debian)"
CENTOS="Linux (CentOS)"
UNSUPPORTED="Unsupported OS"

# Function to detect the OS
detect_os() {
    # Initialize OS variable to unsupported
    local OS=$UNSUPPORTED

    # Detect the operating system
    if [[ "$OSTYPE" == "darwin"* ]]; then   # Check if running MacOS
        OS=$MACOS
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then  # Check if running Linux distro
        # Check for specific Linux distributions
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case "$ID" in
                ubuntu)
                    OS=$UBUNTU
                    ;;
                fedora)
                    OS=$FEDORA
                    ;;
                debian)
                    OS=$DEBIAN
                    ;;
                centos)
                    OS=$CENTOS
                    ;;
                *)
                    OS=$LINUX_GENERIC  # Generic Linux if distro is unrecognized
                    ;;
            esac
        else
            OS=$LINUX_GENERIC  # Fallback to generic Linux
        fi
    elif [[ "$OSTYPE" == "cygwin"* || "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then # Check if Windows
        OS=$WINDOWS
    fi

    echo "$OS"  # Return OS Type
}

# Functionality to ensure that Python is installed (if running on MacOS)
check_python_macos() {
    if ! command -v python3 &> /dev/null; then
        echo "Python3 is not installed. Installing via Homebrew..."
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install python
    else
        echo "Python3 is already installed on MacOS."
    fi
}

# Debian/Ubuntu Functionality
check_python_debian_ubuntu() {
    if ! command -v python3 &> /dev/null; then
        echo "Python3 is not installed. Installing it using apt..."
        sudo apt update
        sudo apt install -y python3
    else
        echo "Python3 is already installed on Debian/Ubuntu."
    fi
}

# Example usage of the function
main() {
    OS=$(detect_os)

    # Print the detected OS
    echo "Detected OS: $OS"

    # Conditional logic based on the detected OS
    if [[ $OS == $MACOS ]]; then
        echo "Running on MacOS: Performing Mac-specific tasks..."
        check_python_macos
    elif [[ $OS == $WINDOWS ]]; then
        echo "Running on Windows: Performing Windows-specific tasks..."
        echo "Ensure Python is installed via the official Python installer."
    elif [[ $OS == $UBUNTU || $OS == $DEBIAN ]]; then
        echo "Running on Ubuntu/Debian: Performing Debian-specific tasks..."
        check_python_debian_ubuntu
    elif [[ $OS == $FEDORA ]]; then
        echo "Running on Fedora: Performing Fedora-specific tasks..."
        echo "Ensure Python is installed using 'sudo dnf install python3'."
    elif [[ $OS == $CENTOS ]]; then
        echo "Running on CentOS: Performing CentOS-specific tasks..."
        echo "Ensure Python is installed using 'sudo yum install python3'."
    elif [[ $OS == $LINUX_GENERIC ]]; then
        echo "Running on an unrecognized Linux distribution: Performing generic Linux tasks..."
        echo "Ensure Python is installed via your package manager."
    else
        echo "Unsupported OS: Exiting."
        exit 1
    fi
}

# Call the main function
main