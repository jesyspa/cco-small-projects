module CCO.HM.ToBNormal (
      toBNormal
) where

import CCO.BNormal.AG.BNormal
import CCO.HM.AG.ToBNormal
import CCO.HM.Base
import CCO.Component
import Control.Arrow (arr)

-- | Convert a Hindley-Milner term to BNormal form.
toBNormal :: Component Root BRoot
toBNormal = arr sem_Root

