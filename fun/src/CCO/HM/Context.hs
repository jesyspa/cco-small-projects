module CCO.HM.Context (
      empty
    , Context
    , resolve
    , push
    , pushFrame
) where

import CCO.HM.AG.BaseHelpers
import qualified CCO.Core.AG.Base as C
import Data.List
import Control.Applicative ((<|>))
import Data.Maybe

data Context = Context { locals :: [[Var]], globals :: [Var] }
             deriving (Eq, Ord, Read, Show)

empty :: Context
empty = Context [] []

resolve :: Var -> Context -> C.Ref
resolve x (Context ls gs) = maybe (error $ "undefined: " ++ x) id $ findLoc x ls <|> findGlob x gs

findGlob :: Var -> [Var] -> Maybe C.Ref
findGlob x gs = C.Glob <$> elemIndex x (reverse gs)

findLoc :: Var -> [[Var]] -> Maybe C.Ref
findLoc x ls = do
  s <- find (x `elem`) ls
  -- This is ridiculously inefficient but works for now
  C.Loc <$> elemIndex s ls <*> elemIndex x (reverse s)

push :: Var -> Context -> Context
push x (Context [] gs) = Context [] (x:gs)
push x (Context (l:ls) gs) = Context ((x:l):ls) gs

pushFrame :: Context -> Context
pushFrame (Context ls gs) = Context ([]:ls) gs
