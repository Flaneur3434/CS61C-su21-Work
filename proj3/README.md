# CS61CPU

Look ma, I made a CPU! Here's what I did:

# PART A

## ALU

- To create the ALU, I create subcircuit for all arithmetic functions.

- I then used a multiplexer and the ALUSel to select which subcircuit's
  result I should use.

- The sub circuits all run in parallel and I choose the result I
  want at the end with a multiplexer.

## Regfile

- I created 32 registers.  

- I had 2 demultiplexers.  

	- One was used to select which registers would get written too.

	- The other was used to flip the write bit on the register

- I had 2 multiplexers.

	 - Both were used to select which registers to read from.

## Addi

- I hard coded all the values so only addi would work.

Part B will be hard ...

# Part B

## Control Logic

- My control logic consisted of many many many "and" and "or" gates.

- My basic structure was to first decode the instruction to create a bunch of
  control flags to use later in my control logic.

- I then used those control flags (with the "and" and "or" gates) to set the actual
  control logic outputs

## Branch Comparator

- Used to comparators

    - One was unsigned and the other was signed

- Used the BrUn control bit plus a multiplexer to determine which comparator result to use

## CPU

- My CPU circuity was very straight forward excluding the store masks

### Store Masks

- To create the store masks, I took the 32-bit offset from the ALU and bit-extended it to be 2-bits

- These last 2-bits told me the how many shifts I had to preform on the original mask

    - Ex: if offset was 0x0002, I would have to move the original byte mask (0x1) 2 bits

- I thought this was a very clever way to make the masks

- I then used the func3 section of the instruction as my select bit from a 
  multiplexer to choose with mask to send to the DMEM WRITE_ENABLE control bit

### Pipeline

- I used 3 registers to pipeline my cpu

    - One register to store the program counter
    
    - One register to store the instruction

    - And the last register was used to hold the PCSel bit

- I had to store the PCSel bit because of nops

    - To select if I needed to nop an instruction (for taken branches or jumps), the PCSel bit
      would be turned on.

    - So I stored the PCSel bit from the previous instruction and used that as a select bit for a multiplexer
      to choose between the regular instrution being passed on to the pipeline or to pass a nop down the pipeline

    - By doing this, I did not have to change any circuity to implement nops


## Advantages and Disadvantages

#### Advantage

- I would say an advantage of my cpu design is that its very readable and easy to
  understand

- I added many comments to help assist the readability of the circuit

#### Disadvantage

- Its not very optimized
	
	- I sacrificed speed for readability and ease of implementation
	
	- I used comparators in many places

## Best / Worst Bug

#### Best

- The parts I struggled to implement was the memory instructions, especially the
store instructions
	 - I had trouble understanding what the bit masks were for at first

	 - I originally thought the masks were used to identify the position the store instruction
	  writes to in memory (which is wrong)

	 - I fixed it by opening the mem.circ file and simulating the circuit with a unit test

- This bug helped me understand how the memory works in the logisim cpu simulator 

#### Worst

- Probably the worst bugs were the ones that could have been
  easily solved by reading the library reference or the spec
  more carefully

- That feeling when you find out your circuit doesn't follow the spec ...
