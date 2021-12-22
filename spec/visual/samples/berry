#
# single line comment
var a = "test" # inline comment
    # single line comment
#- multi line comment on single line -#
#- 
    comment line 1
    comment line 2
-#
#--------------------
 comment line 1
 comment line 2
--------------------#
#--------------------
# comment line 1
# comment line 2
#--------------------#

var hex_num = 0xFF
var int_num = 30, neg_integer = -23
var real_num = 3.1e-3

import string as mystring

class my_parent_class end

class my_static_class: my_parent_class
    var param1, param2
    static param = nil
    static param3 = "string"
    static param4 = 'string\n'
    static def func1(s)
        print(mystring.format("hello %s", str(s)))
        print(s)
    end
    def init(param)
        assert(param != nil)
        var temp1 = isinstance(param, map)
        var temp2 = type(param) == 'string' ? true : false
        super(self).init()
        self.param1 = param
        self.param2 = / a b c d e-> [
            int(a), 
            bool(b), 
            real(c), 
            range(3,6),
            (3..6),
            map(),
            {d: e},
            size(e)
            ]
    end
end



# anonymous function and closure
def count(x)
    var arr = []
    for i : 0 .. x
        arr.push(
            def (n) # loop variable cannot be used directly as free variable
                return def ()
                    return n * n
                end
            end (i) # define and call anonymous function
        )
    end
    return arr
end

for xx : count(6)
    print(xx()) # 0, 1, 4 ... n * n
end

return count


import time

c = time.clock()
do
    i = 0
    while i < 100000000
        i += 1
    end
end
print('while iteration 100000000 times', time.clock() - c, 's')

c = time.clock()
for i : 1 .. 100000000
end
print('for iteration 100000000  times', time.clock() - c, 's')

class node
    var v, l, r
    def init(v, l, r)
        self.v = v
        self.l = l
        self.r = r
    end
    def insert(v)
        if v < self.v
            if self.l
                self.l.insert(v)
            else
                self.l = node(v)
            end
        else
            if self.r
                self.r.insert(v)
            else
                self.r = node (v)
            end
        end
    end
    def sort(l)
        if (self.l) self.l.sort(l) end
        l.push(self.v)
        if (self.r) self.r.sort(l) end
    end
end

class btree
    var root
    def insert(v)
        if self.root
            self.root.insert(v)
        else
            self.root = node(v)
        end
    end
    def sort()
        var l = []
        if self.root
            self.root.sort(l)
        end
        return l
    end
end

var tree = btree()
tree.insert(-100)
tree.insert(5);
tree.insert(3);
tree.insert(9);
tree.insert(10);
tree.insert(10000000);
tree.insert(1);
tree.insert(-1);
tree.insert(-10);
print(tree.sort());

def cpi(n)
    i = 2
    pi = 3
    while i <= n
        term = 4.0 / (i * (i + 1) * (i + 2))
        if i % 4
            pi = pi + term
        else
            pi = pi - term
        end
        i = i + 2
    end
    return pi
end

print("pi =", cpi(100))

import debug

def test_func()
    try
        compile('def +() end')()
    except .. as e, v
        print('catch execption:', str(e) + ' >>>\n    ' + str(v))
        debug.traceback()
    end
end

test_func()

import time

def fib(x)
    if x <= 2
        return 1
    end
    return fib(x - 1) + fib(x - 2)
end

c = time.clock()
print("fib:", fib(38)) # minimum stack size: 78!!
print("time:", time.clock() - c, 's')

import time
import math

math.srand(time.time())
res = math.rand() % 100
max_test = 7
test = -1
idx = 1
print('Guess a number between 0 and 99. You have', max_test, 'chances.')
while test != res && idx <= max_test
    test = number(input(str(idx) + ': enter the number you guessed: '))
    if type(test) != 'int'
        print('This is not an integer. Continue!')
        continue
    elif test > res
        print('This number is too large.')
    elif test < res
        print('This number is too small.')
    end
    idx = idx + 1
end
if test == res
    print('You win!')
else
    print('You failed, the correct answer is', res)
end

import json
print(json.load('{"key": "value"}'))
print(json.dump({'test key': nil}))
print(json.dump({'key1': nil, 45: true}, 'format'))

# simple lambda example
print((/a b c-> a * b + c)(2, 3, 4))

# Y-Combinator and factorial functions
Y = /f-> (/x-> f(/n-> x(x)(n)))(/x-> f(/n-> x(x)(n)))
F = /f-> /x-> x ? f(x - 1) * x : 1
fact = Y(F)
print('fact(10) == ' .. fact(10))

import os

def scandir(path)
    print('path: ' + path)
    for name : os.listdir(path)
        var fullname = os.path.join(path, name)
        if os.path.isfile(fullname)
            print('file: ' + fullname)
        else
            print('path: ' + fullname)
            scandir(fullname)
        end
    end
end

scandir('.')

def qsort(data)
    # do once sort
    def once(left, right)
        var pivot = data[left] # use the 0th value as the pivot
        while left < right # check if sort is complete
            # put the value less than the pivot to the left
            while left < right && data[right] >= pivot
                right -= 1 # skip values greater than pivot
            end
            data[left] = data[right]
            # put the value greater than the pivot on the right
            while left < right && data[left] <= pivot
                left += 1 # skip values less than pivot
            end
            data[right] = data[left]
        end
        # now we have the index of the pivot, store it
        data[left] = pivot
        return left # return the index of the pivot
    end
    # recursive quick sort algorithm
    def _sort(left, right)
        if left < right # executed when the array is not empty
            var index = once(left, right) # get index of pivot for divide and conquer
            _sort(left, index - 1) # sort the data on the left
            _sort(index + 1, right) # sort the data on the right
        end
    end
    # start quick sort
    _sort(0, data.size() - 1)
    return data
end

import time, math
math.srand(time.time()) # sse system time as a random seed
data = []
# put 20 random numbers into the array
for i : 1 .. 20
    data.push(math.rand() % 100)
end
# sort and print
print(qsort(data))

do
    def ismult(msg)
        import string
        return string.split(msg, -5)[1] == '\'EOS\''
    end

    def multline(src, msg)
        if !ismult(msg)
            print('syntax_error: ' + msg)
            return
        end
        while true
            try
                src += '\n' + input('>> ')
                return compile(src)
            except 'syntax_error' as e, m
                if !ismult(m)
                    print('syntax_error: ' + m)
                    return
                end
            end
        end
    end

    def parse()
        var fun, src = input('> ')
        try
            fun = compile('return (' + src + ')')
        except 'syntax_error' as e, m
            try
                fun = compile(src)
            except 'syntax_error' as e, m
                fun = multline(src, m)
            end
        end
        return fun
    end

    def run(fun)
        try
            var res = fun()
            if res print(res) end
        except .. as e, m
            import debug
            print(e .. ': ' .. m)
            debug.traceback()
        end
    end

    def repl() 
        while true
            var fun = parse()
            if fun != nil
                run(fun)
            end
        end
    end

    print("Berry Berry REPL!")
    repl()
end

s = "This is a long string test. 0123456789 abcdefg ABCDEFG"
print(s)

a = .5
print(a)

import string as s

print(s.hex(0x45678ABCD, 16))

def bin(x, num)
    assert(type(x) == 'int', 'the type of \'x\' must be integer')
    # test the 'x' bits
    var bits = 1
    for i : 0 .. 62
        if x & (1 << 63 - i)
            bits = 64 - i
            break
        end
    end
    if type(num) == 'int' && num > 0 && num <= 64
        bits = bits < num ? num : bits
    end
    var result = ''
    bits -= 1
    for i : 0 .. bits
        result += x & (1 << (bits - i)) ? '1' : '0'
    end
    return result
end

print(bin(33))

import string

print(string.format('%.3d', 12))
print(string.format('%.3f', 12))
print(string.format('%20.7f', 14.5))
print(string.format('-- %-40s ---', 'this is a string format test'))
print(string.format('-- %40s ---', 'this is a string format test'))
