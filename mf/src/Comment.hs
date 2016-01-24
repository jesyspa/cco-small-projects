module Comment (
      Comment(..)
    , Choice(..)
    , Context
    , ppComment
) where

import Text.PrettyPrint

type Context = [(Int, Int)]

data Choice a = Keep a a
              | Update a a a
              | Invalid
              deriving (Eq, Ord, Read, Show)

data Comment a = Done
               | Process (Int, Int) Context (Choice a)
               | Explore (Int, Int) Context
               deriving (Eq, Ord, Read, Show)

ppPair :: (Int, Int) -> Doc
ppPair (a, b) = parens (int a <> comma <+> int b)

ppComment :: (a -> Doc) -> Comment a -> Doc
ppComment _   Done               = text "done."
ppComment ppA (Process tf ctx c) = ppPair tf <+> brackets (hsep $ map ppPair ctx) <> colon <+> ppChoice ppA c
ppComment _   (Explore tf ctx)   = text "exploring:" <+> ppPair tf <+> brackets (hsep $ map ppPair ctx)

ppChoice :: (a -> Doc) -> Choice a -> Doc
ppChoice ppA (Keep l r)     = ppA l <+> text "<=" <+> ppA r <> semi <+> text "keeping."
ppChoice ppA (Update l r n) = ppA l <+> text "</=" <+> ppA r <> semi <+> text "updating to" <+> ppA n <> char '.'
ppChoice ppA (Invalid)      = text "invalid transition."

