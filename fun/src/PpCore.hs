import CCO.Component    (Component, component, ioWrap)
import CCO.Core         (Mod)
import CCO.Core.Print
import CCO.Tree         (ATerm, toTree, parser)
import Control.Arrow    ((>>>))

main :: IO ()
main = ioWrap $ parser >>> (component toTree :: Component ATerm Mod) >>> crprinter

