IMAGENAME=jenkinsciinfra/confluence-cache
TAG=$(shell date '+%Y%m%d_%H%M%S')

image :
	docker build -t ${IMAGENAME} .

run :
	docker run -P --rm -i -t ${IMAGENAME}

tag :
	docker tag ${IMAGENAME} ${IMAGENAME}:${TAG}

push :
	docker push ${IMAGENAME}


# run two containers side by side for testing
# access http://localhost:8081/ to go through nginx
# "http://localhost:8081/display/hello" should be cached
test-setup: image build/cache
	# start the fresh backend
	@docker kill backend > /dev/null 2>&1 || true
	@docker rm backend > /dev/null 2>&1 || true
	@docker kill cc > /dev/null 2>&1 || true
	@docker rm cc > /dev/null 2>&1 || true
	mkdir -p build/wwwroot/s || true
	docker run -d -p 8082:80 --name=backend -v `pwd`/build/wwwroot:/usr/share/nginx/html:ro nginx

	# start the cache
	@docker kill cc > /dev/null 2>&1 || true
	docker run -d -p 8081:8080 -t -i --name=cc -v `pwd`/build/cache:/cache --link backend:backend -e TARGET=http://backend jenkinsciinfra/confluence-cache

test-run:
	bundle exec rake spec

test-teardown:
	docker kill backend
	docker rm backend
	docker kill cc
	docker rm cc

test: test-setup test-run test-teardown

build/cache:
	mkdir -p build/cache/display
	echo "Hit confluence-cache" > build/cache/display/hello.html

clean:
	rm -rf cache