#
#   Todo-extraction utility
#
#   ---------------------------------------------------------------------
#
#   Copyright (C) 2023 Paul Clayberg
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#    
#   ---------------------------------------------------------------------
#



from os import path
import subprocess
from sys import stdout



# Setup
filepath = "./*.lua ./lib/*.lua"
patterns = ["TODO", "FIXME"]
cmd = "grep -n {} {}"
filehead = "# Todo List\n\n\n\n"
subhead = "### {}\n"
outpath = "./TODO.md"
outfmt = "* {} [{}]({}#L{}):{}\n"
note = "_NOTE: This file should be auto-generated using `todo.py`_  \n"



if __name__ == "__main__":

    out = [filehead, note]
    success = False

    # Iterate through patterns and list of matches
    for pattern in patterns:

        # Configure grep
        _cmd = cmd.format(pattern, filepath)
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
                out.append(outfmt.format(pattern, f, f, l, c))
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



