homebrew-tools
==============

CSDMS models and tools formulae for the Homebrew package manager
http://brew.sh.

To install Homebrew,

    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

How do I install these formulae?
--------------------------------
Just `brew tap csdms/tools` and then `brew install <formula>`.

If the formula conflicts with one from mxcl/master or another tap, you can `brew install csdms/tools/<formula>`.

You can also install via URL:

    brew install https://raw.github.com/csdms/homebrew-tools/master/<formula>.rb

Docs
----
`brew help`, `man brew`, or the Homebrew [wiki][].

[wiki]:http://wiki.github.com/mxcl/homebrew
