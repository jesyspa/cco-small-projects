module CCO.Diag.TypeError (
      TypeError(..)
    , TypeErrorAnn(..)
) where

import CCO.SourcePos
import CCO.Printing

data TypeError = CompilerMismatch String String
               | ExecutionMismatch String String
               | CannotCompile
               | CannotBeCompiled
               | CannotRun
               | CannotBeRun
               deriving (Eq, Read, Show)

data TypeErrorAnn = TypeErrorAnn SourcePos TypeError
                  deriving (Eq, Read, Show)

-- beside with space
infixr 3 >||<
(>||<) :: Doc -> Doc -> Doc
x >||< y | isEmpty x || isEmpty y = x >|< y
         | otherwise = x >|< space >|< y

ppError :: TypeError -> Doc
ppError (CompilerMismatch x y) = text "Cannot compile a program/interpreter in" >||< text x >||< text "with a compiler for" >||< text y
ppError (ExecutionMismatch  x y) = text "Cannot run a program/interpreter/compiler in" >||< text x >||< text "on a platform/interpreter for" >||< text y
ppError CannotCompile = text "This block cannot be used to compile"
ppError CannotBeCompiled = text "This block cannot be compiled"
ppError CannotRun = text "This block cannot be used to run another block"
ppError CannotBeRun = text "This block cannot be run"

ppSource :: Source -> Doc
ppSource (File path) = text path
ppSource Stdin = text "<stdin>"

ppPos :: Pos -> Doc
ppPos (Pos l c) = pp l >|< colon >|< pp c

ppSourcePos :: SourcePos -> Doc
ppSourcePos (SourcePos s p) = ppSource s >|< colon >|< ppPos p

ppErrorAnn :: TypeErrorAnn -> Doc
ppErrorAnn (TypeErrorAnn pos err) = ppSourcePos pos >|< colon >||< ppError err

instance Printable TypeError where
    pp = ppError

instance Printable TypeErrorAnn where
    pp = ppErrorAnn
