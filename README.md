# Confluence Static Cache Container for jenkins-ci.org
[![Build Status](http://ci.jenkins-ci.org/buildStatus/icon?job=infra_confluence-cache)](http://ci.jenkins-ci.org/view/Infrastructure/job/infra_confluence-cache/)

This container defines caching HTTP reverse proxy that sits right in front of wiki.jenkins-ci.org.

Its caching strategy is two folds:

* Confluence puts static resources in `/s/...`. Cache these resources so that we can cut down
  on HTTP request handling threads in Confluence, which in turn prevents database connection
  starvation during peak load.
* Read access to Wiki pages are served from statically pre-generated HTML files in conjunction
  with [Confluence static cache generator plugin](https://github.com/kohsuke/confluence-static-cache).
  This drastically improves the performance of read access to Wiki.

## How to run the container
The container execpts `/cache` to point to the cache files generated by Confluence static cache generator plugin.
Do this by `-v someHostDir:/cache`.

To specify the URL of Confluence, use the `TARGET` environment variable, such as `-e TARGET=http://backend:1234`

If your backend runs in another container, the easiest way to do it is by linking container, such as
 `--link=myConfluenceContainerName:backend -e TARGET=http://backend:8080` 

## How to develop the container
Run `make image` to build the container. Run `make test` to build the container and then run tests
against it. Tests start another nginx container as the backend to verify the behaviour of the cache.

If you are developing tests, you can run `make test-setup` to run the test setup, then edit
test source code and run `make test` to quickly run tests. When done, `make test-teardown` to
shut down .