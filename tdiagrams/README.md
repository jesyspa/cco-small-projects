#Type System
The type system we decided to implement can be defined as a *structural type system* (also called property-based type system).

In this typing model notions of compatibility and equivalence are derived by the structure and permitted operations of a type rather than other characteristics such as it's name or place of declaration.

##Attributes
In our case the type of a diagram is completely determined by three synthesized attributes: **canRun**, **canRunOn** and **canCompile**

Internally these attributes are represented as follows:

    canRunOn :: Maybe String
    canRun :: Maybe String
    canCompile :: Maybe (String, String)

Intuitively *canRunOn* specifies the implementation a diagram can run on. For example, given the simple diagram

> Program *hello* in **haskell**

the value of *canRunOn* is **Just "haskell"**

On the other hand, *canRun* specifies the implementation a diagram can run. The simplest example is a Platform:

> Platform **x86**

The value of *canRun* for the diagram above would simply be **Just "x86"**

Finally the *canCompile* attribute consits of a (maybe) pair of strings, these represent the source and target implementations of a compiler.

> Compiler *t-diag* from **tdg** to **latex** in **haskell**

For this compiler the value of *canCompile* is **Just ("tdg", "latex")**, of course a diagram can have actual values for different attributes at the same time.
For example. the compiler above also has *canRun* equal to **Just "haskell"**

The specification of these attributes for simple diagrams is pretty straightforward, the interesting cases involve composite diagrams (*Execute* and *Compile* blocks).

For composite blocks the value of the attributes is derived from the values of the attributes for their children (remember the attributes are synthesized).

    sem Diag_
      ...
      | Execute       lhs.canRun = @d1.canRun
      | Compile       lhs.canRun = @d1.canRun

The block of code above shows how the canRun attribute is derived for composite blocks. Intuitively Execute and Compile diagrams inherit the canRun attribute from whatever is being run or compiled.

The canRunOn attribute is only slightly more involved:

    sem Diag_
       ...
       | Execute      lhs.canRunOn = @d2.canRunOn
       | Compile      lhs.canRunOn = snd <$> @d2.canCompile

Both diagrams inherit the attribute from their second component.
An Execute diagram inherits the attribute from the the diagram the execution is **targeting** (a Platform, Interpreter, ecc) while the Compile diagram inherits the attribute from the **target** language of it's second component (remember that canCompile is a maybe pair of strings which can be thought respectively as *source* and *target*)

The last attribute is canCompile

     sem Diag_
      ...
      | Execute       lhs.canCompile = @d1.canCompile
      | Compile       lhs.canCompile = @d1.canCompile

Both diagrams inherit the attribute from their first component.

##Composition
Finally, the actual type-checking is done when connecting diagrams via composite blocks. The following code has been slightly simplified for ease of exposition:

    sem Diag_
      | Execute       lhs.error = connect @d1.canRunOn @d2.canRun
      | Compile       lhs.error = connect @d1.canRunOn (fst <$> @d2.canCompile)

Error is a synthesized attribute which consists of a possibly empty list of TypeErrors. The connect function simply checks that the passed attributes are consistent with each other and produces an appropriate error message if this is not the case.

For an **Execute** diagram we check that the value of *canRunOn* for the first component equals the value of *canRun* for the second.
In the **Compile** diagram we check that the value of *canRunOn* for the first component matches the first element of the *canCompile*
tuple of the second component.

#Expressiveness

As can be seen from the examples, composite blocks inherit the attributes from their children.
This means that composite blocks are allowed to be composed too as long as everything lines up.

For example the following program is perfectly valid:

    compile
        compile
            program Hello in Haskell
        with
            compiler GHC from Haskell to LLVM in Haskell
        end
    with
        compiler LLVM from LLVM to x86 in C++
    end

and this one too

    compile
      compile
          execute
              program tc-tdiag in Haskell
          on
              interpreter GHCi for Haskell in Haskell
          end
      with
          compiler GHC from Haskell to x86 in Haskell
      end
    with
      compiler reverseGHC from x86 to Haskell in x86
    end

#UUAG Usage

We deviated somewhat from the way UUAG was used in the project template.  Rather than having a single AG file that is compiled and includes the rest, we have split data definitions from semantic functions, allowing multiple functions to be defined on the same data.  This does, unfortunately, involve creating a lot of helper modules, since we cannot define any (UUAG-level) data or type synonyms in the modules where we define the semantic functions.  Furthermore, we cannot define anything on the Haskell level in the modules where we define data, as these would otherwise be defined twice.

We did not manage to formulate the transformation from a diagram to a picture as a single catamorphism.  When compiling a **Compile** diagram, we have to duplicate the program that is being compiled.  However, if the program being compiled is already the output of the compiler, we should not also duplicate the compiler.  This requires us to generate the code for the program-without-compiler twice, which is done by invoking the transformation again on a subtree.  This is highly inefficient, since we end up duplicating work, but the alternative would be duplicating most attributes, which is not very satisfactory from a readability standpoint.  Still, if the user wishes to show long chains of compilations then this approach is highly suboptimal.

