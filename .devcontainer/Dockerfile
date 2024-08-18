FROM ruby

RUN apt-get update
RUN apt-get install ruby-full
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN brew install dart fvm nvm pyenv openjdk ruff
