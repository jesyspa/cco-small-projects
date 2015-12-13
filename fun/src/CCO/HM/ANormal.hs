module CCO.HM.ANormal (
      AVal(..)
    , AVals
    , AExp(..)
    , ATm(..)
    , ARoot(..)
) where

import CCO.HM.AG.ANormal
import CCO.Tree                   (Tree (fromTree, toTree))
import qualified CCO.Tree as T    (ATerm (App))
import CCO.Tree.Parser            (parseTree, app, arg)
import Control.Applicative        (Applicative ((<*>)), (<$>))

instance Tree AVal where
  fromTree (ANat i)     = T.App "Nat"   [fromTree i]
  fromTree (AVar x)     = T.App "Var"   [fromTree x]
  fromTree (AField x i) = T.App "Field" [fromTree x, fromTree i]
  toTree = parseTree [ app "ANat"   (ANat   <$> arg        )
                     , app "AVar"   (AVar   <$> arg        )
                     , app "AField" (AField <$> arg <*> arg)
                     ]

instance Tree AExp where
  fromTree (AVal x)        = T.App "AVal"   [fromTree x]
  fromTree (AApp e v)      = T.App "AApp"   [fromTree e, fromTree v]
  fromTree (ALam x t)      = T.App "ALam"   [fromTree x, fromTree t]
  fromTree (AAlloc tag vs) = T.App "AAlloc" [fromTree tag, fromTree vs]
  fromTree (APrim op vs)   = T.App "APrim"  [fromTree op, fromTree vs]
  fromTree (AForce e)      = T.App "AForce" [fromTree e]
  fromTree (ATail e)       = T.App "ATail"  [fromTree e]


  toTree = parseTree [ app "AVal"   (AVal    <$> arg                 )
                     , app "AApp"   (AApp    <$> arg <*> arg         )
                     , app "ALam"   (ALam    <$> arg <*> arg         )
                     , app "AAlloc" (AAlloc  <$> arg <*> arg         )
                     , app "APrim"  (APrim   <$> arg <*> arg         )
                     , app "AForce" (AForce  <$> arg                 )
                     , app "ATail"  (ATail   <$> arg                 )
                     ]

instance Tree ATm where
  fromTree (AExp e)      = T.App "AExp"  [fromTree e]
  fromTree (ALet x e t)  = T.App "ALet"  [fromTree x, fromTree e, fromTree t]
  fromTree (AIf c t1 t2) = T.App "AIf"   [fromTree c, fromTree t1, fromTree t2]
  toTree = parseTree [ app "AExp"   (AExp   <$> arg                )
                     , app "ALet"   (ALet   <$> arg <*> arg <*> arg )
                     , app "AIf"    (AIf    <$> arg <*> arg <*> arg )
                     ]
