module CCO.HM.ToBNormal (
      toBNormal
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.ToBNormal
import CCO.HM.Base
import CCO.Component
import Control.Arrow (arr)

toBNormal :: Component Root BRoot
toBNormal = arr sem_Root

