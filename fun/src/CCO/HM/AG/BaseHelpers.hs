{-# LANGUAGE FlexibleInstances #-}
module CCO.HM.AG.BaseHelpers (
      Var
) where

import CCO.Printing

type Var = String    -- ^ Type of variables.

-- beside with space
infixr 3 >||<
(>||<) :: Doc -> Doc -> Doc
x >||< y | isEmpty x || isEmpty y = x >|< y
         | otherwise = x >|< space >|< y

quote :: Doc
quote = text "'"

ppVar :: Var -> Doc
ppVar x = text "Not in scope:" >||< enclose quote quote (text x)

instance Printable Var where
  pp = ppVar
