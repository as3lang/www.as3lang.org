package net.mediatypes
{
    /**
     * An Internet Media type is a standard identifier used on the Internet
     * to indicate the type of data that a file contain.
     * 
     * Also known as Multipurpose Internet Mail Extensions or MIME.
     * 
     * Those media types are often used as part of a communication protocol
     * from email to web browsers, protocol such as SMTP, HTTP, etc. 
     * 
     * A media type is composed of a type and a subtype, and more optional
     * parameters, because the registry is a big "database" and not all types
     * are used by all protocols / programs / libraries we organised them
     * in such a way that you can only a few in your code and/or add new ones
     * or missing ones.
     * 
     * Each type has its own package, and within those packages we define a
     * constant to create one definition of a media type.
     * Those constants are package level definitions, they are not part of a
     * class or a database which would force you to include/embed all of them
     * even if you want to use only one.
     * 
     * @see https://en.wikipedia.org/wiki/Internet_media_type Internet Media Type
     * @see http://tools.ietf.org/html/rfc2045 MIME Part One
     * @see http://tools.ietf.org/html/rfc2046 MIME Part Two
     * @see http://tools.ietf.org/html/rfc2047 MIME Part Three
     * @see http://tools.ietf.org/html/rfc2048 MIME Part Four
     * @see http://tools.ietf.org/html/rfc2049 MIME Part Five
     * @see http://www.iana.org/assignments/media-types/media-types.xhtml IANA Media Types registry
     */ 
    public class MediaType
    {
        
        private var _type:String;
        private var _subtype:String;
        private var _name:String;
        private var _parameters:String;
        private var _tree:String;
        private var _suffix:String;
        private var _extensions:Array;
        
        public function MediaType( type:String, subtype:String = "",
                                   extensions:Array = null, parameters:String = "",
                                   tree:String = "", suffix:String = "",
                                   name:String = "" )
        {
            super();
            
            _type       = type;
            _subtype    = subtype;
            _name       = name;
            _parameters = parameters;
            _tree       = tree;
            _suffix     = suffix;
            _extensions = extensions;
            
            if( hasExtensions() )
            {
                _checkExtensions( _extensions );
            }
        }
        
        private function _checkFirstDot( str:String ):String
        {
            if( str.charAt(0) == "." )
            {
                return str;
            }
            
            return "." + str;
        }
        
        private function _checkExtensions( data:Array ):void
        {
            var i:uint;
            for( i = 0; i < data.length; i++ )
            {
                data[ i ] = _checkFirstDot( data[i] );
            }
        }
        
        public function get type():String { return _type; }
        public function set type( value:String ):void { _type = value; }
        
        public function get subtype():String { return _subtype; }
        public function set subtype( value:String ):void { _subtype = value; }
        
        public function get name():String { return _name; }
        public function set name( value:String ):void { _name = value; }
        
        public function get parameters():String { return _parameters; }
        public function set parameters( value:String ):void { _parameters = value; }
        
        public function get tree():String { return _tree; }
        public function set tree( value:String ):void { _tree = value; }
        
        public function get suffix():String { return _suffix; }
        public function set suffix( value:String ):void { _suffix = value; }
        
        public function get extensions():Array { return _extensions; }
        public function set extensions( value:Array ):void
        {
            _checkExtensions( value );
            _extensions = value;
        }
        
        public function hasExtensions():Boolean
        {
            if( _extensions == null )
            {
                return false;
            }
            
            if( _extensions.length > 0 )
            {
                return true;
            }
            
            return false;
        }
        
        public function compatibleWith( ext:String ):Boolean
        {
            if( !hasExtensions() )
            {
                return false;
            }
            
            var i:uint;
            var extension:String;
            for( i = 0; i < _extensions.length; i++ )
            {
                extension = _extensions[i];
                if( extension == ext )
                {
                    return true;
                }
            }
            
            return false;
        }
        
        public function valueOf():String
        {
            return toString();
        }
        
        public function toString():String
        {
            var str:String = "";
            str += type;
            
            if( subtype != "" )
            {
                str += "/";
                
                if( tree != "" )
                {
                    str += tree;
                    if( tree == "x" )
                    {
                        str += "-";
                    }
                    else
                    {
                        str += ".";
                    }
                }
                
                str += subtype;
                
                if( suffix != "" )
                {
                    str += "+";
                    str += suffix;
                }
            }
            
            if( parameters != "" )
            {
                str += "; ";
                str += parameters;
            }
            
            return str;
        }
        
    }
    
}