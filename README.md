# termcon

> A *con*temporary cross-platform *term*inal interface library.

**termcon** is a low-level cell-based terminal interface library, designed
primarily to be simple to implement across multiple platforms.

**Note: This README is for *users* rather than *contributors*.** If you would
like to contribute, read the [CONTRIBUTING](CONTRIBUTING.md) page instead.

## Todo

- [x] Add to backend interface for cursor visibility
- [x] Expose public interface for cursor visibility/movement
- [x] Add way to query for supported features
- [ ] Implement initial version of public interface
- [ ] Add `Mutex` locks for thread safety
- [ ] Implement `termios` backend
- [ ] Implement `windows` backend
