# Repository to build a codelabs base image

Inspired from the tutorial -> https://medium.com/@zarinlo/publish-technical-tutorials-in-google-codelab-format-b07ef76972cd

Dockerfile from -> https://github.com/jamesgroat/dockerfile/tree/master/golang-nodejs

Link to the [puppy.jpg](codelabs/assets/puppy.jpg) is from [https://en.wikipedia.org/wiki/Puppy#/media/File:Cara_de_quem_caiu_do_caminhão..._(cropped).jpg](Wikipedia)

## How to build and use

```sh
# To build
docker build -t codelabs
# To serve
docker run -it -p 8000:8000 --rm web
```
Open your browser and head to http://localhost:8000 and as part of the build, you can see an example bundled in.

> **Note:**
> Gulp by default serves on `127.0.0.1` which is not exposed outside the container. In the [opts.js](opts.js), overriden the host to enable binding to `0.0.0.0` and therefore its exposed.