======================
 NS3 Project Template
======================

This is a template to create simulations based on ns3. The intention is to keep
the ns3 base code separate from the project. This template is using CMake to
handle the dependency to ns3.

Usage
=====

Compile ns3 from Source Tarball
-------------------------------

If you compiled ns3 from the official release download you need to point to
the correct version and directory where the compiled libraries are located::

    cmake .. -DNS3_VERSION=3.26 -DNS3_BUILD_DIR=/path/to/ns3/ns-3.26/build

For this approach I suggest to specify the correct `NS3_VERSION` directly in
the `CMakeLists.txt` instead.

Compile ns3 from the Repository
-------------------------------

If you used the official repository to build ns3 then the version is `3-dev` by
default. If you did not change this it will suffice to point to the build
directory::

    cmake .. -DNS3_BUILD_DIR=/path/to/ns3-repo/build

Precompiled ns3 Installation
----------------------------

If you installed ns3 from your distribution repositories then it should suffice
to specify the correct version::

    cmake .. -DNS3_VERSION=3.22

Options
=======

In the  `CMakeLists.txt` you can specify additional ns3 modules that your project
depends on. See the provided `CMakeLists.txt` for examples. Usually you want to
link your program to all ns3 libraries. The variable `NS3_TARGETS` is a list of all
requested ns3 libraries. Alternatively you can link to individual modules with the
targets `NS3::{name}`, e.g. `NS3::core`, `NS3::wifi`, ...
