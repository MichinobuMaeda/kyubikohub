FROM ruby

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew tap leoafarias/fvm && brew install fvm nvm pyenv openjdk ruff
