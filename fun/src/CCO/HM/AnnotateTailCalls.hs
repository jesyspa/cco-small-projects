module CCO.HM.AnnotateTailCalls (
      annotateTailCalls
) where

import CCO.HM.AG.BNormal           (BRoot)
import CCO.HM.AG.AnnotateTailCalls (sem_BRoot)
import CCO.Component               (Component)
import Control.Arrow               (arr)

-- | Add annotations for computations in tail position.
annotateTailCalls :: Component BRoot BRoot
annotateTailCalls = arr sem_BRoot
