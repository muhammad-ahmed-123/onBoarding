# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Ruby practice sandbox for working through language exercises topic by topic. Each `practiceN.rb` is an independent, standalone script exploring a different Ruby concept — there is no application, build system, test suite, or gem/bundler setup tying them together.

- `practice.rb` — Enumerable exercises over a `users` array-of-hashes (filtering active/adult users, extracting names, summing/averaging purchases, finding the top spender). Written in an imperative style: each task is a `def` using explicit accumulators and `each` loops, called immediately and printed via `puts`.
- `practice1.rb` — Enumerable exercises over a `products` array-of-hashes, written in a functional style chaining methods like `select`, `reduce`, `group_by`, `find`, `map`, `each_with_object`. Defines methods only; it does not call them.
- `practice2.rb` — A `WordCounter` class (with a `Logger` module mixed in via `include`) that tokenizes text, strips stopwords, counts word frequency, and returns the top N words.
- `practice3.rb` — Class inheritance exercise: `Admin` and `Customer` both subclass `User` (shared `login`/`logout`, calling `super` in `initialize` to set `name`/`email`) while `Guest` deliberately does *not* inherit from `User` since it has no account/login concept — only a standalone `browse` method.
- `practice4.rb` — Minimal demo of `include` vs `extend` vs `prepend` on a single `Person` class, showing how each changes the method resolution order (`Person.ancestors`).
- `practice5.rb` — Two independent class exercises: `Circle` (instance state plus a `@@count` class variable incremented in `initialize` and exposed via `self.count`) and `BankAccount` (a public `balance` reader with deposit/withdraw methods that route through a private `balance=` writer, encapsulating the `insufficient funds` check). Defines classes only; it does not instantiate or run them.

## Running

Each script is self-contained; run any of them directly:

```bash
ruby practice.rb    # runs and prints all task output
ruby practice1.rb   # defines methods but produces no output on its own
ruby practice2.rb   # defines WordCounter but does not instantiate/run it
ruby practice3.rb   # defines classes but does not instantiate/run them
ruby practice4.rb   # runs and prints include/extend/prepend output
ruby practice5.rb   # defines Circle and BankAccount but does not instantiate/run them
```

## Conventions

Files intentionally demonstrate contrasting Ruby idioms on purpose — e.g. imperative `each`/accumulator loops in `practice.rb` vs. chained Enumerable calls in `practice1.rb`. When adding to a file, match its existing style rather than normalizing across files. Data (users, products) lives inline at the top of a script as an array of symbol-keyed hashes; OOP exercises (`practice2.rb`–`practice5.rb`) instead define classes/modules directly.
