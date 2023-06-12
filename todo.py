#
#   To-Do List Automation Utility
#
#   -------------------------------------------------------------------------------
#
#   This code is licensed under the Free Software Foundation (FSF) License.
#   
#   Copyright (c) 2023 Paul Clayberg
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#   THE SOFTWARE.
#
#   Except as contained in this notice, the name(s) of the above copyright holders
#   shall not be used in advertising or otherwise to promote the sale, use or other
#   dealings in this Software without prior written authorization.
#
#   --------------------------------------------------------------------------------
#



#
#   NOTE Edit these variables to customize the program's output --------------------
#
files = [
    "*.lua",
    "lib/*.lua",
]
patterns = [
    "TODO", 
    "FIXME",
]
header = "# Todo List\n"
outpath = "./TODO.md"
#
#   --------------------------------------------------------------------------------
#



from os import path
import subprocess
from sys import stdout



if __name__ == "__main__":

    subhead = "### {}\n"
    outfmt = "* [{}:{}]({}#L{}):{}\n"
    note = "_NOTE: This file was auto-generated using [todo.py](http://github.com/paulpls/todo)_\n\n\n\n"
    cmd = "grep -n {} {}"
    out = [header, note]
    success = False

    # Iterate through patterns and list of matches
    for pattern in patterns:

        # Configure grep
        _cmd = cmd.format(pattern, " ".join(files))
        grep = subprocess.run(_cmd, shell=True, capture_output=True)

        # Decode output using system stdout's encoding
        if grep.returncode == 0:
            grep = [str(b, stdout.encoding) for b in grep.stdout.split(b"\n")]
        else:
            grep = []

        if grep:
            # Add subheader to output
            out.append(subhead.format(pattern))
            # Iterate through matches
            for m in grep: 
                # Skip any blanks that appear
                if not m:
                    continue
                # Split the string into filename, line number, and contents
                s = m.split(":")
                f = s[0]
                l = s[1]
                c = s[-1].split(pattern)[-1]
                # Add to output using the provided format
                out.append(outfmt.format(f, l, f, l, c))
                success = True
            # Add some whitespace after matches
            out.append("\n\n\n")
    
    # Check for differences
    if path.exists(outpath):
        with open(outpath, "r") as f:
            lines = f.readlines()
            try:
                same = [out[ln] == lines[ln] for ln in range(len(out))]
            except IndexError as e:
                same = [False]
        # Remove old file if there are differences, or print a message to stdout
        if not all(same):
            rm = subprocess.run(f"rm {outpath}", shell=True, capture_output=True)
            success = rm.returncode == 0
        else:
            print("TODO files are the same; no changes to write.")
    
    # Write to new file if successful
    if success:
        with open(outpath, "w") as f:
            f.writelines(out)



