module CCO.BNormal.AddForcing (
      addForcing
) where

import CCO.BNormal.AG.AddForcing (sem_BRoot)
import CCO.BNormal.AG.BNormal    (BRoot)
import CCO.Component             (Component)
import Control.Arrow             (arr)

-- | Add forcing annotations to the code.
addForcing :: Component BRoot BRoot
addForcing = arr sem_BRoot
