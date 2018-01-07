# Tensorflow serving Docker

Building a docker container with tensorflow-serving from source (CPU distribution)

## Building

* `make build`: Builds the docker image. Note that this may take hours (2.5hr on a MBP 2017 i5) and make sure you have at least 10gb of disk space. **Important note: Make sure your docker daemon have at least 4GB to use (default is 2gb) otherwise compilation will fail**
