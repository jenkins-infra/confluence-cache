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
test: image cache
	# start the fresh backend
	@docker kill backend > /dev/null 2>&1
	@docker rm backend > /dev/null 2>&1
	rm -rf build/wwwroot > /dev/null || true
	mkdir build
	cp -R test/wwwroot build/
	docker run -d --name=backend -v `pwd`/build/wwwroot:/usr/share/nginx/html:ro nginx

	# start the cache
	@docker kill cc > /dev/null 2>&1 || true
	docker run --rm -p 8081:8080 -t -i --name=cc -v `pwd`/cache:/cache --link backend:backend jenkinsciinfra/confluence-cache

	# run the test
	

cache:
	mkdir -p cache/display
	echo "Hit confluence-cache" > cache/display/hello.html

clean:
	rm -rf cache