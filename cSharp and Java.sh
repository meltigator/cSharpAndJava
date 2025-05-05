#!/bin/bash

echo "=== Demonstration of the power of MSYS2 with C# and Java ==="
echo "Creating a C# program to flash characters and a Java program to generate data..."

WORKING_DIR=$(pwd)

# Check for Java and .NET presence
echo "Checking for Java and .NET..."

# Check if Java is available
if ! command -v javac &> /dev/null || ! command -v java &> /dev/null; then
    echo "Java not found in PATH. Trying to locate..."
    
    JAVA_WINDOWS_PATHS=(
        "/c/Program Files/Java"
        "/c/Program Files (x86)/Java"
        "$PROGRAMFILES/Java"
        "$PROGRAMFILES (x86)/Java"
        "$LOCALAPPDATA/Programs/Java"
    )
    
    JAVA_FOUND=0
    for BASE_PATH in "${JAVA_WINDOWS_PATHS[@]}"; do
        if [ -d "$BASE_PATH" ]; then
            for JDK_DIR in "$BASE_PATH"/jdk*; do
                if [ -d "$JDK_DIR/bin" ]; then
                    echo "Found Java at: $JDK_DIR"
                    export PATH="$JDK_DIR/bin:$PATH"
                    JAVA_FOUND=1
                    break 2
                fi
            done
        fi
    done
    
    if [ $JAVA_FOUND -eq 0 ]; then
        echo "ERROR: Java (JDK) not found. Please install it."
        echo "You can download JDK from: https://www.oracle.com/java/technologies/downloads/"
        exit 1
    fi
fi

# Check if .NET is available
if ! command -v dotnet &> /dev/null; then
    echo ".NET not found in PATH. Trying to locate..."
    
    DOTNET_WINDOWS_PATHS=(
        "/c/Program Files/dotnet"
        "/c/Program Files (x86)/dotnet"
        "$PROGRAMFILES/dotnet"
        "$PROGRAMFILES (x86)/dotnet"
    )
    
    DOTNET_FOUND=0
    for BASE_PATH in "${DOTNET_WINDOWS_PATHS[@]}"; do
        if [ -d "$BASE_PATH" ] && [ -f "$BASE_PATH/dotnet.exe" ]; then
            echo "Found .NET at: $BASE_PATH"
            export PATH="$BASE_PATH:$PATH"
            DOTNET_FOUND=1
            break
        fi
    done
    
    if [ $DOTNET_FOUND -eq 0 ]; then
        echo "ERROR: .NET SDK not found. Please install it."
        echo "You can download .NET SDK from: https://dotnet.microsoft.com/download"
        exit 1
    fi
fi

echo "Verifying Java and .NET versions..."
java -version
dotnet --version

# C# part - flashing colored text
echo "Preparing C# code..."
mkdir -p CSharpFlashingApp
cat > CSharpFlashingApp/Program.cs << 'EOL'
// [C# code stays the same as in Italian script]
EOL

# Java part - generates random data for C#
echo "Preparing Java code..."
cat > HelloJava.java << 'EOL'
// [Java code stays the same as in Italian script]
EOL

# Compile and run Java
echo -e "\n=== Running Java ==="
javac HelloJava.java
if [ $? -ne 0 ]; then
    echo "ERROR compiling Java code."
    exit 1
fi

java HelloJava
if [ $? -ne 0 ]; then
    echo "ERROR running Java program."
    exit 1
fi

# Compile and run C#
echo -e "\n=== Running C# ==="
cd CSharpFlashingApp
dotnet new console --force --no-restore
if [ $? -ne 0 ]; then
    echo "ERROR creating C# project."
    exit 1
fi

dotnet build
if [ $? -ne 0 ]; then
    echo "ERROR building C# project."
    exit 1
fi

echo "Starting C# flashing program..."
dotnet run

cd $WORKING_DIR
echo -e "\n=== Demonstration completed! ==="
