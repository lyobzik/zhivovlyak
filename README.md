# zhivovlyak

Zhivovlyak is simple bootstrap for Ubuntu workstation.

## Requirements

For using `install.sh`:
* `curl` or `wget` must be installed,
* `git` will be installed on localhost if missing (and for this `sudo` must be installed).

For using `bootstrap.sh`:
* `ansible` will be installed on localhost if missing (and for this `sudo` must be installed).

## Getting Started

You can checkout this repository and run bootstrap via single command with either `curl` or `wget`:

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/lyobzik/zhivovlyak/master/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/lyobzik/zhivovlyak/master/install.sh -O -)"
```