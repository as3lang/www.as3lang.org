package net.http
{
    
    /**
     * The HTTP Header class.
     */ 
    public class HttpHeader
    {
        
        public static const ACCEPT:String            = "Accept";
        public static const ACCEPT_ENCODING:String   = "Accept-Encoding";
        public static const CONTENT_TYPE:String      = "Content-Type";
        public static const CONTENT_LENGTH:String    = "Content-Length";
        public static const CONTENT_ENCODING:String  = "Content-Encoding";
        public static const HOST:String              = "Host";
        public static const ETAG:String              = "ETag";
        public static const CONNECTION:String        = "Connection";
        public static const KEEP_ALIVE:String        = "Keep-Alive";
        public static const CLOSE:String             = "Close";
        
        public static const USER_AGENT:String        = "User-Agent";
        
        public static const TRANSFER_ENCODING:String = "Transfer-Encoding";
        public static const CHUNKED:String           = "chunked";
        public static const IDENTITY:String          = "identity";
        public static const COMPRESS:String          = "compress";
        public static const DEFLATE:String           = "deflate";
        
        /**
         * Helper to format the header name in CamelCase.
         * 
         * <p>
         * "hello world", "hello-world, "HELLO_WORLD" will all
         * return "Hello-World".
         * </p> 
         */
        public static function formatName( name:String ):String
        {
            var str:String = "";
            var capitalize:Boolean = true;
            
            var i:uint;
            var len:uint = name.length;
            var c:String;
            for( i = 0; i < len; i++ )
            {
                c = name.charAt( i );
                
                if( (c == " ") || (c == "_") )
                {
                    c = "-";
                }
                
                if( c == "-" )
                {
                    capitalize = true;
                    str += c;
                    continue;
                }
                
                if( capitalize )
                {
                    c = c.toUpperCase();
                    capitalize = false;
                }
                else
                {
                    c = c.toLowerCase();
                }
                
                str += c;
            }
            
            return str;
        }
        
        private var _name:String;
        private var _value:String;
        
        /**
         * Creates a HTTP header.
         * 
         * @param name The name of the header.
         * @param value The value of the header (default to empty string).
         */
        public function HttpHeader( name:String, value:String = "" )
        {
            super();
            
            _name  = name;
            _value = value;
        }
        
        /**
         * The name of the HTTP header.
         */
        public function get name():String { return _name; }
        
        /**
         * The value of the HTTP header.
         */
        public function get value():String { return _value; }
        /** @private */
        public function set value( val:String ):void { _value = val; }
        
        public function toString():String
        {
            return _name + ": " + _value;
        }
    }
}