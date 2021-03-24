# C/C++ SAST
C/C++ SAST (Static Application Security Testing) via [Flawfinder](https://dwheeler.com/flawfinder/)

GitHub action examines C/C++ source code and reports possible security weaknesses (“flaws”) sorted by risk level.

# How it Works

Flawfinder works by using a built-in database of C/C++ functions with well-known problems, such as buffer overflow risks (e.g., strcpy(), strcat(), gets(), sprintf(), and the scanf() family), format string problems ([v][f]printf(), [v]snprintf(), and syslog()), race conditions (such as access(), chown(), chgrp(), chmod(), tmpfile(), tmpnam(), tempnam(), and mktemp()), potential shell metacharacter dangers (most of the exec() family, system(), popen()), and poor random number acquisition (such as random()). The good thing is that you don’t have to create this database - it comes with the tool.

Not every hit is actually a security vulnerability, and not every security vulnerability is necessarily found.

## Note

Flawfinder is fundamentally a naive program; it doesn’t even know about the data types of function parameters, and it certainly **doesn’t do control flow or data flow analysis**.

## How to mark flaw as reviewed

Add comment to source code /\* Flawfinder ignore \*/ at a previous line or at the end-of-a-line

```
   char tmp[256]; /* Flawfinder: ignore */
   strcpy(tmp, pScreenSize); /* Flawfinder: ignore */
```

# How to use

To use this GitHub Action you will need to complete the following:

1. Create a new file in your repository called .github/workflows/sast.yml
2. Copy the example workflow from below into that new file, no extra configuration required
3. Commit a change OR open up a Pull Request and observe the action working
4. Should any flaw found, action will add comment to commit with analysis result 

## Example connecting GitHub Action Workflow
In your repository you should have a .github/workflows folder with GitHub Action similar to below:

.github/workflows/sast.yml
This file should have the following code:

```
---
########################
########################
## SAST GitHub Action ##
########################
########################
name: SAST

#######################################
# Start the job on all push to master #
#######################################
on:
  push:
  pull_request:
    branches: ['master']

###############
# Set the Job #
###############
jobs:
  build:
    # Name the Job
    name: SAST

    # Set the agent to run on
    runs-on: ubuntu-latest

    ##################
    # Load all steps #
    ##################
    steps:
      ##########################
      # Checkout the code base #
      ##########################
      - name: Checkout Code
        uses: actions/checkout@v2

      #####################
      # Run Deploy script #
      #####################
      - name: Run SAST check
        uses: IvanKuchin/SAST@v1
        with:
          GITHUB_TOKEN: ${{ github.token }}
        env:
          LOG_VERBOSE: true

```
