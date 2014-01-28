# Maclight - control your Mac's screen and keyboard light from linux

Maclight is both a command line utility and a haskell library for controlling
your Mac's screen and keyboard backlights from the command line. Installation
on Debian-esque systems is typically something like:

    sudo apt-get install cabal-install
    cabal update
    git clone https://github.com/tych0/maclight
    cd maclight
    cabal install --only-dependencies
    sudo make install

The `maclight` binary is installed suid because the files used to control the
lights are only accessable by root. However, the source is small, so hopefully
(:D) there are no local root vulns.
