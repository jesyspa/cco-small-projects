module CCO.HM.AddForcing (
      addForcing
) where

import CCO.HM.AG.AddForcing
import CCO.HM.AG.BNormal
import CCO.HM.AG.BNormalUtils
import CCO.Component
import CCO.Feedback
import Control.Arrow (arr)
import Data.List
import Control.Monad

addForcing :: Component BRoot BRoot
addForcing = arr sem_BRoot
