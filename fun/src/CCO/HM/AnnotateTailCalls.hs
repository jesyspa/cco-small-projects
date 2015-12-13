module CCO.HM.AnnotateTailCalls (
      annotateTailCalls
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.AnnotateTailCalls
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import CCO.Core.AG.Base

annotateTailCalls :: Component BRoot BRoot
annotateTailCalls = component $ \br -> do
    let wbr = wrap_BRoot (sem_BRoot br) Inh_BRoot
    return $ code_Syn_BRoot wbr
