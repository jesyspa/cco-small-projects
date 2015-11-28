module CCO.Diag.TypeCheck (
      tcTDiag
) where

import CCO.Component          (Component, component)
import CCO.Feedback           (Message(Error), messages)
import CCO.Printing           (pp)
import CCO.Diag.TypeError     (TypeError(..), TypeErrorAnn(..))
import CCO.Diag.Base          (Diag)
import CCO.Diag.AG.TypeCheck  (wrap_Diag, err_Syn_Diag, Inh_Diag(..), sem_Diag)

tcTDiag :: Component Diag Diag
tcTDiag = component $ \diag -> do
  let
    errs = err_Syn_Diag $ wrap_Diag (sem_Diag diag) $ Inh_Diag
    msgs = map (Error . pp) errs
  messages msgs
  return diag
