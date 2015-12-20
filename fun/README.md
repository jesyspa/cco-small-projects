# Project E: A Functional (Lazy) Language Implementation

By Anton Golov (3809277) and Giovanni Garufi (5685109).

We have implemented a compiler as described in [CCO Mini-Project E][0],
satisfying all four points.  Additionally, to demonstrate the modularity of the
design, we have implemented a self-contained tail call annotation
transformation.

A full description of our design can be found in `design.pdf`.

 [0]: http://foswiki.cs.uu.nl/foswiki/pub/Cco/MiniProjects/cco-project-e.pdf

## Build & Run Instructions

We have used the `uuagc-cabal` package to make compiling the UUAG files part of
the cabal build process.  Simply run

    cabal sandbox init
    cabal install --dependencies-only
    cabal configure
    cabal build

You can then run the executables in the `dist` directory, as with any cabal
package.  In order to decrease compile times, we set a very high limit on the
horizontal space used by the pretty-printed ATerms that `parse-hm` and `hm2cr`
produce.  If you want a more human-readable presentation, pass the `-p` flag.

We have provided a number of tests that can be run with

    ./run_tests.sh

Examples, together with their expected output, can be found in the `tests`
directory.  The `.lam` files are example Hindley-Milner terms and the `.exp`
files are the corresponding expected output.

Note that tests with names beginning in `fail-` are expected to fail.
