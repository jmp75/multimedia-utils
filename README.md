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

Getting the resolution information of a video file:

```sh
ffprobe -v quiet -print_format flat -show_streams filename.mp4 | grep "\.width"
```

```sh
./get_size_all_videos.sh ~/Videos/Dance/Original/Kizomba/ > ~/Videos/KizRes.txt
```

Command line tools to edit video metadata files; there may not be that many actually. Not sure easytag got things right. However mp4tags was handy; comes with the following Debian package:

```sh
sudo apt-get install mp4v2-utils
```

And particularly handy to write metadata in a bunch of files via wildcards:

```sh
my_dir=~/Videos/Dance/Zouk/Casa_do_Zouk2015
mp4tags -A "Casa do Zouk 2015" -c "Casa do Zouk 2015" -e "J-M" -g "Zouk" -i "movie" -l "Workshops at Casa do Zouk 2015" -m "Workshops at Casa do Zouk 2015" -O "Dance" -y 2015 ${my_dir}/*.mp4
```

Another tool of interest is AtomicParsley. It may be more actively maintained than mp4tags. Consider depending on feature needs



