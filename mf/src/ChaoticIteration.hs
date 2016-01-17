{-# LANGUAGE RecordWildCards #-}
module ChaoticIteration (
      chaoticIteration
) where

import Analysis
import AG.AttributeGrammar

import Data.Map (Map)
import qualified Data.Map as M

import Debug.Trace

chaoticIteration :: AnalysisSpec a -> AnalysisResult a
chaoticIteration AnalysisSpec{..} = go flowGraph initialInfo
  where
    lookup = M.findWithDefault bottom
    initialInfo = foldr (\x -> M.insert x extremal) M.empty entries

    go [] info = finalize info
    go ((l, l') : wl) info | fal `leq` al' = go wl info
                           | otherwise = let newInfo = M.insert l' (al' `combine` fal) info
                                             newWork = filter (\p -> fst p == l') flowGraph
                                         in go (newWork ++ wl) newInfo
      where
        al = lookup l info
        al' = lookup l' info
        fal = runUpdate update combine l al

    finalize info i Entry = lookup i info
    finalize info i Exit  = runUpdate update combine i (lookup i info)

runUpdate :: Update a -> (a -> a -> a) -> Int -> a -> a
runUpdate (Monolithic f) _ i x = f i x
runUpdate Composite{..} cmb i x = (x `remove` kill i) `cmb` gen i
