module CCO.HM.AG.ANormalUtils where

import CCO.HM.AG.BaseHelpers
import CCO.HM.AG.ANormal

wrapBinds :: ATm -> [(Var, AExp)] -> ATm
wrapBinds e = foldr (uncurry ALet) e . reverse

wrapBinds' :: AExp -> [(Var, AExp)] -> ATm
wrapBinds' = wrapBinds . AExp

