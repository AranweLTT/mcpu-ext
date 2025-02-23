        org 320
zero    dcb 0
allone  dcb 255
one     dcb 1
two     dcb 2
subs    dcb 0
number  dcb 3

        org 0

        lda two

start   lda allone
        add allone
        sta subs

loop    lda number
inner   add subs
        jcs inner

        sub subs
        add allone
        jcc noprime

        lda subs
        add allone
        sta subs

        add number
        add allone
        jcs loop

        lda number

noprime lda number
        add two
        sta number

        jmp start
