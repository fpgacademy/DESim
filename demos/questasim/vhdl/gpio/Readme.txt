In this demo:

-- GPIO[31:16] are outputs
-- GPIO[15: 0] are inputs
-- SW[1:0] are used to select how the input are modified
   before sending them to the output

To use:

1. Load the GPIO direction settings file <demo direcctory>/sim/gpio_setup.txt
2. Set GPIO[15:0] to any value
3. Set SW[1:0] to 
    -- 0 to make GPIO[31:16] = GPIO[15:0]
    -- 1 to make GPIO[23:16] = GPIO[15:8] | GPIO[7:0]
    -- 2 to make GPIO[23:16] = GPIO[15:8] & GPIO[7:0]
    -- 3 to make GPIO[23:16] = GPIO[15:8] ^ GPIO[7:0]
