# Design Description Document

In this document, we present and motivate the design of our compiler.  The first
part of the document describes the syntax and semantics of the source language,
as they concern the user.  The second part gives an overview of our internal
representation and makes some notes on the transformations involved.  We end on
a number of things that could still be improved.

## Syntax

We have kept the syntax as close to the original as possible.  The following
changes are noteworthy:

* We have extended the language with a `prim` keyword, which must be followed by
  quoted identifier, followed by any number of variables.
* We have extended the language with the keywords `if`, `then`, `else` and `fi`.
  These must be used in the form `if t1 then t2 else t3 fi`, where `t1`, `t2`,
  and `t3` stand for terms.  `t1` must evaluate to a `Bool`.
* The following built-in symbols have been defined: `False`, `True`, `Cons`,
  `Nil`, `isNil`, `head`, `tail`.

Note that we have chosen to capitalise `Cons` and `Nil` to remain consistent
with Haskell's notation for constructors.

## Semantics

The syntactic extensions described above have the following semantics:

* `prim "foo" x y ...` will invoke the primitive operation `foo` with the tuple
  of arguments `x y ...`.  In practice, since all the primitive operations we
  have access to are binary, we can assume that this tuple is a pair.
* `if t1 then t2 else t3 fi` evaluates `t1`.  Assuming the result is a `Bool`,
  `t2` is executed if it is true and `t3` if it is false.
* `True` and `False` are constants of type `Bool`.
* `Cons` and `Nil` are used to construct lists.  They work as they typically do
  in a LISP, with `head` being `car` and `tail` being `cdr`.
* When applied to an object produced by a fully-saturated call to `Cons`, or to
  a `Nil` object, `isNil` is true iff it is applied to a `Nil` object.

Apart from that, we have given our language lazy semantics (as required by the
assignment).

## Internal Representation

We have slightly modified the Hindley-Milner and Core representations provided
with the assignment, and introduced our own BNormal form.

### Hindley-Milner Terms

We have extended the Hindley-Milner term type to have a constructor for
primitive operations and for if statements.  This was a necessary consequence of
our extension of the syntax.

Additionally, we have introduced a `Root` type to represent rooted terms.  This
type is thoroughly uninteresting, except in that it allows us to specify
special top-level UUAG computations that are performed before or after a
computation on the rest of the tree.  This considerably simplifies the code
using the UUAG transformations.

### Binding Normal Form

As an intermediate representation we use Binding-Normal forms.  These satisfy
the properties:

* Every application is of a variable onto a variable.
* Every branch is on a variable.
* Bindings occur only at the top level, immediately under a lambda, or
  immediately in an if branch.  (Hence the name.)
* All if statements occur in tail position.
* (Immediate consequence of the above:) All bindings occur in tail position.

Note that by the first two points, every BNormal form is automatically an
ANormal form.  This is a much stronger translation than truly necessary, but it
is convenient.

The BNormal datatypes also allow for explicit annotation of laziness, forcing,
and tail calls.

### Core

The Core language has been left largely unchanged, except that annotations have
been added for tail calls and forcing, as well as references to tags and fields.

### Runtime Representation

At runtime, we use Core nodes to represent booleans and lists.

A `Bool` is simply any node with a tag of `0` or `1`, where `0` indicates
falsehood and `1` indicates truth.  The `True` and `False` constants are nullary
nodes that satisfy these properties.

A list is either a two-element cell with a tag of `0` or a nullary cell with a
tag of `1`.  The `Cons` and `Nil` constants construct these.

Note that by these definitions, a list is necessarily a `Bool`, since we do not
require that a `Bool` be a nullary node.  We abuse this fact to implement
`isNil` as the identity function.

## Transformations

The following transformations are performed.  Parsing and conversion to CoreRun
are split into separate executables, while the steps between are all performed
by `hm2cr`.

### Parsing

We use the algorithm as it has been provided, with cases added for primitive
operations and branching.  This is all bog-standard and so shall not be delved
into.

### Sanitization

This step detects uses of undefined variables, and at once also renames all
variables.  This solves, in a somewhat heavy-handed way, the shadowing problem.

There are, at the moment, no other static requirements imposed on the code.
Hence, if the sanitization step completes without errors, the code will be
successfully compiled (unless the compiler is buggy).

### BNormal Conversion

Terms are converted to BNormal form.  A rooted term is converted to a rooted
BNormal term; otherwise, the conversion may yield either a term or an
expression, together with some bindings that must still be applied.

The basic idea is that we generate a list of bindings produced by a term,
extending it whenever we need to split out a subterm.  These bindings bubble up
until we reach a point where a term in BNormal form may have bindings, after
which we place them there.

### Addition of Builtins

### Laziness Introduction

### Tail Call Annotation

### Core Conversion

### Core to CoreRun conversion

## Possible future improvements
