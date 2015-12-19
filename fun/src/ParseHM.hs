import CCO.Component    (ioWrap)
import CCO.HM           (parser)
import CCO.Tree         (fromTree)
import Control.Arrow    (arr, (>>>))
import CheapPrinter     (cheapPrinter)
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    ioWrap $ parser >>> arr fromTree >>> cheapPrinter ("-p" `elem` args)
