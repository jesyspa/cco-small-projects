module CCO.HM.PrintUtils (
      (>||<)
    , ppSource, ppPos, ppSourcePos
    , quote
    , ppUse
) where

import CCO.HM.AG.BaseHelpers
import CCO.Printing
import CCO.SourcePos

-- beside with space
infixr 3 >||<
(>||<) :: Doc -> Doc -> Doc
x >||< y | isEmpty x || isEmpty y = x >|< y
         | otherwise = x >|< space >|< y

ppSource :: Source -> Doc
ppSource (File path) = text path
ppSource Stdin = text "<stdin>"

ppPos :: Pos -> Doc
ppPos (Pos l c) = pp l >|< colon >|< pp c

ppSourcePos :: SourcePos -> Doc
ppSourcePos (SourcePos s p) = ppSource s >|< colon >|< ppPos p

quote :: Doc
quote = text "'"

ppUse :: (Var, SourcePos) -> Doc
ppUse (x, pos) = ppSourcePos pos >|< colon >||< text "Not in scope:" >||< enclose quote quote (text x)
