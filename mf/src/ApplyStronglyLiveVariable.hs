module ApplyStronglyLiveVariable (
      removeDeadAssignments
) where

import AG.AttributeGrammar
import AG.ApplyStronglyLiveVariable
import Analysis
import qualified Data.Set as S

-- | Use the SLV analysis result to improve the program.
removeDeadAssignments :: AnalysisResult (S.Set String) -> Program' -> Program'
removeDeadAssignments result prog = sem_Program' prog (`result` Entry)
