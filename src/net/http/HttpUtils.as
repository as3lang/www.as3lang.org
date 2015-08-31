package net.http
{
    import C.stdio.*;
    
    import flash.utils.ByteArray;
    
    import net.URI;
    
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
        
        private static function _cleanupANSI( a:String, before:String = "「", after:String = "」" ):String
        {
            a += before + after;
            
            var str:String = "";
            var re:RegExp = new RegExp( "(?P<word>.*?)" + "\\" + before + "(?P<ansi>.*?)" + "\\" + after , "g" );
            var match:*;
            
            while( match = re.exec( a ) )
            {
                str += match.word;
            }
            
            return str;
        }
        
        private static function _removeANSI( ansi:String, before:String = "「", after:String = "」" ):String
        {
            if( ansi.indexOf( "\n" ) > -1 )
            {
                var lines:Array = ansi.split( "\n" );
                var i:uint;
                var len:uint = lines.length;
                for( i = 0; i < len; i++ )
                {
                    lines[i] = _cleanupANSI( lines[i] );
                }
                return lines.join( "\n" );
            }
            else
            {
                return _cleanupANSI( ansi );
            }
        }
        
        public static function format_ansi( str:String, ansi:Boolean = true ):String
        {
            //encoding.ansi.AnsiString
            var C:Class;
            
            try
            {
                C = getClassByName( "encoding.ansi.AnsiString" );
            }
            catch( e:Error )
            {
                //don't throw
            }
            
            if( C )
            {
                var astr:* = new C( str );
                if( ansi )
                {
                    return astr.toString();
                }
                else
                {
                    return astr.valueOf();
                }
            }
            
            return _removeANSI( str );
        }
        
        public static function date_rfc1123( d:Date = null, zone:String = "GMT" ):String
        {
            // RFC 822: Sun, 16 Aug 15 00:20:57 GMT
            // RFC 1123: Sun, 16 Aug 2015 00:20:57 GMT
            
            if( !d )
            {
                d = new Date();
            }
            
            var zero:Function = function( n:* ):String
            {
                var s:String = String(n);
                if( n < 10 ) { s = "0" + s; }
                return s;
            }
            
            var str:String = "";
            var days:Array = [ "Sun","Mon","Tue","Wed","Thu","Fri","Sat" ];
            var months:Array = [ "Jan","Feb","Mar","Apr",
                                 "May","Jun","Jul","Aug",
                                 "Sep","Oct","Nov","Dec" ];
            
            var dd:Number    = d.dayUTC;
            var day:String   = days[ dd ];
            var wkd:Number   = d.dateUTC;
            
            var mm:Number    = d.monthUTC;
            var month:String = months[ mm ];
            
            var yyyy:Number = d.fullYearUTC;
            //var year:String = String(yyyy);
            //var yy:String = year.substr( 2 );
            
            var hh:Number  = d.hoursUTC;
            var mn:Number  = d.minutesUTC;
            var sec:Number = d.secondsUTC;
            
            str += day + ",";
            str += " " + zero(wkd) + " " + month + " " + yyyy;
            str += " " +zero(hh) + ":" + zero(mn) + ":" + zero(sec);
            str += " " + zone;
            
            return str;
        }
        
        public static function parse_date_rfc1123( str:String ):Date
        {
            var ms:Number = Date.parse( str );
            var d:Date = new Date( ms );
            return d;
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
        
        public static function parse_auth_header():Object
        {
            /* not implemented yet */
            return null;
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
        
        public static function read_post_body( bytes:ByteArray, len:uint ):int
        {
            /* Note:
               Yes we read directly from the standard input (stdin)
               exactly like a command line executable.
            */
            /* TODO:
               need to update the code for case where len is
               bigger than MAX_INT
               
               fread() can only read till nitems
               and nitems is an int so is limited by MAX_INT (2 GB)
            
               but ByteArray can read as much as MAX_UINT (4 GB)
               so we could split len and read in a loop to fill
               the bytearray
            
               also for extreme case where some post data would
               be bigger than 4GB we could still read it all
               by saving the data to an external file
            
               and need to check RFC if there is some kind
               of limit defined
            */
            var result:int = fread( bytes, int(len), stdin );
            
            //reset as we will want to parse it from the start
            bytes.position = 0;
            
            // allow us to check for errors
            return result;
        }
        
        public static function read_post_raw( bytes:ByteArray,
                                              buffer:uint = 8192 ):Number
        {
            /* Note:
               Alternative way to do it and/for case where
               the content-length is unknown
            
               we use a default 8K buffer, eg. BUFSIZ
            */
            var len:Number  = 0;
            var read:int    = 0;
            var b:ByteArray = new ByteArray();
            
            /* Note:
               as with a command line exe we can loop
               with fread() till the data to read is exhausted
            
               loop as long as fread() does not returns zero
               if returns zero that means EOF reached
               if returns less than zero that means an error occured
            
               because we use a ByteArray to store the data
               we can read till MAX_UINT eg. 4GB of data
            */
            while( read = fread( b, int(buffer), stdin ) )
            {
                // an error occured
                if( read < 0 )
                {
                    // we may have partial data in bytes
                    bytes.position = 0;
                    // if an error occured we want to know it
                    return read;
                }
                
                bytes.writeBytes( b );
                len += read;
                b.clear();
            }
            
            //reset as we will want to parse it from the start
            bytes.position = 0;
            
            // otherwise return the lenght of data we just read
            return len;
        }
        
        public static function parse_form_urlencoded( bytes:ByteArray ):Object
        {
            bytes.position = 0;
            
            var len:uint = bytes.length;
            var query:String = "";
            var str:String = "";
            
            str = bytes.readUTFBytes( len );
            
            if( str.indexOf("+") > -1 )
            {
                query = str.split( "+" ).join( " " );
            }
            
            query = decodeURIComponent( query );
            
            var uri:URI = new URI();
                uri.query = query;
            
            return uri.getQueryByMap();
        }
        
        public static function parse_form_data( bytes:ByteArray ):Object
        {
            //TODO
            return null;
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
        
        public static function parse_http_requestline( str:String ):Object
        {
            var requestline:Object = {};
            requestline.method          = "";
            requestline.path            = "";
            requestline.protocolVersion = "";
            
            var pos1:int = str.indexOf( _SP );
            var pos2:int = str.indexOf( _SP, pos1 + 1 );
            
            requestline.method          = str.substring( 0, pos1 );
            requestline.path            = str.substring( pos1 + 1 , pos2 );
            requestline.protocolVersion = str.substring( pos2 + 1 );
            
            return requestline;
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
        
        public static function parse_http_request( bytes:ByteArray, trimEOL:Boolean = true ):HttpRequest
        {
            var httpRequest:HttpRequest = new HttpRequest();
            var requestLine:String = "";
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
                    requestLine = line;
                    firstLine = false;
                }
                else
                {
                    headerFields += line;
                }
            }
            
            if( trimEOL )
            {
                requestLine   = _trim( requestLine, [ _CR, _LF ] );
                headerFields = _trim( headerFields, [ _CR, _LF ] );
            }
            
            var request:Object = parse_http_requestline( requestLine );
            var rawpath:String = request.path;
            var malformedPath:Boolean = false;
            try
            {
                rawpath = decodeURIComponent( request.path );
            }
            catch( e:Error )
            {
                /* URIError: Error #1052: Invalid URI passed to decodeURIComponent function.
                   for ex text with:
                   /%91
                   /%91?a=1&b=2
                */
                malformedPath = true;
            }
            
            trace( "rawpath = " + rawpath );
            if( malformedPath )
            {
                if( rawpath.indexOf( "?" ) > -1 )
                {
                    var tmp:Array = rawpath.split( "?" );
                    httpRequest.set( tmp[0] );
                    httpRequest.path        = tmp[0];
                    httpRequest.query       = tmp[1];
                }
                else
                {
                    httpRequest.set( rawpath );
                    httpRequest.path        = rawpath;
                    httpRequest.query       = "";
                }
            }
            else
            {
                var uri:URI = new URI( rawpath );
                trace( "uri.path = " + uri.path );
                
                httpRequest.set( uri.path );
                httpRequest.path        = uri.path;
                httpRequest.query       = uri.query;
            }
            
            httpRequest.method      = request.method;
            httpRequest.httpVersion = request.protocolVersion;
            
            var headers:Array = parse_http_headers( headerFields );
            var i:uint;
            var len:uint = headers.length;
            for( i = 0; i < len; i++ )
            {
                httpRequest.addHeader( headers[i] );
            }
            
            var pos:uint = bytes.position;
            bytes.readBytes( body );
            
            body.position = 0;
            httpRequest.bodyBytes = body;
            
            return httpRequest;
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