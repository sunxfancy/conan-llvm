#!/bin/bash

set -e
set -x

if [[ "$(uname -s)" == 'Darwin' ]]; then
    brew update || brew update
    brew outdated pyenv || brew upgrade pyenv
    brew install pyenv-virtualenv
    brew install cmake || true

    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
    fi

    pyenv install 3.5.2
    pyenv virtualenv 3.5.2 conan
    pyenv rehash
    pyenv activate conan
fi

pip3 install conan==1.10.0 conan_package_tools==0.21.1 # It install conan too
conan user
