module CCO.HM.PrintUtils (
      (>||<)
    , ppSource, ppPos, ppSourcePos
    , quote
    , ppUse
) where

import CCO.HM.AG.BaseHelpers
import CCO.Printing
import CCO.SourcePos

infixr 3 >||<
-- | Combine two documents side-by-side with a space between them.
--
-- If either document is empty, simply return the other one.
(>||<) :: Doc -> Doc -> Doc
x >||< y | isEmpty x || isEmpty y = x >|< y
         | otherwise = x >|< space >|< y

-- | Pretty-print a source file name.
ppSource :: Source -> Doc
ppSource (File path) = text path
ppSource Stdin = text "<stdin>"

-- | Pretty-print a position.
ppPos :: Pos -> Doc
ppPos (Pos l c) = pp l >|< colon >|< pp c
ppPos EOF = text "<EOF>"

-- | Pretty print a source-position combination.
ppSourcePos :: SourcePos -> Doc
ppSourcePos (SourcePos s p) = ppSource s >|< colon >|< ppPos p

-- | A single quote character.
quote :: Doc
quote = text "'"

-- | Pretty print an invalid use of a variable.
ppUse :: (Var, SourcePos) -> Doc
ppUse (x, pos) = ppSourcePos pos >|< colon >||< text "Not in scope:" >||< enclose quote quote (text x)
