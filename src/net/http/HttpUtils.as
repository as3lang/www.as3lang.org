package net.http
{
    import flash.utils.ByteArray;
    
    /**
     * HTTP utilities.
     * 
     */ 
    public class HttpUtils
    {
        
        private static const _CR:String   = "\r";
        private static const _LF:String   = "\n";
        private static const _SP:String   = " ";
        private static const _COL:String  = ":";
        private static const _CRLF:String = _CR + _LF; // CRLF 0x0D 0x0A
        private static const _EOL:uint    = 0x0A;      // EOL  0x0A (End Of Line)
        
        
        private static function _trimStart( source:String , chars:Array ):String
        {
            if ( source == null || source == "" )
            {
                return "";
            }
        
            var i:int;
            var l:int = source.length;
            for( i = 0; (i < l) && (chars.indexOf( source.charAt( i ) ) > - 1) ; i++ )
            {
            }
        
            return source.substring( i );
        }
        
        private static function _trimEnd( source:String , chars:Array ):String
        {
            if( source == null || source == "" )
            {
                return "";
            }
        
            var i:int;
            var l:int = source.length;
            for( i = source.length - 1; (i >= 0) && (chars.indexOf( source.charAt( i ) ) > - 1) ; i-- )
            {
            }
        
            return source.substring( 0, i + 1 );
        }
        
        private static function _trim( source:String , chars:Array = null ):String
        {
            if ( source == null || source == "" )
            {
                return "";
            }
            
            var i:int;
            var l:int;
            
            l = source.length ;
            for( i = 0; (i < l) && (chars.indexOf( source.charAt( i ) ) > - 1) ; i++ )
            {
            }
            source = source.substring( i );
            
            l = source.length ;
            for( i = source.length - 1; (i >= 0) && (chars.indexOf( source.charAt( i ) ) > - 1) ; i-- )
            {
            }
            source = source.substring( 0, i + 1 ) ;
            
            return source;
        }
        
        
        public static function parse_header_line( str:String ):HttpHeader
        {
            var name:String  = "";
            var value:String = "";
            
            var pos:int = str.indexOf( _COL );
            
            if( pos > -1 )
            {
                name  = str.substr( 0, pos );
                value = str.substring( pos + 1 );
                value = _trimStart( value, [ _SP, _CR, _LF ] );
            }
            
            return new HttpHeader( name, value );
        }
        
        public static function parse_http_headers( str:String ):Array
        {
            var headers:Array = [];
            var lines:Array   = str.split( _CRLF );
            
            var i:uint;
            var len:uint = lines.length;
            var line:String;
            
            for( i = 0; i < len; i++ )
            {
                line = lines[ i ];
                headers.push( parse_header_line( line ) );
            }
            
            return headers;
        }
        
        public static function parse_environ_line( str:String, ignore:String = "" ):HttpHeader
        {
            var name:String  = "";
            var value:String = "";
            
            var pos:int = str.indexOf( "=" );
            
            if( pos > -1 )
            {
                name  = str.substr( 0, pos );
                name  = name.substr( ignore.length );
                name  = _trimEnd( name, [ _SP, _CR, _LF ] );
                name  = HttpHeader.formatName( name );
                value = str.substring( pos + 1 );
                value = _trimStart( value, [ _SP, _CR, _LF ] );
            }
            
            return new HttpHeader( name, value );
        }
        
        public static function environ_http_headers( environ:Array, find:String = "HTTP_" ):Array
        {
            var headers:Array = [];
            var lines:Array   = environ; // Program.environ, C.environ
            
            var i:uint;
            var len:uint = lines.length;
            var line:String;
            
            for( i = 0; i < len; i++ )
            {
                line = lines[ i ];
                if( (find == "") || (line.indexOf( find ) == 0) )
                {
                    headers.push( parse_environ_line( line, find ) );    
                }
            }
            
            return headers;
        }
        
        public static function parse_http_statusline( str:String ):Object
        {
            var statusline:Object = {};
                statusline.protocolVersion = "";
                statusline.statusCode      = "";
                statusline.reasonPhrase    = "";
        
            var pos1:int = str.indexOf( _SP );
            var pos2:int = str.indexOf( _SP, pos1 + 1 );
            
            statusline.protocolVersion = str.substring( 0, pos1 );
            statusline.statusCode      = str.substring( pos1 + 1 , pos2 );
            statusline.reasonPhrase    = str.substring( pos2 + 1 );
        
            return statusline;
        }
        
        public static function parse_http_status( str:String ):Object
        {
            var status:Object = {};
            status.statusCode  = "";
            status.reasonPhrase = "";
            
            var pos1:int = str.indexOf( _SP );
            
            status.statusCode  = str.substring( 0, pos1 );
            status.reasonPhrase = str.substring( pos1 + 1 );
            
            return status;
        }
        
        public static function parse_http_response( bytes:ByteArray, trimEOL:Boolean = true ):HttpResponse
        {
            var httpResponse:HttpResponse = new HttpResponse();
            var statusLine:String = "";
            var headerFields:String = "";
            
            var firstLine:Boolean = true;
            
            bytes.position = 0;
            var line:String;
            var body:ByteArray = new ByteArray();
            
            while( line != _CRLF )
            {
                line = read_line_until( bytes, _EOL );
                
                if( firstLine )
                {
                    statusLine = line;
                    firstLine = false;
                }
                else
                {
                    headerFields += line;
                }
            }
            
            if( trimEOL )
            {
                statusLine   = _trim( statusLine, [ _CR, _LF ] );
                headerFields = _trim( headerFields, [ _CR, _LF ] );
            }
            
            var status:Object = parse_http_statusline( statusLine );
            httpResponse.httpVersion  = status.protocolVersion;
            httpResponse.statusCode   = status.statusCode;
            httpResponse.reasonPhrase = status.reasonPhrase;
            
            var headers:Array = parse_http_headers( headerFields );
            var i:uint;
            var len:uint = headers.length;
            for( i = 0; i < len; i++ )
            {
                httpResponse.addHeader( headers[i] );
            }
            
            var pos:uint = bytes.position;
            bytes.readBytes( body );
            
            body.position = 0;
            httpResponse.bodyBytes = body;
            
            return httpResponse;
        }
        
        public static function parse_content_chunked( content:String ):String
        {
            /* note:
               maybe bug
               when we have for last part

               0CRLF
               CRLF

               last CRLF is removed

               but ending in
               0CRLF
               is wrong

               the 0 should be removed but the CRLF kept
               (could be a problem with burrrn.com CGI)

               eg.
                    </body>
                </html>
                0
            */
            var add:uint      = _CRLF.length;
            var buffer:String = content;
            var str:String    = "";
            
            var startscan:int = 0
            var lastpos:int   = 0;
            var pos:String;
            var len:uint;
            do
            {
                pos = buffer.substr( 0, buffer.indexOf( _CRLF ) );
                len = uint( "0x" + pos );
                if( (len == 0) || (pos.length > 8) )
                {
                    str += pos;
                    break;
                }
                startscan = pos.length + add;
                str += buffer.substr( startscan, len );
                lastpos = len + add;
                buffer = buffer.substring( startscan + lastpos );
            }
            while( buffer != "" )
            
            return str;
        }
        
        
        public static function get_line_until( bytes:ByteArray, char:int ):ByteArray
        {
            var start:uint = bytes.position;
            var line:ByteArray = new ByteArray();
            
            var c:int;
            while( bytes.bytesAvailable > 0 )
            {
                c = bytes.readByte();
                line.writeByte( c );
                
                if( c == char )
                {
                    break;
                }
            }
            
            return line;
        }
        
        public static function read_line_until( bytes:ByteArray, char:int ):String
        {
            var found:Boolean = false;
            var line:ByteArray = get_line_until( bytes, char );
            if( line.length > 0 )
            {
                found = true;
            }
            
            var str:String = null;
            if( found )
            {
                line.position = 0;
                str = line.readUTFBytes( line.length );
            }
            
            return str;
        }
        
        public function HttpUtils()
        {
            super();
        }
    }
}