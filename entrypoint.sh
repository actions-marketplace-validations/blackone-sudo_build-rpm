#!/bin/sh -l

set -x

# Step: 1
# Install rpmbuild

yum install -y rpm-build

# Step: 2
# Create rpmbuild folders in your home directory

mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

# Step: 3
# Download the source file
#
# Source files are usually available in tar.gz or tar.bz2 format. Create a src folder
# in your home directory to store your files, download the file, uncompress it and
# move the compressed file to the rpm build SOURCES directory

mkdir -p ~/src && cd ~/src

# Get the pre-built dependencies (all static libraries)
aws s3 cp s3://opendap.travis.build/hyrax-dependencies-$os-static.tar.gz 

# This dumps the dependencies in current directory (we are in ~/src)
tar -xzvf hyrax-dependencies-$os-static.tar.gz

# move the compressed file to the rpm build SOURCES directory
mv hyrax-dependencies-$os-static.tar.gz ~/rpmbuild/SOURCES

# Step: 4
# Locate .spec file and build rpm
#
# If you get any errors during build, it is usually because of dependencies. Simply
# install the dependencies with `yum install [dependency]` and run rpmbuild again.

cd ~/src hyrax-dependencies-$os-static && ls | grep *.spec 
rpmbuild -ba make git.spec