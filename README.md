# garret

Simple CLI to convert your bookmarks to organized and readable markdown.

## Installation

Build with [Crystal](https://crystal-lang.org):

```bash
$ crystal build src/garret.cr
```


## Usage

```
garret
    --file-path PATH                 Path of bookmarks file.
    -i PATH, --ignored PATH          Path of patterns to ignore.
    -o PATH, --output-path PATH      Path to store markdown output. Default: attic.md
    -h, --help                       Show help
```

The ignored file should look like this:

```
Folders:
School
ComputerScience/
--
URLS:
wikipedia
google.com
khanacademy
```

This file will then be parsed and if a url / folder of bookmarks matches the pattern, it won't be in the output.

## Contributing

1. Fork it (https://github.com/Uzay-G/garret/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Uzay-G](https://github.com/Uzay-G) - creator and maintainer
