module CCO.HM.Table (
      Table
    , emptyTable
    , searchTable
    , newVar
) where

import CCO.HM.AG.BaseHelpers

type Table = [(Var, Var)]

emptyTable :: Table
emptyTable = []

newVar :: Var -> Var -> Table -> Table
newVar x x' t = t ++ [(x, x')]

searchTable :: Table -> Var -> (Var, [Var])
searchTable t v = case lookup v t of
                    Just v' -> (v', [])
                    Nothing -> (v, [v])

