module CCO.HM.AG.ANormalUtils where

import CCO.HM.AG.BaseHelpers
import CCO.HM.AG.ANormal

wrapBinds :: AExp -> [(Var, AExp)] -> ATm
wrapBinds e = foldr (uncurry ALet) (AExp e) . reverse

