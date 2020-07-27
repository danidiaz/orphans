This is a silly experiment with Backpack and orphan instances.

We have a `foo` library with a module `Foo` which exports a type `Foo`.
There's also an empty, unused `Foo.Sig` module signature.

In the executable, we instantiate the `foo` lib in two different ways.  Now we
have modules `Foo1` and `Foo2`. Each one exports a copy of the type `Foo`. 

Both copies of `Foo` count as different datatypes because instantiated the
signature with different modules `Foo.Sig1` and `Foo.Sig2` (even if they are
both empty, like the sig!)

We define `Show` instances for `Foo1.Foo` and `Foo2.Foo` and there's no
conflict.

## how to create a conflict


