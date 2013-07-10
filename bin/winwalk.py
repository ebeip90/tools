#!/usr/bin/env python

import os, sys, shutil, argparse

from os.path import relpath, join, splitext, exists

args = {}

def callback(args, dir, files):
    rel     = relpath(dir, args['src'])
    dstpath = join(args['dst'], rel)

    for f in files:
        if splitext(f)[-1][1:] in args['ext']:

            srcpath = join(dir, f)  

            if not exists(dstpath):
                os.makedirs(dstpath)

            print join(rel, f)
            shutil.copy(srcpath, dstpath)


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