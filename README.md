# Free Interpreter: Project Tutorial

Welcome! This repository demonstrates the technique detailed by
Gabriel Gonzalez's
[Purify Code Using Free Monads](http://www.haskellforall.com/2012/07/purify-code-using-free-monads.html).

As an added bonus, this also shows:

* One way to break the ideas into modules
* Haskell project structure
* Testing a simple property using [QuickCheck](https://hackage.haskell.org/package/QuickCheck)

## Differences

This tutorial deviates syntactically from the article linked above by
using desugared monadic style rather than do-notation, e.g.:

```haskell
echo = getLine' >>= putStrLn' >> exitSuccess' >> putStrLn' "Finished"
```

Rather than:

```haskell
echo = do
  str <- getLine'
  purStrLn' str
  exitSuccess'
  putStrLn' "Finished"
```

## Building

```
$ cabal build
```

## Running

```
$ cabal run
```

## Testing

```
$ cabal test properties
```
