#!/usr/bin/env python3

import re
import sys

def pad_to_width(line: bytes, width: int) -> str:
    output_line = b''
    idx = 0
    buffer = b''
    while idx < len(line):
        if width == 0:
            break
        if (match := re.match(rb'((?:\x1b\[[\d;]*\w)|[ -~])', line[idx:])):
            span = match.span()
            buffer += line[idx + span[0]:idx + span[1]]
            idx += span[1]
            if span[1] == 1:
                width -= 1
                output_line += buffer
                buffer = b''
        else:
            idx += 1
    output_line += b'\033[m'
    return output_line.decode('utf-8')

def main() -> int:
    width = int(sys.argv[1])
    lines = open(0, 'rb').read().strip(b'\n').split(b'\n')
    for line in lines:
        try:
            print(pad_to_width(line, width), file=sys.stdout, flush=True)
        except Exception as error:
            print('There was an error printing the line', file=sys.stderr, flush=True)
            print(str(error), file=sys.stderr, flush=True)
            return 1
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
