module ApplyConstantPropagation (
      propagateConstants
) where

import AG.AttributeGrammar
import AG.ApplyConstantPropagation
import Analysis
import qualified Data.Map as M
import Data.Maybe

-- | Improve the program using the CP analysis result.
propagateConstants :: AnalysisResult (Maybe (M.Map String Int)) -> Program' -> Program'
propagateConstants result prog = sem_Program' prog (\i -> fromMaybe M.empty $ result i Entry)
