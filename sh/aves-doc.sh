#!/bin/bash

# Create base directories
mkdir -p aves-documentation/{hardware-manual,software-manual}

# Function to create common directory structure
create_front_matter() {
    local base_dir=$1
    mkdir -p "$base_dir/front-matter"
    
    # Create front matter files
    touch "$base_dir/front-matter/"{book-info,title-page,abstract,foreword,contents,preface}.adoc
}

create_back_matter() {
    local base_dir=$1
    mkdir -p "$base_dir/back-matter"
    
    # Create back matter files
    touch "$base_dir/back-matter/"{appendices,glossary,index}.adoc
}

# Hardware Manual Structure
HW_BASE="aves-documentation/hardware-manual"
create_front_matter "$HW_BASE"

# Create hardware parts directories and files
mkdir -p "$HW_BASE/parts/"{part1-architecture,part2-components,part3-video}

# Part 1 - Architecture
touch "$HW_BASE/parts/part1-architecture/"{chapter1-intro,chapter2-overview,chapter3-design,chapter4-computational-models,chapter5-system-configurations}.adoc

# Part 2 - Components
touch "$HW_BASE/parts/part2-components/"{chapter1-overview,chapter2-modules,chapter3-interfaces,chapter4-specifications}.adoc

create_back_matter "$HW_BASE"
touch "$HW_BASE/hardware-manual.adoc"

# Software Manual Structure
SW_BASE="aves-documentation/software-manual"
create_front_matter "$SW_BASE"

# Create software parts directories
mkdir -p "$SW_BASE/parts/"{part1-getting-started,part2-fundamentals,part3-architecture,part4-runtime,part5-development,part6-reference}

# Part 1 - Getting Started
touch "$SW_BASE/parts/part1-getting-started/"{chapter1-introduction,chapter2-quick-start,chapter3-basic-concepts}.adoc

# Part 2 - Fundamentals
touch "$SW_BASE/parts/part2-fundamentals/"{chapter1-architecture-overview,chapter2-core-concepts,chapter3-basic-operations}.adoc

# Part 3 - Architecture
touch "$SW_BASE/parts/part3-architecture/"{chapter1-system-architecture,chapter2-hardware-model-support,chapter3-implementation}.adoc

# Part 4 - Runtime
touch "$SW_BASE/parts/part4-runtime/"{chapter1-execution-model,chapter2-memory-management,chapter3-io-subsystem}.adoc

# Part 5 - Development
touch "$SW_BASE/parts/part5-development/"{chapter1-development-environment,chapter2-programming-guide,chapter3-debugging}.adoc

# Part 6 - Reference
touch "$SW_BASE/parts/part6-reference/"{chapter1-api-reference,chapter2-system-calls,chapter3-hardware-interfaces}.adoc

create_back_matter "$SW_BASE"
touch "$SW_BASE/software-manual.adoc"

echo "Directory structure created successfully!"

# Optional: Set appropriate permissions
find aves-documentation -type d -exec chmod 755 {} \;
find aves-documentation -type f -exec chmod 644 {} \;
