module CCO.HM.ToCore (
      toCore
) where

import CCO.HM.AG.BNormal (BRoot)
import CCO.HM.AG.HmCore  (sem_BRoot)
import CCO.Component     (Component)
import CCO.Core.AG.Base  (Mod)
import Control.Arrow     (arr)

-- | Convert a rooted BNormal term to a Core module.
toCore :: Component BRoot Mod
toCore = arr $ sem_BRoot
