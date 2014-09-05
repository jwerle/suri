suri(1)
=====

Set and get application URI schemes for OS X

## install

```sh
$ clib install jwerle/suri
```

## usage

`suri(1)` will set or get an application uri.

```sh
usage: suri [-hV] <scheme> <application>
```

## example

You can get an application by a URI by simply just prodiving the uri as
an argument.

```sh
$ suri spotify
file:///Applications/Spotify.app/
```

```sh
$ suri mailto
file:///Applications/Mail.app/
```

You can set an applications URI by prodiving a `scheme` and a
`application` argument to `suri(1)`.


```sh
$ suri slack Slack
Setting scheme `slack' for application bundle `com.tinyspeck.slackmacgap'
$ open slack:
```

## license

MIT

