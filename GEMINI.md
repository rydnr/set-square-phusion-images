**set-square-phusion-images** is a catalog of phusion-based (https://github.com/phusion/baseimage-docker) Docker images built with **set-square** (https://github.com/rydnr/set-square), which uses **dry-wit** (https://github.com/rydnr/dry-wit) underneath.

# Project structure

The project layout is:
- `/.set-square`: `set-square` as a git submodule of `set-square-phusion-images`.
- `/.set-square/common-files/dry-wit`: `dry-wit` as a git submodule of `set-square`.
- `/build.sh`: a symlink to `set-square`'s build script
- `/build.inc.sh`: Default values for the build script.
- `/.build.inc.sh`: Custom values that override the default values for the build script.
- `/[docker image]/Dockerfile.template`: The Dockerfile template for a given application we want to package as a Docker image.
- `/[docker image]/build-settings.sh`: Defines custom variables that will be used by `Dockerfile.template` or any other templates in the process of transforming `Dockerfile.template` into the final `Dockerfile`.
- `/[docker image]/Dockerfile`: The final Dockerfile. It's not committed to git.
- `/[docker image]/README.md`: Instructions on how to run the image, and other important considerations.

Why do we use templates instead of regular `Dockerfiles`? Because regular `Dockerfiles` don't support composition using subtemplates. `Dockerfile.template` support `@include([subtemplate])` directives. This way we improve consistency of all Docker images, by including certain templates, and help separating concerns. Also, we can benefit from some optimizations in subtemplates.

Each subtemplates are expected to be in the `.templates/` folder. The structure of a subtemplate is:
- `/.templates/[subtemplate].template`: The subtemplate in Dockerfile format.
- `/.templates/[subtemplate].settings`: Default values for the variables in `/.templates/[subtemplate].template`.
- `/.templates/[subtemplate]-files/`: Additional files or subtemplates used by the subtemplate itself.

The process is, in summary:
- When the user calls `./build.sh [docker image]`, `set-square` reads the `/[docker image]/Dockerfile.template`.
- It resolves all subtemplates it finds in that `/[docker image]/Dockerfile.template`, and copies them to `/[Docker image]/` (because it's the root of the context passed to `docker build`).
- For each `[file].template` file it finds, it processes it and generates the corresponding `[file]`.
- When all subtemplates are processed, `set-square` runs `docker build`.
- Depending on the options passed to `./build.sh`, `set-square` might do further operations or optimizations on the Docker image.

# General guidelines

- Generic subtemplates can be promoted from `/.templates/` to `/.set-square/.templates/`. There's another sibling project, **set-square-alpine-images**, that use Alpine instead of Ubuntu (the base image of Phusion). We can only promote subtemplates that are not specific to any operating system.
- We can build abstractions (for example `${PKG_INSTALL}`, `${SYSTEM_UPDATE}`, `${SYSTEM_CLEANUP}`) that get resolved to distribution-specific commands.
- The `Dockerfile.template` files should respect the best practices: especially joining consecutive `RUN` commands into one single instruction, to make sure only one layer gets created.
- All `${PKG_INSTALL}` calls must be in the same `RUN` instruction as `${SYSTEM_UPDATE}` and `${SYSTEM_CLEANUP}`.
- Composing Docker images is recommended when we want hybrid images that not only include one software package, but other complementary ones. For example, when we want to be able to work on Glamorous Toolkit but also building the Pharo image with Gradle, and producing PDFs with texlive, we define subtemplates for all three of them, and `@include` them in a new `Dockerfile.templae` image.
- Resulting Docker images should provide aids for the user to know how to run. The `README.md` file can be inspected if the image runs with `-h` flag.
- Images should respect Phusion's approach, and add bootstrap scripts to `/etc/my_init.d/` folder. If regular bootstrap is not recommended, override Phusion's startup script by providing a custom `/sbin/my_exec`.
- Complex software that runs setup wizards the first time should be automated in the very Dockerfile, and ask the user to provide all required information via command-line arguments. We can choose to define general values or conventions at build time too. The objective is to be able to replace Docker images with zero manual tasks.
- There are cases in which a correct setup requires launching the process, perform some bootstrap tasks, and only then expose the service. For example, enabling authentication in MongoDB, or setting up DDLs in MariaDB. In some cases we build complementary `-bootstrap` images designed to run certain commands on the not-yet-ready Docker container, and then they are shut down when they finish. 
