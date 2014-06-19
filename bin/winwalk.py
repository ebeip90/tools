#!/usr/bin/env python

import os, sys, shutil, argparse, hashlib

from os.path import relpath, join, splitext, exists

args   = {}
hashes = []

def hashfile(filename, blocksize=65536):
    hasher = hashlib.md5()
    afile = open(filename)
    buf = afile.read(blocksize)
    while len(buf) > 0:
        hasher.update(buf)
        buf = afile.read(blocksize)
    return hasher.hexdigest()

def callback(args, dir, files):
    rel     = relpath(dir, args['src'])
    dstpath = join(args['dst'], rel)

    for f in files:
        if splitext(f)[-1][1:] in args['ext']:

            srcpath = join(dir, f)

            if not exists(dstpath):
                os.makedirs(dstpath)

            try: md5 = hashfile(srcpath)
            except:
                print "Couldnt open %r, skipping" % srcpath
                continue

            if md5 not in hashes:
                shutil.copy(srcpath, dstpath)
                hashes.append(md5)
            else:
                print join(rel, f)


def main(src, dst, extensions):
    os.path.walk(src, callback, args)

if __name__ == '__main__':
    p = argparse.ArgumentParser()

    p.add_argument('src', help=
        """
        Source directory to scan, e.g. Z:\\windows\\system32
        """
    )
    p.add_argument('dst', help=
        """
        Where to store the files
        """
    )
    p.add_argument('-e', '--ext', nargs='*', action='append', default=['sys','exe','dll','drv','ocx'], help=
        """
        File extensions to grab.  Defaults: %(default)s
        """
    )

    args = vars(p.parse_args())

    main(args['src'], args['dst'], args['ext'])