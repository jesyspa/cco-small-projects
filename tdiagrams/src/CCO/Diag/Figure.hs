module CCO.Diag.Figure (
      Point(..)
    , zero
    , (|+|)
    , (|-|)
    , translate
    , rUProgram, cUProgram, rPPlatform, rUInterpreter, rPInterpreter, cUInterpreter, rUCompiler, cUCompiler, cPCompiler
) where

data Point = Point Double Double
           deriving (Eq, Ord, Read, Show)

zero :: Point
zero = Point 0 0

(|+|), (|-|) :: Point -> Point -> Point
Point x1 y1 |+| Point x2 y2 = Point (x1 + x2) (y1 + y2)
Point x1 y1 |-| Point x2 y2 = Point (x1 - x2) (y1 - y2)

translate :: Point -> (Double, Double) -> (Double, Double)
translate (Point x y) (a, b) = (a + x, b + y)

rUProgram :: Point
rUProgram = Point 7.5 0
cUProgram :: (Point, Point)
cUProgram = (Point 57.5 0, Point 7.5 0)

rPPlatform :: Point
rPPlatform = Point 0 30

rUInterpreter :: Point
rUInterpreter = Point 0 0
rPInterpreter :: Point
rPInterpreter = Point 0 30
cUInterpreter :: (Point, Point)
cUInterpreter = (Point 50 0, Point 0 0)

rUCompiler :: Point
rUCompiler = Point 50 0
cUCompiler :: (Point, Point)
cUCompiler = (Point 100 0, Point 50 0)
cPCompiler :: (Point, Point)
cPCompiler = (Point 0 20, Point 150 20)
