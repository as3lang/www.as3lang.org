package encoding.ansi
{
    /**
     * ANSI controls escape codes.
     * 
     * <p>
     * When you apply an ANSI escape code, the rule is to end it
     * with the <code>reset</code> control.
     * </p>
     */
    public class controls
    {
        
        /** Reset control */
        public static var reset:String     = "\x1b[0m";
        /** Bold control */
        public static var bold:String      = "\x1b[1m";
        /** Unbderline control */
        public static var underline:String = "\x1b[4m";
        /** Flash control */
        public static var flash:String     = "\x1b[5m";
        /** Invert control */
        public static var invert:String    = "\x1b[7m";
        /** Conceal control */
        public static var conceal:String   = "\x1b[8m";

        public function controls()
        {
            super();
        }
    }
}