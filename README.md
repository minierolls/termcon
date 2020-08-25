# termcon

> A *con*temporary cross-platform *term*inal interface library.

**termcon** is a low-level cell-based terminal interface library, designed
primarily to be simple to implement across multiple platforms.

## Todo

- [x] Add to backend interface for cursor visibility
- [x] Expose public interface for cursor visibility/movement
- [x] Add way to query for supported features
- [ ] Implement public interface
- [ ] Implement `termios` backend
- [ ] Implement `windows` backend

## Contributing

Currently, this library is *vaporware*; none of its desired features are fully
implemented. However, if you are interested in contributing to turn this
project into reality *sooner*, then please take a look at the following.

### General Source Control Practices

All commits should be tagged in the subject within angle brackets (`<...>`).
Some example tags include:

- `doc`: Documentation, including comments, README, license, copyright notices,
  and more.
- `feat`: Feature, including new implementations, improved functionality,
  and more.
- `fix`: Fixes, implementation-only changes that do not change the publicly
  exposed functionality or interface.
- `scm`: Source control management, including changes to the build system or
  the repository.
- `break`: Breaking changes; not currently in use as the interface is changing
  frequently for now, but intended to signal a major/breaking API change.

Commits should be self-contained and single-responsibility if possible, with
accompanying summaries and descriptions in the commit message.

### Backend

The easiest way to contribute a backend implementation is to copy all
`unimplemented` files in the `src/backend` folder, and use those as a reference
for your implementation.

Some notes to consider:

- Don't worry about thread safety! The library implementation will guarantee
  thread-safe access to your backend functions.
- You don't have to buffer your `write` functions. The library implementation
  is responsible for buffering and batching content into a single `write` call.
