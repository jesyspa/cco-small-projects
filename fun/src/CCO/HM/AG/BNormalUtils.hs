module CCO.HM.AG.BNormalUtils (
      wrap
    , extend
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.BaseHelpers

wrap :: Either BTm BExp -> Bindings -> BBind
wrap (Left  tm)  bs = BBind bs tm
wrap (Right exp) bs = BBind bs (BExp exp)

extend :: Var -> Either BTm BExp -> Bindings -> Bindings
extend x (Left  tm)  bs = [(x, BWrap (BBind bs tm))]
extend x (Right exp) bs = [(x, exp)] ++ bs

