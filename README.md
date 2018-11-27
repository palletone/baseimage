# Baseimage Introduction

This directory contains the infrastructure for creating a new baseimage used as the basis for various docker images consumed within the palletone workflow such as chaincode compilation/execution, unit-testing, and even cluster simulation. It is based on centos:7.5.1804 with various opensource projects added such as golang, java, and node.js. The actual palletone code is injected just-in-time before deployment. The resulting images are published to image registries such as [hub.docker.com][palletone-baseimage].

The purpose of this baseimage is to act as a bridge between a raw centos:7.5.1804 configuration and the customizations required for supporting a palletone environment. Some of the components that need to be added to centos do not have convenient native packages. Therefore, they are built from source. However, the build process is generally expensive (often taking in excess of 5 minutes) so it is fairly inefficient to JIT assemble these components on demand.

Therefore, the expensive components are built into this baseimage once and subsequently cached on the public repositories so that workflows may simply consume the objects without requiring a local build cycle.

# Intended Audience

This repository is only intended for release managers curating the base images. Typical developers may safely ignore this completely. Anyone wishing to customize their image is encouraged to do so via downstream means, such as a custom Dockerfile.

## Exceptions

If a component is found to be both broadly applicable and expensive to build JIT, it may be a candidate for inclusion in a future baseimage.

# Usage

* "make docker" will build the docker images and commit it to your local environment; e.g. "palletone/pallet-baseimage". The docker image is also tagged with architecture and release details.
* "make install" build build the docker images and push them to Docker Hub.
