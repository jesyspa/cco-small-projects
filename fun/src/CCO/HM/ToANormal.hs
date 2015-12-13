module CCO.HM.ToANormal (
      toANormal
) where

import CCO.HM.ANormal
import CCO.HM.AG.ANormalUtils
import CCO.HM.AG.ToANormal
import CCO.HM.Base
import CCO.HM.Builtins
import CCO.Component
import CCO.Feedback
import CCO.Printing
import CCO.Tree

toANormal :: Component Tm ATm
toANormal = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) (Inh_Tm 0)
        binds = tbindings_Syn_Tm wtm
        term = term_Syn_Tm wtm
        vars = freevars_Syn_Tm wtm
        result = wrapBinds term (binds ++ filter (flip elem vars . fst) builtins)
    return result

