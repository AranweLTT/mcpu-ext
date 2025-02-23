def valof(arg):
    if arg in syms:
        arg = syms[arg]
    try:
        return int(arg)
    except:
        return 0

# pseudo ops
def org(arg):
    global pc
    pc = valof(arg)
def dcb(arg):
    global pc
    mem[pc] = valof(arg)
    pc += 1

# instruction set using indirect addressing
def nor(arg): dcb((valof(arg) & 0x3F) | 0x00)   # [00] akk = akk nor data
def add(arg): dcb((valof(arg) & 0x3F) | 0x40)   # [01] akk = akk + data
def sta(arg): dcb((valof(arg) & 0x3F) | 0x80)   # [10] store
def jcc(arg): dcb((valof(arg) & 0x3F) | 0xC0)   # [11] jmp if carry set

# combined instructions
def jmp(arg): jcc(arg); jcc(arg)
def lda(arg): nor('allone'); add(arg)
def sub(arg): nor('zero'); add(arg); add('one')
def out(arg): dcb(0xFF)
def jcs(arg):
    if str(pc+2) not in syms: syms[str(pc+2)] = pc+2
    jcc(str(pc+2))
    jcc(arg)

def build_vector_table():
    global pc, vector_table
    assert len(syms) < 64, "More than 64 elements in vector table ({n_elements} elements)".format(n_elements=len(syms))
    vector_table = {}
    pc = 0
    for sym in syms:
        vector_table[sym] = pc
        mem[pc+256] = syms[sym]%256
        pc += 1

def assemble(input_file, output_file):
    # Load assembly file
    with open(input_file, 'r') as f:
        code = f.readlines()
    
    global syms, pc, mem
    syms = {}
    mem = 512 * [0]
    
    # 2-pass assembly
    for npass in range(2):
        pc = 0
        for line in code:
            fields = line.split()
            assert pc < 512, 'Program counter overflow : {}'.format(line)
            assert len(fields) < 4, 'Syntax error : {}'.format(line)
            if len(fields) > 0 and line.lstrip()[0] != ';':
                # Process labels
                if line.lstrip() == line:
                    if npass == 0:
                        syms[fields[0]] = pc
                    del fields[:1]
                # Assemble instruction
                f = globals()[fields[0]]
                f(fields[1])

        # Build vector table after first pass
        if npass == 0:
            build_vector_table()
            # Debug output
            print(vector_table)
            print(syms)
            syms = vector_table

    # Write generated machine code to output file
    with open(output_file, 'w') as f:
        s = '\n'
        f.write(s.join([format(x, '02X') for x in mem]))

import sys
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python assembler.py <input_file> <output_file>")
        sys.exit(1)

    # Get arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    # Run assembler
    assemble(input_file, output_file)
