module CCO.Diag.TypeCheck (
      tcTDiag
) where

import CCO.Component     (Component, component)
import CCO.Feedback      (Message(Error), messages)
import CCO.Printing      (text)
import CCO.Diag.Base     (Diag)
import CCO.Diag.AG       (wrap_Diag, err_Syn_Diag, Inh_Diag(..), sem_Diag)
import CCO.Diag.DiagType (nullType)

tcTDiag :: Component Diag Diag
tcTDiag = component $ \diag -> do
    let errs = maybe [] id $ err_Syn_Diag (wrap_Diag (sem_Diag diag) $ Inh_Diag nullType)
        msgs = map (Error . text . show) errs
    messages msgs
    return diag
