# Kyubiko Hub

[![codecov](https://codecov.io/gh/MichinobuMaeda/kyubikohub/graph/badge.svg?token=O3k3rP5CPw)](https://codecov.io/gh/MichinobuMaeda/kyubikohub)

## Prerequisites

- nvm
- fvm
- pyenv
- Java >= 11
- curl

## Development

```bash
git clone git@github.com:MichinobuMaeda/kyubikohub.git
cd kyubikohub
npm i
cd functions
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
cd ..
fvm flutter pug get
npm test
npm start
fvm dart run build_runner watch
```

- [Developer's Guide](docs/index.md) (Japanese)
