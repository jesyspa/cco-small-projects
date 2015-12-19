module CCO.BNormal.AG.BNormalUtils (
      wrap
    , extend
    , extendBind
) where

import CCO.BNormal.AG.BNormal
import CCO.HM.Base (Var)

-- | Attach bindings to a BNormal term or expression to get a BNormal binding group.
wrap :: Either BTm BExp -> Bindings -> BBind
wrap (Left tm) bs = BBind bs tm
wrap (Right e) bs = BBind bs (BExp e)

-- | Add a binding to a list of bindings.
--
-- Expressions can be bound directly, but terms must first be wrapped.
extend :: Var -> Either BTm BExp -> Bindings -> Bindings
extend x (Left  tm)  bs = [(x, BWrap (BBind bs tm))]
extend x (Right e) bs = bs ++ [(x, e)]

-- | Extend a BNormal binding with some bindings, attaching them outside the existing scope.
extendBind :: Bindings -> BBind -> BBind
extendBind bs (BBind bs' t) = BBind (bs' ++ bs) t
