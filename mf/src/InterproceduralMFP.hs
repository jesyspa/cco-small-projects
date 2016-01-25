{-# LANGUAGE RecordWildCards #-}
module InterproceduralMFP (
      runInterprocAnalysis
) where

import Analysis
import AG.AttributeGrammar
import Comment

import Data.Map (Map)
import qualified Data.Map as M

import Control.Monad.Writer

data Transfer = Transfer (Int, Int) Context
              deriving (Eq, Ord, Read, Show)

runInterprocAnalysis :: AnalysisSpec a -> Writer [Comment a] (AnalysisResult a)
runInterprocAnalysis AnalysisSpec{..} = go initialWork initialInfo
  where
    lookup       = M.findWithDefault bottom
    initialInfo  = foldr (`M.insert` extremal) M.empty $ map (\x -> (x, [])) entries
    initialSteps = [Transfer tf [] | tf <- flowGraph, fst tf `elem` entries]
    initialBody  = [Transfer tf [] | l <- entries, tf <- M.findWithDefault [] l procBodies]
    initialWork  = initialSteps ++ initialBody

    go [] info = do
            tell $ [Done]
            return $ finalize info
    go (Transfer tf@(l, l') ctx : wl) info
        | invalidReturn tf ctx = do
            tell' Invalid
            go wl info
        | fal `leq` al' = do
            tell' $ Keep fal al'
            go wl info
        | otherwise = do
            let newVal = al' `combine` fal
            tell' $ Update fal al' newVal
            let newInfo = M.insert (l', ctx) newVal info
                (newCtx, retJmp) = case Prelude.lookup tf procFlowGraph of
                                        Just rj -> (tf:ctx, [Transfer rj newCtx])
                                        Nothing -> (ctx, [])
                nextSteps = [Transfer ntf newCtx | ntf <- flowGraph, fst ntf == l']
                newBody = [Transfer ntf newCtx | ntf <- M.findWithDefault [] l' procBodies]
                newWork = nextSteps ++ newBody ++ retJmp
            forM_ newWork $ \(Transfer ntf _) -> tell [Explore ntf newCtx]
            go (newWork ++ wl) newInfo
      where
        al = lookup (l, ctx) info
        al' = lookup (l', ctx) info
        fal = runUpdate update combine l al
        tell' = tell . return . Process tf ctx

    finalize info i Entry = foldr combine bottom [v | ((i', _), v) <- M.assocs info, i == i']
    finalize info i Exit  = runUpdate update combine i $ finalize info i Entry

    invalidReturn rl [] = False
    invalidReturn rl (cl:_) = rl `elem` map snd procFlowGraph && (cl, rl) `notElem` procFlowGraph

runUpdate :: Update a -> (a -> a -> a) -> Int -> a -> a
runUpdate (Monolithic f) _ i x = f i x
runUpdate Composite{..} cmb i x = (x `remove` kill i) `cmb` gen i
