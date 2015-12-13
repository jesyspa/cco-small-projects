module CCO.HM.AddForcing (
      addForcing
) where

import CCO.HM.AG.AddForcing
import CCO.HM.AG.ANormal
import CCO.HM.AG.ANormalUtils
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

addForcing :: Component AExp ATm
addForcing = component $ \tm -> do
    let wtm = wrap_AExp (sem_AExp tm) (Inh_AExp 0 True)
        code = code_Syn_AExp wtm
    return $ AExp $ AForce code
