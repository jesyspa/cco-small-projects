module CCO.HM.AddLaziness (
      addLaziness
) where

import CCO.HM.AG.BNormal     (BRoot)
import CCO.HM.AG.AddLaziness (sem_BRoot)
import CCO.Component         (Component)
import Control.Arrow         (arr)

-- | Add laziness annotations to the code.
addLaziness :: Component BRoot BRoot
addLaziness = arr sem_BRoot
