# multimedia-utils

Utilities for manipulation of multimedia files, primarily dance videos

## Dependencies

* ffmpeg

## Batch Resizing

```sh
cd src
./resize_all_videos.sh --help
```

Note that the path specifications to input files must be provided between single quotes, if it contains wildcards characters, e.g.

```sh
./resize_all_videos.sh -i './blah/Zouk/Casa_do_Zouk2016/*.mp4' -o ~/Videos/Zouk/Casa_do_Zouk2016/
```

To force overwritting existing files use the -f option

```sh
./resize_all_videos.sh -i './blah/Zouk/Casa_do_Zouk2016/*.mp4' -f -o ~/Videos/Zouk/Casa_do_Zouk2016/
```

At the time of writing, resolution is reduced if the file resolution is more than 1024*780. The file is reencodded even if there is no reduction, as ffmpeg often improves on the size of the output of digital cameras, as an anecdotal observation.

## Batch File Renaming

Because filenames with blanks always throw a spanner in the works...

```sh
cd /path/to/video/directory/
find . -iname "* *.*" | while read f
do
  /path/to/multimedia-utils/src/remove_fname_spaces.sh "$f";
done
```

## Other information

```sh
ffprobe -v quiet -print_format flat -show_streams filename.mp4 | grep "\.width"
```

