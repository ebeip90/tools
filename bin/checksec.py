#!/usr/bin/env python
"""
Re-write of Tobias Klein's checksec.sh in python
"""
from __future__      import print_function
from argparse        import ArgumentParser
from subprocess      import check_output, check_call
from distutils.spawn import find_executable as which
from os              import path, getuid, access, R_OK
from sys             import exit, stdout
from termcolor       import colored
from re              import search
from glob            import glob
import psutil

procs = psutil.get_process_list()

def is_proc(proc):      return filter(lambda x: x.name() == proc, procs)
def is_pid(pid):        return filter(lambda x: x.pid == pid, procs)
def align(text, n):     return text.ljust(n + 3 + len(red('')))
def can_read(p):        return access(p, R_OK)
def dir_exists(p):      return path.exists(p) and path.isdir(p)
def root_privs():       return getuid() == 0
def command_exists(c):  return which(c) or False
def isNumeric(n):       return n.isdigit()
def isString(n):        return n.isalpha()
def red(text):          return colored(text, 'red')
def green(text):        return colored(text, 'green')
def white(text):        return colored(text, 'white')
def grey(text):         return colored(text, 'grey')
def yellow(text):       return colored(text, 'yellow')
def die(text, code=1):
    print(text)
    exit(code)

def main():
    p = ArgumentParser(version='checksec 1.0')

    colors = p.add_mutually_exclusive_group()
    colors.add_argument('--color',    action='store_true',  default=True, help='enable color; requires termcolor')
    colors.add_argument('--no-color', action='store_false', dest='color')

    g = p.add_mutually_exclusive_group()
    g.add_argument('--dir', nargs='*', type=arg_directory)
    g.add_argument('--proc', nargs='*', type=args_pid_or_proc, metavar='pid|name', default=[])
    g.add_argument('--proc-all', action='store_true')
    g.add_argument('--proc-libs', type=args_pid_or_proc, metavar='pid|name')
    g.add_argument('--kernel', action='store_true')
    g.add_argument('--fortify', metavar='file|pid|name|dir')
    g.add_argument('--fortify-file', type=arg_file, metavar='file')
    g.add_argument('--fortify-proc', type=args_pid_or_proc, metavar='pid|name')
    g.add_argument('--file', metavar='file', nargs='*', dest='files_opt', type=arg_file, default=[])
    g.add_argument('input', metavar='file|proc|pid|dir', nargs='*', default=[], type=arg_file)

    args = p.parse_args()
    print (args)

    # Disable coloring
    if not args.color or not (stdout.isatty() or args.color):
        global colored
        colored = lambda x,y: x

    # Resolution order
    # - File
    # - Directory
    # - Process name
    # - PID
    dump = args.proc + args.file + args.input
    fortify = args.

    for f in args.files_opt + args.file:
        filecheck(f)

    for d in args.dir:
        for f in glob(path.join(d,'*')):
            filecheck(f)

    for p in args.proc:
        procheck(f)

class Result:
    pad = 3
    @classmethod
    def get_title(clazz):   return clazz.title.ljust(clazz.width + Result.pad)
    def __str__(self):      return self.result.ljust(self.width  + Result.pad)
    def __init__(self, fn): self.result = self.check(fn)

class RELRO(Result):
    yes     = green('Full RELRO')
    partial = green('Partial RELRO')
    no      = red('No RELRO')
    title   = white('RELRO')
    width   = max(map(len, [title, yes, no, partial]))

    def check(self, fn):
        relro = 'GNU_RELRO' in check_output(['readelf','-l',fn])
        full  = 'BIND_NOW'  in check_output(['readelf','-d',fn])

        if relro and full:  return RELRO.yes
        elif relro:         return RELRO.partial
        else:               return RELRO.no

class Canary(Result):
    yes   = green('Canary found')
    no    = red('No canary found')
    nosym = red('No symbol table')
    title = white('STACK CANARY')
    width = max(map(len, [title, yes, no, nosym]))

    def check(self, fn):
        output  = check_output(['readelf','-s',fn])
        symbols = 'Symbol table' in output
        canary  = '__stack_chk_fail' in output

        if canary:    return Canary.yes
        elif symbols: return Canary.no
        else:         return Canary.nosym

class NX(Result):
    yes   = green('NX enabled')
    no    = red('NX disabled')
    title = white('NX')
    width = max(map(len, [title, yes, no]))

    def check(self, fn):
        output = check_output(['readelf','-W','-l',fn])

        for line in output.splitlines():
            if 'GNU_STACK' in line and 'RWE' in line:
                return NX.no

        return NX.yes

class PAX(NX):
    yes      = green('PaX enabled')
    aslr     = yellow('PaX ASLR only')
    mprot    = yellow('PaX mprot off')
    nomprot  = yellow('PaX ASLR off')
    nx       = yellow('PaX NX only')
    no       = red('PaX disabled')
    title    = white('NX/PaX')

    def check(self, fn):
        status = fn.replace('exe','status')

        try:    output = file(status,'r').read()
        except: output = ''

        if 'PaX:' not in output:
            return NX.check(self, fn)
        else:
            pax_line = next(l for l in output.splitlines() if 'PaX:' in l)
            pax = pax_line[6:11]

            nx    = 'PS' in pax
            mprot = 'M'  in pax
            aslr  = 'R'  in pax

            if nx:
                if aslr and mprot:  return PAX.yes
                elif alsr:          return PAX.nomprot
                elif mprot:         return PAX.noaslr
                else:               return PAX.nx
            elif aslr:              return PAX.aslr
            else:                   return PAX.no

class PIE(Result):
    yes     = green('PIE enabled')
    no      = red('No PIE')
    dso     = yellow('DSO')
    title   = white('PIE')
    width   = max(map(len, [title, yes, no, dso]))

    def check(self, fn):
        headers = check_output(['readelf','-h',fn])
        disasm  = check_output(['readelf','-d',fn])

        if search('Type: *EXEC', headers): return PIE.no
        if '(DEBUG)' not in disasm:        return PIEdso
        return PIE.yes

class RPATH(Result):
    yes   = red('RPATH')
    no    = green('No RPATH')
    title = white('RPATH')
    width = max(map(len, [title, yes, no]))

    def check(self, fn):
        disasm  = check_output(['readelf','-d',fn])
        return RPATH.yes if 'rpath' in disasm else RPATH.no

class RUNPATH(Result):
    yes   = red('RUNPATH')
    no    = green('No RUNPATH')
    title = white('RUNPATH')
    width = max(map(len, [title, yes, no]))

    def check(self, fn):
        disasm  = check_output(['readelf','-d',fn])
        return RUNPATH.yes if 'runpath' in disasm else RUNPATH.no

class FILE(Result):
    title = white('FILE')
    width = 0
    def __init__(self, fn): self.fn = fn
    def __str__(self):      return self.fn
    def check(self, fn):
        return grey(fn)

class PID(Result):
    title = white('PID')
    width = 0
    def __init__(self, fn): self.fn = fn
    def __str__(self):      return self.fn
    def check(self, fn):
        return grey(fn)

def filecheck(f):
    checks = [RELRO, Canary, NX, PIE, RPATH, RUNPATH, FILE]

    if filecheck.banner is False:
        filecheck.banner = True
        print(''.join((c.get_title() for c in checks)))

    print(''.join(map(str,[check(f) for check in checks])))

filecheck.banner = False

def proccheck(p):
    checks = [FILE,PID,RELRO,Canary,PAX, PIE]

    if proccheck.banner is False:
        proccheck.banner = True
        print(''.join((c.get_title() for c in checks)))

    print(''.join(map(str,[check(p) for check in checks])))

proccheck.banner = False

if __name__ == '__main__':
    main()