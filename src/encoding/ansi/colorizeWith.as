package encoding.ansi
{
    /**
     * Colorize a string with an array of ANSI codes.
     * 
     * @param str The string to colorize.
     * @param c An array of ANSI codes.
     * @return A String with ANSI escape codes.
     */
    public function colorizeWith( str:String, c:Array = null ):String
    {
        var s:String = "";
        if( !c )
        {
            c = [];
        }

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