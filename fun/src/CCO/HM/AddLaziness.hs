module CCO.HM.AddLaziness (
      addLaziness
) where

import CCO.HM.AG.AddLaziness
import CCO.HM.AG.BNormal
import CCO.HM.AG.BNormalUtils
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad
import Control.Arrow (arr)

addLaziness :: Component BRoot BRoot
addLaziness = arr sem_BRoot
