<!-- Template from https://github.com/othneildrew/Best-README-Template -->
<a id="readme-top"></a>


<!-- PROJECT LOGO -->
<div align="center">
  <h2 align="center">MCPU Extended Adressing</h2>

  <p align="center">
    This is a indirect memory adressing version of the <a href="https://github.com/cpldcpu/MCPU">MCPU</a> 8 bit CPU, and total overhauled VHDL implementation for explicit control lines logic expressions.
    <br />
  </p>
</div>


[![Github][github]][github-url]
![Python][python]

Original MCPU: [https://github.com/cpldcpu/MCPU](https://github.com/cpldcpu/MCPU)

<!-- TABLE OF CONTENTS -->
<summary>Table of Contents</summary>
<ol>
  <li><a href="#architecture">Architecture</a></li>
  <li>
    <a href="#getting-started">Getting started</a>
    <ul>
      <li><a href="#python-assembler">Python assembler</a></li>
      <li><a href="#using-the-python-simulator">Using the python simulator</a></li>
    </ul>
  </li>
  <li><a href="#licence">Licence</a></li>
</ol>


<!-- ARCHITECTURE -->
## Architecture
<u>Instruction set:</u>
| Mnemonic | Opcode   | Description                                      |
|----------|----------|--------------------------------------------------|
| NOR      | 00AAAAAA | Accu = Accu NOR mem[mem[AAAAAA]]                 |
| ADD      | 01AAAAAA | Accu = Accu + mem[mem[AAAAAA]], update carry     |
| STA      | 10AAAAAA | mem[mem[AAAAAA]] = Accu                          |
| JCC      | 11DDDDDD | Set PC to DDDDDD when carry = 0, clear carry     |


<u>Memory map:</u>
| Address |          Area          |   Size    |
|:-------:|:----------------------:|:---------:|
| 0x0000  |     Program memory     | 256 bytes |
| 0x00FF  |                        |           |
| 0x0100  |      Vector table      | 64 bytes  |
| 0x010F  |                        |           |
| 0x0110  | General purpose memory | 192 bytes |
| 0x01FF  |                        |           |


<!-- GETTING STARTED -->
## Getting started
Start by cloning this repository.
```sh
git clone 'https://github.com/AranweLTT/mcpu-ext.git'
```
No specific python requirements are needed.

### Python assembler
```sh
python assembler.py <input_file> <output_file>
```

### Using the Python simulator

```sh
python emu.py <input_file> <n_cycles>
```
The input file is the compiled program (.obj) file, not the assembly code.

The output for the first 14 cycles of the prime test program should be as follows (assembly listing in [assembler/prime.asm](assembler/prime.asm)) :

``` asm
pc,ir,acc,cf:	00	0x01	  0	0
pc,ir,acc,cf:	01	0x43	  0	0
pc,ir,acc,cf:	02	0x01	  2	0
pc,ir,acc,cf:	03	0x41	  0	0
pc,ir,acc,cf:	04	0x41	255	0
pc,ir,acc,cf:	05	0x84	254	1
pc,ir,acc,cf:	06	0x01	254	1
pc,ir,acc,cf:	07	0x45	  0	1
pc,ir,acc,cf:	08	0x44	  3	0
pc,ir,acc,cf:	09	0xc9	  1	1
pc,ir,acc,cf:	10	0xc8	  1	0
pc,ir,acc,cf:	08	0x44	  1	0
pc,ir,acc,cf:	09	0xc9	255	0
pc,ir,acc,cf:	11	0x00	255	0
pc,ir,acc,cf:	12	0x44	  0	0
pc,ir,acc,cf:	13	0x42	254	0
```

A special feature of the simulator is that instruction 0xFF will print out the content of the accumulator. Therefore if the program is long, and the number of cycles greater than 100, this will be the only output.

<!-- LICENCE -->
## Licence

MCPU original Licence
```
SMAL license:

/* smal32.c   language: C
   copyright 1996 by Douglas W. Jones
                     University of Iowa
                     Iowa City, Iowa  52242
                     USA

   Permission is granted to make copies of this program for any purpose,
   provided that the above copyright notice is preserved in the copy, and
   provided that the copy is not made for direct commercial advantage.

   Note: This software was developed with no outside funding.  If you find
   it useful, and especially if you find it useful in a profit making
   environment, please consider making a contribution to the University
   of Iowa Department of Computer Science in care of:

                     The University of Iowa Foundation
                     Alumni Center
                     University of Iowa
                     Iowa City, Iowa  52242
                     USA
*/
```

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[python]: images/badge/python.svg
[github]: images/badge/github.svg
[github-url]: https://github.com
