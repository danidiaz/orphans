module Main where


import qualified Foo1
import qualified Foo2

instance Show Foo1.Foo where    
    show _ = "this is show1"

instance Show Foo2.Foo where    
    show _ = "this is show2"

main :: IO ()
main = do
    putStrLn $ show Foo1.Foo
    putStrLn $ show Foo2.Foo
