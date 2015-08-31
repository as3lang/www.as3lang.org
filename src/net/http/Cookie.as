package net.http
{
    public class Cookie
    {
        
        private static const EXPIRES:String = "Expires";
        private static const MAX_AGE:String = "Max-Age";
        private static const DOMAIN:String = "Domain";
        private static const PATH:String = "Path";
        private static const SECURE:String = "Secure";
        private static const HTTPONLY:String = "HttpOnly";
        
        public static const SECOND:uint = 1000;
        public static const MINUTE:uint = 60 * SECOND;
        public static const HOUR:uint = 60 * MINUTE;
        public static const DAY:uint = 24 * HOUR;
        public static const WEEK:uint = 7 * DAY;
        public static const MONTH:uint = 30 * DAY;
        public static const YEAR:uint = 365 * DAY;
        
        public static function parse( str:String ):Array
        {
            var cookies:Array = [];
            
            var _trim:Function = function( str:String ):String
            {
                while( str.charAt(0) == " " )
                {
                    str = str.substr( 1 );
                }
                
                return str;
            }
            
            var len:uint  = str.length;
            var last:uint = 0;
            var pos1:int;
            var pos2:int;
            
            var name:String;
            var value:String;
            
            while( last != len )
            {
                pos1 = str.indexOf( "=", last );
                pos2 = str.indexOf( ";", last );
                
                if( pos1 > -1 )
                {
                    name = str.substring( last, pos1 );
                    name = _trim( name );
                    
                    if( (pos2 > -1) && (pos1 < pos2) )
                    {
                        value = str.substring( pos1 + 1, pos2 );
                        last  = pos2 + 1;
                    }
                    else
                    {
                        value = str.substring( pos1 + 1 );
                        last  = len;
                    }
                    
                    cookies.push( new Cookie( name, value ) );
                }
                else
                {
                    last = len;
                }
            }
            
            return cookies;
        }
        
        private var _name:String;
        private var _value:String;
        private var _expires:int;
        private var _maxAge:int;
        private var _domain:String;
        private var _path:String;
        private var _secure:Boolean;
        private var _httpOnly:Boolean;
        
        public function Cookie( name:String, value:String = "",
                                expires:int = 0, maxAge:int = 0,
                                domain:String = "", path:String = "",
                                secure:Boolean = false, httpOnly:Boolean = false )
        {
            super();
            _name     = name;
            _value    = value;
            _expires  = expires;
            _maxAge   = maxAge;
            _domain   = domain;
            _path     = path;
            _secure   = secure;
            _httpOnly = httpOnly;
        }
        
        public function get name():String { return _name; }
        
        public function get value():String { return _value; }
        public function set value( str:String ):void { _value = str; }
        
        public function get expires():int { return _expires; }
        public function set expires( value:int ):void { _expires = value; }
        
        public function get maxAge():int { return _maxAge; }
        public function set maxAge( value:int ):void { _maxAge = value; }
        
        public function get domain():String { return _domain; }
        public function set domain( value:String ):void { _domain = value; }
        
        public function get path():String { return _path; }
        public function set path( value:String ):void { _path = value; }
        
        public function get secure():Boolean { return _secure; }
        public function set secure( value:Boolean ):void { _secure = value; }
        
        public function get httpOnly():Boolean { return _httpOnly; }
        public function set httpOnly( value:Boolean ):void { _httpOnly = value; }
        
        public function toString():String
        {
            var str:String = "";
            var now:Date   = new Date();
            
                str += name + "=" + value;
            
            if( expires > 0 )
            {
                now.time += expires;
                str += "; " + EXPIRES + "=" + HttpUtils.date_rfc1123( now );
            }
            else if( expires < 0 )
            {
                now.time -= DAY;
                str += "; " + EXPIRES + "=" + HttpUtils.date_rfc1123( now );
            }
            
            if( maxAge != 0 )
            {
                str += "; " + MAX_AGE + "=" + maxAge;
            }
            
            if( domain != "" )
            {
                str += "; " + DOMAIN + "=" + domain;
            }
            
            if( path != "" )
            {
                str += "; " + PATH + "=" + path;
            }
            
            if( secure )
            {
                str += "; " + SECURE;
            }
            
            if( httpOnly )
            {
                str += "; " + HTTPONLY;
            }
            
            return str;
        }
        
    }
}