# TiddlyWikiMap in Docker

TiddlyWiki bundled with TiddlyMap in a Docker container.


## What?

* [TiddlyWiki](https://tiddlywiki.com/) is a very powerful webapp for note-taking/wikis/personal knowledge management/etc.
* [TiddlyMap](http://tiddlymap.org/) is a plugin for TiddlyWiki which enables you to create relations between your notes and visualize them as a graph.
* And this Docker container bundles them together, so you can easily and instantly spin up as many TiddlyWikis with TiddlyMap pre-installed as you want.
  * As installing plugins in a Dockerized TiddlyWiki is PITA, I had to create a Dockerfile doing it for me in an automated way.


## Usage

#### 1. Build the container

```bash
docker build . -t tiddlywikimap
```

#### 2. Run the container

```bash
docker run -p 8080:8080 tiddlywikimap
```

* Port `8080` is exposed from the container, but you can bind it to whatever. (e.g. `-p 1234:8080`)
* Data is stored in `/var/lib/tiddlywiki`, so you may want bind it to a volume. (e.g. `-v firstwiki:/var/lib/tiddlywiki`)

#### 3. Use the container

Open `http://localhost:8080/` and do whatever you want with your new TiddlyWiki installation!


## Configuration

Env. vars can be used to configure some parameters. Refer to the [source project this is based on](https://github.com/neechbear/tiddlywiki#configurable-variables) for more details.

Also you can specify the exact version of Alpine, Node.js and TiddlyWiki with build args (e.g. `--build-arg NODE_VERSION=16`). Refer to the [Dockerfile](Dockerfile).

## References

Heavily based on [@neechbear/tiddlywiki](https://github.com/neechbear/tiddlywiki). Thanks [@neechbear](https://github.com/neechbear)!


## TODO

* [ ] Publish this on Docker Hub, so people won't need to build it themselves.


## License

MIT.
