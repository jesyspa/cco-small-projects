module Main where

import Dev
import PrettyPrint
import Properties as P
import Control.Monad

main :: IO ()
main = do
    putStrLn "Some parsing and pretty-printing examples:"
    forM_ ["break", "continue", "cp1", "fib", "loop_forever", "malloc", "simple"] $ \name -> do
        let name' = "examples/" ++ name ++ ".c"
        putStrLn $ "program " ++ name ++ ":"
        p <- parse' name'
        print $ ppProgram' p
        putStr "Flow: "
        print $ flow p
        putStr "Interprocedural Flow: "
        print $ interFlow p
        putStrLn ""

    forM_ ["basic", "bad-if", "good-if", "while", "reassign", "proc-simple", "proc", "fib"] $ \name -> do
        let name' = "examples/const_propagation/" ++ name ++ ".c"
        putStrLn $ "constant propagation example: " ++ name
        p <- parse' name'
        runAnalysis' cp p
        putStrLn ""

    forM_ ["basic", "b-var", "if", "while", "proc-simple", "proc-id"] $ \name -> do
        let name' = "examples/strong_live_variable/" ++ name ++ ".c"
        putStrLn $ "strongly live variable example: " ++ name
        p <- parse' name'
        runAnalysis' slv p
        putStrLn ""

