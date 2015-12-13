module CCO.HM.AnnotateTailCalls (
      annotateTailCalls
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.AnnotateTailCalls
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import Control.Arrow (arr)
import CCO.Core.AG.Base

annotateTailCalls :: Component BRoot BRoot
annotateTailCalls = arr sem_BRoot
