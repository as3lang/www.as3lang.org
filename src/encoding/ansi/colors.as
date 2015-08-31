package encoding.ansi
{
    import flash.utils.describeType;
    import shell.Program;
    
    /**
     * ANSI colors escape codes.
     */
    public class colors
    {

        //colors
        /** Black color */
        public static var black:String   = "\x1b[30m";
        /** Red color */
        public static var red:String     = "\x1b[31m";
        /** Green color */
        public static var green:String   = "\x1b[32m";
        /** Yellow color */
        public static var yellow:String  = "\x1b[33m";
        /** Blue color */
        public static var blue:String    = "\x1b[34m";
        /** Magenta color */
        public static var magenta:String = "\x1b[35m";
        /** Cyan color */
        public static var cyan:String    = "\x1b[36m";
        /** White color */
        public static var white:String   = "\x1b[37m";

        //extra colors
        /** Bright Black color */
        public static var brightBlack:String   = "\x1b[90m";
        /** Bright Red color */
        public static var brightRed:String     = "\x1b[91m";
        /** Bright Green color */
        public static var brightGreen:String   = "\x1b[92m";
        /** Bright Yellow color */
        public static var brightYellow:String  = "\x1b[93m";
        /** Bright Blue color */
        public static var brightBlue:String    = "\x1b[94m";
        /** Bright Magenta color */
        public static var brightMagenta:String = "\x1b[95m";
        /** Bright Cyan color */
        public static var brightCyan:String    = "\x1b[96m";
        /** Bright White color */
        public static var brightWhite:String   = "\x1b[97m";

        /**
         * Returns an array of all colors.
         */
        public static function all():Array
        {
            var _class:XML = describeType( colors );
            
            var categories:Array = [];
            for each( var member:XML in _class.variable )
            {
                categories.push( member.@name );
            }
            Program.disposeXML( _class );
            
            return categories;
        }

        public function colors()
        {
            super();
        }

    }
}