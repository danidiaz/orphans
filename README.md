# a silly experiment with Backpack and orphan instances.

(check [this
tutorial](https://github.com/danidiaz/really-small-backpack-example) for an
intro to Backpack.)

We have a library `foo` with a module `Foo` which exports a type `Foo`.
There's also an empty, unused `Foo.Sig` [module
signature](https://downloads.haskell.org/ghc/latest/docs/html/users_guide/separate_compilation.html#module-signatures):

    exposed-modules:     Foo
    signatures:          Foo.Sig

In the executable section, we instantiate the `foo` lib in two different ways.
Now we have modules `Foo1` and `Foo2`. Each one exports a copy of the type
`Foo`. 

    mixins:
          foo (Foo as Foo1) requires (Foo.Sig as Foo.Sig1),
          foo (Foo as Foo2) requires (Foo.Sig as Foo.Sig2)

Both copies of the type `Foo` count as different datatypes because we matched
the signature with different mixin modules `Foo.Sig1` and `Foo.Sig2` (even if
they are both empty, like the sig! Even if the module `Foo` never actually uses
the sig! Yes, this is a hack.)

In `Main.hs`, we define `Show` instances for `Foo1.Foo` and `Foo2.Foo` and
there's no conflict:

    instance Show Foo1.Foo where    
        show _ = "this is show1"

    instance Show Foo2.Foo where    
        show _ = "this is show2"

## how to create a conflict

In the cabal file, change the lines

    foo (Foo as Foo1) requires (Foo.Sig as Foo.Sig1),
    foo (Foo as Foo2) requires (Foo.Sig as Foo.Sig2)

into

    foo (Foo as Foo1) requires (Foo.Sig as Foo.Sig1),
    foo (Foo as Foo2) requires (Foo.Sig as Foo.Sig1)

then invoke

    cabal clean
    cabal build

now there's a conflict!

    Main.hs:7:10: error:
        Duplicate instance declarations:
          instance Show Foo2.Foo -- Defined at Main.hs:7:10
          instance Show Foo2.Foo -- Defined at Main.hs:10:10
      |
    7 | instance Show Foo1.Foo where

Why? Because now we have instantiated `foo` twice *in the exact same way*, with
the same implementation module. That, for Backpack, means that the `Foo` types
in `Foo1` and `Foo2` are actually the same.

Oddly enough, if you *don't* invoke `cabal clean` after changing the .cabal
file and invoke `cabal build` right away, it compiles. But I think this is
because of some bug in cabal-install. It's not rebuilding as much as it should.

