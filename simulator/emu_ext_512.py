def emulate(input_file):
    with open(input_file, 'r') as f:
        mem = [int(x, 16) for x in f.readlines()]

    assert len(mem) == 512

    pc = 0
    acc = 0
    cf = 0

    for _ in range(cycles):
        ir = mem[pc]
        pc += 1
        op, arg = ir >> 6, ir & 0x3F

        # Display cpu state
        if cycles < 1000:
            print('pc,ir,acc,cf:', pc-1, hex(ir), acc, cf >> 8, sep='\t')

        # Run instruction
        if op == 0:
            acc = (acc | mem[mem[arg+256]+256]) ^ 0xFF
        elif op == 1:
            acc += mem[mem[arg+256]+256]
            cf = acc & 0x100
            acc &= 0xFF
        elif op == 2:
            mem[mem[arg+256]+256] = acc
        else:
            if ir == 0xFF:
                print(acc)
            elif cf == 0:
                pc = mem[arg+256]
            cf = 0

import sys
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python emu.py <input_file> <n_cycles>")
        sys.exit(1)

    try:
        cycles = int(sys.argv[2])
    except:
        cycles = 20

    input_file = sys.argv[1]
    
    emulate(input_file)
