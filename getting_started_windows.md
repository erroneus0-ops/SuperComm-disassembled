# Getting the Project Running on Windows

## What You Need

1. **Git for Windows** — to clone and sync the repository
2. **Python 3** — to run the disassembler and tools
3. **Notepad++** — you already have this

That's it. No compiler, no IDE, no special development environment.

---

## Step 1: Install Git for Windows

Download from: https://git-scm.com/download/win

Run the installer. The defaults are fine for everything except one option:
when asked about the default editor, you can change it to Notepad++ if you like,
but it doesn't matter for our purposes.

After installation, open a Command Prompt and type:

    git --version

You should see something like `git version 2.x.x`. If so, Git is working.

---

## Step 2: Install Python 3

Download from: https://www.python.org/downloads/

Run the installer. **Important:** on the first screen, check the box that says
**"Add Python to PATH"** before clicking Install. If you miss this, Python won't
be accessible from the command prompt.

After installation, open a Command Prompt and type:

    python --version

You should see `Python 3.x.x`. If so, Python is working.

---

## Step 3: Clone the Repository

Open a Command Prompt and navigate to where you want the project to live.
For example, if you want it at C:\DATA\supercomm:

    cd C:\DATA
    git clone https://github.com/erroneus0-ops/SuperComm-disassembled.git supercomm

This creates a supercomm folder with everything in it.

---

## Step 4: Verify the Tools Work

Navigate into the project folder:

    cd C:\DATA\supercomm

Run the disassembler on the dir binary:

    python dis6x09.py --proj dir_proj.json -n

You should see:

    ; Pass 1: 93 labels  (85 code  8 data in code section)
    Written: dir_proj.dasm  (xxx lines)

Run the markup tool:

    python markup.py dir_proj.dasm dir_proj.json

You should see a summary of changes applied.

If both work, the project is fully set up.

---

## Step 5: Set Up Notepad++

Open Notepad++ and configure .dasm files to use ASM syntax:

1. Go to Settings > Style Configurator
2. Find ASM in the language list
3. In the User ext. field at the bottom, add: dasm
4. Click Save & Close

Now .dasm files will have assembly language syntax highlighting.

---

## Step 6: Set Up the Run Commands in Notepad++

These let you run the disassembler and markup tool on the current file
with a single click from the Run menu.

Go to Run > Run... and enter each command below, then click Save
and give it the name shown.

**Markup Pass** — applies your markup annotations to the JSON:

    cmd /c cd /d $(CURRENT_DIRECTORY) && python markup.py $(NAME_PART).dasm $(NAME_PART).json

**Disasm Pass** — regenerates the .dasm listing from the JSON:

    cmd /c cd /d $(CURRENT_DIRECTORY) && python dis6x09.py --proj $(NAME_PART).json -n --markup

Save each with its name. They will appear at the bottom of the Run menu.

To use them: open the .dasm file for the project you are working on,
then click Run > Markup Pass or Run > Disasm Pass.

---

## Daily Workflow

### Pulling updates from GitHub

    cd C:\DATA\supercomm
    git pull

Do this at the start of each session to get any changes that were made
(including changes made during our Claude sessions).

### Pushing your changes to GitHub

    cd C:\DATA\supercomm
    git add -A
    git commit -m "brief description of what you did"
    git push

---

## The Key Files

    dis6x09.py              the disassembler
    markup.py               applies analyst annotations to the JSON
    prepasm.py              strips .dasm to assembleable .asm
    asm6809.py              assembles and validates

    dir_proj.json           dir binary project settings and annotations
    dir_proj.dasm           disassembly listing (edit annotations here)

    supercomm22.json        SuperComm project
    supercomm22_proj.dasm

    documentation/
      book/
        ch01_humble_beginnings/
          HELLO_book.ASM    the numbered book listing
          HELLO.BAS         BASIC loader
          HELLO.DSK         CoCo disk image
          ch01_draft.md     chapter 1 first draft

---

## If Something Goes Wrong

**Python not found:** make sure you checked "Add Python to PATH" during install.
Open a new Command Prompt after installing -- the old one won't see the new PATH.

**Git not found:** same issue -- open a new Command Prompt after installing Git.

**Permission errors on git pull:** you may need to set up a GitHub personal
access token. Go to GitHub > Settings > Developer Settings > Personal Access
Tokens > Generate new token. Use that token as your password when Git asks.

**The .dasm file looks wrong after a disasm pass:** check that the .json file
has a "binary" field pointing to the correct binary file in the same directory.
