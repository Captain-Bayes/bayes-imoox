#/usr/bin/env bash

cd notebooks
julia -e 'import PlutoSliderServer; PlutoSliderServer.run_directory("."; SliderServer_port=1234, SliderServer_host="0.0.0.0")'
