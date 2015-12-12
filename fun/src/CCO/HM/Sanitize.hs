module CCO.HM.Sanitize (
      sanitize
) where

import CCO.HM.AG.Sanitize
import CCO.HM.AG.Base
import CCO.HM.Builtins (builtinList)
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

sanitize :: Component Tm Tm
sanitize = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) (Inh_Tm [] 0)
        code = code_Syn_Tm wtm
        fv = freevars_Syn_Tm wtm
        unresolved = fv \\ builtinList
    when (not $ null unresolved) $ trace_ $ "Unresolved symbols: " ++ show unresolved
    return code
