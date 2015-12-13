module CCO.HM.AnnotateTailCalls (
      annotateTailCalls
) where

import CCO.HM.AG.ANormal
import CCO.HM.AG.AnnotateTailCalls
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import CCO.Core.AG.Base

annotateTailCalls :: Component ATm ATm
annotateTailCalls = component $ \atm -> do
    let wtm = wrap_ATm (sem_ATm atm) (Inh_ATm True)
    return $ code_Syn_ATm wtm
