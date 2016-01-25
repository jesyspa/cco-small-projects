module Comment (
      Comment(..)
    , Choice(..)
    , Context
    , ppComment
) where

import Text.PrettyPrint

-- | A context for the analysis.
--
-- Makes sure we only return to where we called things from.
type Context = [(Int, Int)]

-- | A choice the analysis engine made.
data Choice a = Keep a a
              | Update a a a
              | Invalid
              | TooDeep
              deriving (Eq, Ord, Read, Show)

-- | A comment on the progress of the analysis.
data Comment a = Done
               | Process (Int, Int) Context (Choice a)
               | Explore (Int, Int) Context
               deriving (Eq, Ord, Read, Show)

-- | Pretty print a pair
ppPair :: (Int, Int) -> Doc
ppPair (a, b) = parens (int a <> comma <+> int b)

-- | Pretty print a Comment a
--
-- a must be pretty-printable
ppComment :: (a -> Doc) -> Comment a -> Doc
ppComment _   Done               = text "done."
ppComment ppA (Process tf ctx c) = ppPair tf <+> brackets (hsep $ map ppPair ctx) <> colon <+> ppChoice ppA c
ppComment _   (Explore tf ctx)   = text "exploring:" <+> ppPair tf <+> brackets (hsep $ map ppPair ctx)

-- | Pretty print a Choice a
--
-- a must be pretty-printable
ppChoice :: (a -> Doc) -> Choice a -> Doc
ppChoice ppA (Keep l r)     = ppA l <+> text "<=" <+> ppA r <> semi <+> text "keeping."
ppChoice ppA (Update l r n) = ppA l <+> text "</=" <+> ppA r <> semi <+> text "updating to" <+> ppA n <> char '.'
ppChoice ppA Invalid        = text "invalid transition."
ppChoice ppA TooDeep        = text "analysis too deep."

