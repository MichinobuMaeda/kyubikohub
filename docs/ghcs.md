# 開発手順: GitHub Codespaces

[目次](index.md) に戻る

## 必要なもの

- gh <https://docs.github.com/ja/github-cli/github-cli/about-github-cli>

## 初期構築

VS Code のターミナルで

```bash
mkdir ~/.nvm
```

Codespaces の構築ログに出力された内容を Codespaces の `~/.bashrc` に追加す

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
```

VS Code のターミナルを開き直す

```bash
nvm install
fvm use
pyenv install
pyenv init
```

Codespaces の `~/.bashrc` に追加

```bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

VS Code のターミナルを開き直す

```bash
fvm flutter --version
node --version
python --version
java --version
npm i
fvm flutter pub get
cd functions
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
```

VS Code のターミナルを開き直す

```bash
npx firebase login
npm run test:ui
npm run test:firestore
npm run test:functions
```

## ローカルのブラウザでテストするための port forwarding

ローカルのコンソールで

```bash
gh auth refresh -h github.com -s codespace
gh cs list
export CODESPACE_NAME=*************
gh cs ports forward 3000:3000 -c $CODESPACE_NAME &
gh cs ports forward 4040:4040 -c $CODESPACE_NAME &
gh cs ports forward 5001:5001 -c $CODESPACE_NAME &
gh cs ports forward 8080:8080 -c $CODESPACE_NAME &
gh cs ports forward 8085:8085 -c $CODESPACE_NAME &
gh cs ports forward 9099:9099 -c $CODESPACE_NAME &
gh cs ports forward 9199:9199 -c $CODESPACE_NAME &
```

VS Code のターミナルで

```bash
npm start
```

アプリ: <http://localhost:3000>

エミュレータ: <http://localhost:4040>
