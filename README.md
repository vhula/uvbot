# uvbot

## Setup

### Cobra CLI Installation

```bash
go install github.com/spf13/cobra-cli@latest
```

## History

```bash
go install github.com/spf13/cobra-cli@latest && \
go mod init github.com/vhula/uvbot && \
cobra-cli init && \
cobra-cli add version && \
go get gopkg.in/telebot.v3
```

```bash
read -s TELE_TOKEN
export TELE_TOKEN
```

Github Container Registry Setup
```bash
export CR_PAT=...
echo $CR_PAT | docker login ghcr.io -u vhula --password-stdin
```
