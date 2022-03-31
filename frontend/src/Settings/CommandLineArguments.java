// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package Settings;

import java.util.HashMap;
import java.util.Map;

/**
 * This class parses and holds command line arguments.
 */
public class CommandLineArguments {

    // <editor-fold desc="Constants">
    // List of valid command line arguments
    public final static String SIMULATOR_PATH  = "simulator-path";
    public final static String LICENSE_FILE_PATH  = "license-file-path";
    // Deprecating the "modelsim-path" in favor of "simulator-path";
    public final static String MODELSIM_PATH  = "modelsim-path";
    // List of valid options
    public final static String TRUE  = "true";
    public final static String FALSE = "false";
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Private Variables">
    private final Map<String, String> commandLineArguments = new HashMap<String, String>();
    // </editor-fold>

    // <editor-fold desc="Constructors">
    /**
     * Construct a new CommandLineArguments object for the given args list.
     * Command line arguments may start with one or two '-'.
     *
     * @param args command line arguments
     */
    public CommandLineArguments( String[] args )
    {
        String[] flag_option;
        for( String arg : args )
        {
            flag_option = getFlagAndOption( arg );
            if( (flag_option != null) && (flag_option.length > 1) )
            {
                commandLineArguments.put( flag_option[0], flag_option[1].replace("\\", "/") );
            }
        }
    }
    // </editor-fold>

    // <editor-fold desc="Methods">
    /**
     * Get the value of the named command line argument as a string.
     *
     * @param cmdLineArg one of the static strings listed above
     * @param defaultValue the default string to return if named command line argument is not found
     * @return the command line argument string if exist, else, returns defaultValue
     */
    public String getCmdLineArg(String cmdLineArg, String defaultValue)
    {
        return (commandLineArguments != null) ? commandLineArguments.getOrDefault(cmdLineArg, defaultValue) : defaultValue;
    }

    /**
     * Get the value of the named command line argument as a boolean.
     *
     * @param cmdLineArg one of the static strings listed above
     * @param defaultValue the default boolean to return if named command line argument is not found
     * @return the command line argument as a boolean if exist, else, returns defaultValue
     */
    public boolean getCmdLineArg(String cmdLineArg, boolean defaultValue)
    {
        boolean ret = defaultValue;
        if (cmdLineArg != null) {
            String value = commandLineArguments.get(cmdLineArg);
            if (value != null) {
                ret = convertToBoolean(value);
            }
        }
        return ret;
    }

    // <editor-fold defaultstate="collapsed" desc="Private Methods">
    /**
     * Given a single command line argument, return the flag and option where
     * one of the following format is used: -flag or --flag=option
     *
     * ToDo: This method return null when it encounters on improperly formatted
     * flag. Maybe it should inform the user when this occurs.
     *
     * @param arg the command line argument to be parsed
     * @return  a list of two strings. [0] contains the flag, [1] Contains the
     *          option (the '=' is not included in either).
     *          Returns null if the argument is not formatted correctly
     */
    private String[] getFlagAndOption( String arg )
    {
        String[] ret = new String[2];

        // Since a flag has '-' or '--' prefixed, the length must be least 2
        if((arg.length() < 2) || (arg.charAt(0) != '-'))
            return null;

        // Check for '-flag' format
        if( arg.charAt(1) != '-' )
        {
            // Argmuent is of the '-flag' format
            /* substring(start, end) -> start is inclusive, end is exclusive */
            ret[0] = arg.substring( 1);
            // Since the flag is present the option must be true
            ret[1] = TRUE;

            return ret;
        }

        // Check for '--flag=option' format
        // Argument (with '--') must contain a '=' sign (--flag=option)
        if( !arg.contains("=") )
            return null;

        // Argmuent is of the '--flag=option' format
        /* substring(start, end) -> start is inclusive, end is exclusive */
        //From the start of the string, to the char before the '='
        ret[0] = arg.substring( 2, arg.indexOf('=') );

        //From the character after the '=' to the end of the string
        ret[1] = arg.substring( arg.indexOf('=') + 1 );

        return ret;
    }

    /**
     * Convert a string value to a boolean. '', 'no', 'false' and '0'
     * (Case insensitive) are all false, ANYTHING else is true.
     *
     * @param value the String value to be converted to a boolean
     * @return boolean converted from the String
     */
    public static boolean convertToBoolean(String value) {
        return !("".equalsIgnoreCase(value) || "no".equalsIgnoreCase(value) || "false".equalsIgnoreCase(value) || "0".equalsIgnoreCase(value));
    }
    // </editor-fold>
    // </editor-fold>
}


