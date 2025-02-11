In this demo:

-- GPIO[31:16] are outputs
-- GPIO[15: 0] are inputs
-- SW[1:0] are used to select how the input are modified
   before sending them to the output

To use:

1. In the Parallel Ports pane of the DESim GUI, click on the button Use Config File,
and load the GPIO direction settings file available in <demo directory>/sim/gpio_setup.txt
2. Set the input pins GPIO[15:0] to any value in the DESim GUI
3. Set SW[1:0] to 
    -- 0 to make GPIO[31:16] = GPIO[15:0]
    -- 1 to make GPIO[23:16] = GPIO[15:8] | GPIO[7:0]
    -- 2 to make GPIO[23:16] = GPIO[15:8] & GPIO[7:0]
    -- 3 to make GPIO[23:16] = GPIO[15:8] ^ GPIO[7:0]
