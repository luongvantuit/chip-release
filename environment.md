# __Environment__

```shell
git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git
```

## __Installing prerequisites Linux__

```shell
sudo apt-get install git gcc g++ python pkg-config libssl-dev libdbus-1-dev \
    libglib2.0-dev libavahi-client-dev ninja-build python3-venv python3-dev \
    python3-pip unzip libgirepository1.0-dev libcairo2-dev
```

## __Installing prerequisites macOS__

```shell
brew install openssl pkg-config
```

Intel

```shell
cd /usr/local/lib/pkgconfig
ln -s ../../Cellar/openssl@1.1/1.1.1g/lib/pkgconfig/* .
```

Apple Silicon 

```shell
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"/opt/homebrew/opt/openssl@3/lib/pkgconfig"
```