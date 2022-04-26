# boomstream.com video downloader

The script downloads videos from boomstream.com streaming service.

## Encryption algorithm description

The service stores video chunks encrypted using HLS AES-128 algorithm. In order to decrypt
them AES initialization vector and 128-bit key are required. Initialization vector is encrypted
in the first part of `#EXT-X-MEDIA-READY` variable which is contained in m3u8 playlist using a
simple XOR operation. The key is supposed to be recevied via HTTP using a URL that starts with
`https://play.boomstream.com/api/process/` and contains a long hex key that can be computed
using session token and the second part of `#EXT-X-MEDIA-READY`.

## Usage

Command line arguments:

`--entity` (required) - value can be found in URL like https://play.boomstream.com/TiAR7aDs  
`--pin` - required only for content protected with a pin code  
`--resolution` - video resolution. If not specified, the video with a highest one will be downloaded  
`--ffmpeg-path` - location of the ffmpeg binary, used if ffmpeg not available in the environment  
`--ffprobe-path` - location of the ffprobe binary, used if ffprobe not available in the environment

Excample:

```bash
--entity TiAR7aDs --pin 123-456-789 --resolution "640x360" --ffmpeg-path "C:\ffmpeg\bin\ffmpeg.exe" --ffprobe-path "C:\ffmpeg\bin\ffprobe.exe"
```

## Requirements

* cryptography
* python-requests
* lxml
* ffmpeg (for enconding ts -> mp4)

As the script was written and tested in Linux (specifically Ubuntu 18.04.4 LTS) it uses GNU/Linux
