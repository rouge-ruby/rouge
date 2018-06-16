def lex(code, lexer):
    """
    Lex ``code`` with ``lexer`` and return an iterable of tokens.
    """
    try:
        return lexer.get_tokens(code)
    except TypeError, err:
        if isinstance(err.args[0], str) and \
           'unbound method get_tokens' in err.args[0]:
            raise TypeError('lex() argument must be a lexer instance, '
                            'not a class')
        raise

# quotes in strings
def foo():
    "it's working"

def foo():
    'he said "hi"'

def foo():
    """it's working"""
    """he said "hi" """

def foo():
    '''he said "hi"'''
    '''it's working'''

# unicode docstrings
def foo():
    ur"""unicode-raw"""

def bar():
    u"""unicode"""

def baz():
    r'raw'

def zap():
    """docstring"""

# escaped characters in string literals
def baz():
    '\a\b\f\n\r\t\v\"\''
    '\N{DEGREE SIGN}'
    '\uaF09'
    '\UaaaaAF09'
    '\xaf\xAF\x09'
    '\007'

# escaped characters in raw strings
def baz():
    r'\a\b\f\n\r\t\v\"\''
    r'\N{DEGREE SIGN}'
    r'\uaF09'
    r'\UaaaaAF09'
    r'\xaf\xAF\x09'
    r'\007'

# line continuations
apple.filter(x, y)
apple.\
    filter(x, y)

1 \
    . \
    __str__

from os import path
from \
        os \
        import \
        path

import os.path as something

import \
        os.path \
        as \
        something

class \
 Spam:
    pass

class Spam: pass

class Spam(object):
    pass

class \
 Spam \
  (
   object
 ) \
 :
 pass


def \
 spam \
  ( \
  ) \
  : \
  pass

def the_word_strand():
    a = b.strip()
    a = strand
    b = band
    c = strand
    b = error
    c = stror
    c = string

py2_long = -123L

# Python 3

def test():
    raise Exception from foo

def exceptions():
    try:
        print("Hello")
    except Exception as e:
        print("Exception")

# PEP 515
integer_literals = [
    123, -1_2_0, 0, 00, 0_0_00, 0b1, 0B1_0, 0b_1, 0b00_0,
    0o1, 0O1_2, 0O_1, 0o00_0, 0x1, 0X1_2, 0x_1, 0x00_0
]
float_literals = [
    0., 1., 00., 0_00., 1_0_0., 0_1., .0,
    .1_2, 3.4_5, 1_2.3_4, 00_0.0_0_0, 0_0.1_2,
    0_1_2j, 0_00J, 1.2J, 0.1j, 1_0.J,
    0_00E+2_34_5, 0.e+1, 00_1.E-0_2, -100.e+20, 1e01,
    0_00E+2_34_5j, 0.e+1J, 00_1.E-0_2j, -100.e+20J 1e01j
]

# PEP 465
a = b @ c
x @= y
