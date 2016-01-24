{-# LANGUAGE RecordWildCards #-}
module ChaoticIteration (
      chaoticIteration
    , Comment(..)
) where

import Analysis
import AG.AttributeGrammar

import Data.Map (Map)
import qualified Data.Map as M

import Control.Monad.Writer

data Comment = CS String
             deriving (Eq, Ord, Read, Show)

comment :: Writer [Comment] a -> String -> Writer [Comment] a
comment a s = tell [CS s] >> a

chaoticIteration :: Show a => AnalysisSpec a -> Writer [Comment] (AnalysisResult a)
chaoticIteration AnalysisSpec{..} = go flowGraph initialInfo
  where
    lookup = M.findWithDefault bottom
    initialInfo = foldr (`M.insert` extremal) M.empty entries

    go [] info = return (finalize info) `comment` "done"
    go ((l, l') : wl) info | fal `leq` al' = go wl info `comment` (show fal ++ " <= " ++ show al')
                           | otherwise = let newInfo = M.insert l' (al' `combine` fal) info
                                             newWork = filter (\p -> fst p == l') flowGraph
                                         in go (newWork ++ wl) newInfo `comment` (show fal ++ " </= " ++ show al')
      where
        al = lookup l info
        al' = lookup l' info
        fal = runUpdate update combine l al

    finalize info i Entry = lookup i info
    finalize info i Exit  = runUpdate update combine i (lookup i info)

runUpdate :: Update a -> (a -> a -> a) -> Int -> a -> a
runUpdate (Monolithic f) _ i x = f i x
runUpdate Composite{..} cmb i x = (x `remove` kill i) `cmb` gen i
