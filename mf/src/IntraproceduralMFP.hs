{-# LANGUAGE RecordWildCards #-}
module IntraproceduralMFP (
      runIntraprocAnalysis
) where

import Analysis
import AG.AttributeGrammar
import Comment

import Data.Map (Map)
import qualified Data.Map as M

import Control.Monad.Writer

runIntraprocAnalysis :: AnalysisSpec a -> Writer [Comment a] (AnalysisResult a)
runIntraprocAnalysis AnalysisSpec{..} = go flowGraph initialInfo
  where
    lookup = M.findWithDefault bottom
    initialInfo = foldr (`M.insert` extremal) M.empty entries

    go [] info = do
            tell $ [Done]
            return $ finalize info
    go ((l, l') : wl) info
        | fal `leq` al' = do
            tell' $ Keep fal al'
            go wl info
        | otherwise = do
            let newVal = al' `combine` fal
            tell' $ Update fal al' newVal
            let newInfo = M.insert l' newVal info
                newWork = filter (\p -> fst p == l') flowGraph
            go (newWork ++ wl) newInfo
      where
        al = lookup l info
        al' = lookup l' info
        fal = runUpdate update combine l al
        tell' = tell . return . Process (l, l') []

    finalize info i Entry = lookup i info
    finalize info i Exit  = runUpdate update combine i (lookup i info)

runUpdate :: Update a -> (a -> a -> a) -> Int -> a -> a
runUpdate (Monolithic f) _ i x = f i x
runUpdate Composite{..} cmb i x = (x `remove` kill i) `cmb` gen i
