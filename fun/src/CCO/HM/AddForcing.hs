module CCO.HM.AddForcing (
      addForcing
) where

import CCO.HM.AG.AddForcing (sem_BRoot)
import CCO.HM.AG.BNormal    (BRoot)
import CCO.Component        (Component)
import Control.Arrow        (arr)

addForcing :: Component BRoot BRoot
addForcing = arr sem_BRoot
