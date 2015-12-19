module CCO.HM.Sanitize (
      sanitize
) where

import CCO.HM.AG.Sanitize (wrap_Root, sem_Root, Inh_Root(..), unresolved_Syn_Root, code_Syn_Root)
import CCO.HM.AG.Base     (Root)
import CCO.HM.PrintUtils  (ppUse)
import CCO.Component      (Component, component)
import CCO.Feedback       (Message(Error), messages)

-- | Ensure the program defines all identifiers it uses (except builtins) and
-- remove shadowing.
sanitize :: Component Root Root
sanitize = component $ \r -> do
    let wr = wrap_Root (sem_Root r) Inh_Root
        code = code_Syn_Root wr
        errs = map (Error . ppUse) . reverse $ unresolved_Syn_Root wr
    messages errs
    return code
