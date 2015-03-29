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
	@docker inspect mock-webapp > /dev/null 2>&1 || docker run -d --name=mock-webapp -P -i -t jenkinsciinfra/mock-webapp
	@docker kill cc > /dev/null 2>&1 || true
	docker run --rm -p 8081:8080 -t -i --name=cc -v `pwd`/cache:/cache --link mock-webapp:backend jenkinsciinfra/confluence-cache

cache:
	mkdir -p cache/display
	echo "Hit confluence-cache" > cache/display/hello.html

clean:
	rm -rf cache