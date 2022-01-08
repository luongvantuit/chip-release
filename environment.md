# __Environment__

## Checking out the Matter code

To check out the Matter repository:

```shell
git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git
```

If you already have a checkout, run the following command to sync submodules:

```
git submodule update --init
```

## Prerequisites

### __Installing prerequisites on Linux__

On Debian-based Linux distributions such as Ubuntu, these dependencies can be
satisfied with the following:

```shell
sudo apt-get install git gcc g++ python pkg-config libssl-dev libdbus-1-dev \
    libglib2.0-dev libavahi-client-dev ninja-build python3-venv python3-dev \
    python3-pip unzip libgirepository1.0-dev libcairo2-dev
```

### __Installing prerequisites on macOS__

On macOS, first install Xcode from the Mac App Store. The remaining dependencies
can be installed and satisfied using [Brew](https://brew.sh/):

```shell
brew install openssl pkg-config
```

However, that does not expose the package to `pkg-config`. To fix that, one
needs to run something like the following:

Intel:

```shell
cd /usr/local/lib/pkgconfig
ln -s ../../Cellar/openssl@1.1/1.1.1g/lib/pkgconfig/* .
```

where `openssl@1.1/1.1.1g` may need to be replaced with the actual version of
OpenSSL installed by Brew.

Apple Silicon:

```shell
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"/opt/homebrew/opt/openssl@3/lib/pkgconfig"
```

Note: If using MacPorts, `port install openssl` is sufficient to satisfy this
dependency.

## __Prepare for building__

Before running any other build command, the `scripts/activate.sh` environment
setup script should be sourced at the top level. This script takes care of
downloading GN, ninja, and setting up a Python environment with libraries used
to build and test.

```
source scripts/activate.sh
```

If this script says the environment is out of date, it can be updated by
running:

```
source scripts/bootstrap.sh
```

The `scripts/bootstrap.sh` script re-creates the environment from scratch, which
is expensive, so avoid running it unless the environment is out of date.