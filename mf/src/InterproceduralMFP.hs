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

-- | A transfer we must still consider in the analysis.
--
-- Gives what label we transition from and to, and in what context.
data Transfer = Transfer (Int, Int) Context
              deriving (Eq, Ord, Read, Show)

-- | Run the given analysis up to the given depth (of function calls), yielding
-- a result and some comments.
--
-- The comments were added to assist in debuging, but nicely illustrate the
-- behaviour of the algorithm.
runInterprocAnalysis :: Int -> AnalysisSpec a -> Writer [Comment a] (AnalysisResult a)
runInterprocAnalysis k AnalysisSpec{..} = go initialWork initialInfo
  where
    lookup       = M.findWithDefault bottom
    initialInfo  = foldr (`M.insert` extremal) M.empty $ map (\x -> (x, [])) entries
    initialSteps = [Transfer tf [] | tf <- flowGraph, fst tf `elem` entries]
    initialBody  = [Transfer tf [] | l <- entries, tf <- M.findWithDefault [] l procBodies]
    initialWork  = initialSteps ++ initialBody

    -- Update the state with the given transfers.
    --
    -- There are a bunch of checks here that should never actually be triggered;
    -- for example, as far as I can tell, j
    go [] info = do
            tell [Done]
            return $ finalize info
    go (Transfer tf@(l, l') ctx : wl) info
        -- We are recursing too deep.
        | length ctx > k = do
            tell' TooDeep
            go wl info
        -- 
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
                                        Just rj -> (tf:ctx, if length ctx < k
                                                            then [Transfer rj newCtx]
                                                            else [Transfer (fst tf, snd rj) ctx])
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

    -- Turn the final state into a function, so that it can be used as the
    -- analysis result.
    finalize info i Entry = foldr combine bottom [v | ((i', _), v) <- M.assocs info, i == i']
    finalize info i Exit  = runUpdate update combine i $ finalize info i Entry

    -- Check whether the transfer we return by is valid.
    invalidReturn rl [] = False
    invalidReturn rl (cl:_) = rl `elem` map snd procFlowGraph && (cl, rl) `notElem` procFlowGraph

