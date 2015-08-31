package encoding.ansi
{
    /**
     * Colorize a string with a variable arguments of ANSI codes.
     * 
     * <p>
     * Based on <a href="http://en.wikipedia.org/wiki/ANSI_escape_code">ANSI escape code</a>
     * here how it works:
     * </p>
     * 
     * <p>
     * To colorize text on a terminal You apply an ANSI escape code <code>\x1b[</code> (ESC)
     * followed by a number and letter, before the text you want to colorize.
     * for ex: <code>ESC 1 m</code>.
     * 
     * If you want to display "hello world" in yellow then you do
     * <code>ESC 33m + "hello world" + ESC 0m</code>
     * you need to end the sequence with the <code>reset</code> escape code
     * so the following text will not be colorized in yellow.
     * 
     * You can use more than one escape code in chain to apply different "effects"
     * at the same time, for example if you want to display the text in bold and yellow and blinking
     * you will apply <code>ESC 1m + ESC 33m + ESC 5m + "hello world" + ESC 0m</code>.
     * </p>
     * 
     * @example Usage
     * <listing>
     * import encoding.ansi.&#42;;
     * 
     * var ansi:String = colorize( "hello world", controls.bold, colors.yellow, controls.flash );
     * trace( ansi );
     * </listing>
     * 
     * @param str The string to colorize.
     * @param c Variable arguments of ANSI codes.
     * @return A String with ANSI escape codes.
     */
    public function colorize( str:String, ...c ):String
    {
        var s:String = "";
        if( c.length > 0 )
        {
            for( var i:uint = 0; i < c.length; i++ )
            {
                s += c[i] ? c[i]: "";
            }

            return s + str + controls.reset;
        }

        return str;
    }
}