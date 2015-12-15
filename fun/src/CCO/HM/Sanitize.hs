module CCO.HM.Sanitize (
      sanitize
) where

import CCO.HM.AG.Sanitize
import CCO.HM.AG.BaseHelpers
import CCO.HM.AG.Base
import CCO.HM.PrintUtils
import CCO.Component
import CCO.SourcePos
import CCO.Feedback    (Message(Error), messages)
import Data.List
import Control.Monad


sanitize :: Component Root Root
sanitize = component $ \r -> do
    let wr = wrap_Root (sem_Root r) Inh_Root
        code = code_Syn_Root wr
        errs = map (Error . ppUse) . reverse $ unresolved_Syn_Root wr
    messages errs
    return code
