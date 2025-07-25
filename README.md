# mac_lookup
A Zsh script to look up MacBook model names from serial numbers.

## Usage
```console
% zsh -f <(curl -sSL https://raw.githubusercontent.com/leah-sc/mac_lookup/refs/heads/main/mac_lookup.zsh)
```
The script will read serial numbers from standard input, and output model names to standard output.
Any errors will be printed to STDERR and print a blank line, such the total amount of input lines and output lines stays the same.
