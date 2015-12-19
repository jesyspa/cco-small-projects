module CCO.BNormal.AddLaziness (
      addLaziness
) where

import CCO.BNormal.AG.BNormal     (BRoot)
import CCO.BNormal.AG.AddLaziness (sem_BRoot)
import CCO.Component              (Component)
import Control.Arrow              (arr)

-- | Add laziness annotations to the code.
addLaziness :: Component BRoot BRoot
addLaziness = arr sem_BRoot
