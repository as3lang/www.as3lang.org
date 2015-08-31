package encoding.ansi
{
    import flash.utils.describeType;
    import shell.Program;
    
    /**
     * ANSI background colors escape codes.
     */
    public class backgrounds
    {

        //backgrounds
        /** Black background color */
        public static var black:String   = "\x1b[40m";
        /** Red background color */
        public static var red:String     = "\x1b[41m";
        /** Green background color */
        public static var green:String   = "\x1b[42m";
        /** Yellow background color */
        public static var yellow:String  = "\x1b[43m";
        /** Blue background color */
        public static var blue:String    = "\x1b[44m";
        /** Magenta background color */
        public static var magenta:String = "\x1b[45m";
        /** Cyan background color */
        public static var cyan:String    = "\x1b[46m";
        /** White background color */
        public static var white:String   = "\x1b[47m";

        //extra backgrounds
        /** Bright Black background color */
        public static var brightBlack:String   = "\x1b[100m";
        /** Bright Red background color */
        public static var brightRed:String     = "\x1b[101m";
        /** Bright Green background color */
        public static var brightGreen:String   = "\x1b[102m";
        /** Bright Yellow background color */
        public static var brightYellow:String  = "\x1b[103m";
        /** Bright Blue background color */
        public static var brightBlue:String    = "\x1b[104m";
        /** Bright Magenta background color */
        public static var brightMagenta:String = "\x1b[105m";
        /** Bright Cyan background color */
        public static var brightCyan:String    = "\x1b[106m";
        /** Bright White background color */
        public static var brightWhite:String   = "\x1b[107m";

        /**
         * Returns an array of all background colors.
         */
        public static function all():Array
        {
            var _class:XML = describeType( backgrounds );
            
            var categories:Array = [];
            for each( var member:XML in _class.variable )
            {
                categories.push( member.@name );
            }
            Program.disposeXML( _class );
            
            return categories;
        }

        public function backgrounds()
        {
            super();
        }
    }
}