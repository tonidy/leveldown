all: build-pre-gyp/leveldown.node build node_modules
	node-pre-gyp package testpackage

build-pre-gyp/leveldown.node build node_modules:
	JOBS=max npm install --build-from-source

clean:
	rm -rf node_modules build build-pre-gyp

.PHONY: clean
