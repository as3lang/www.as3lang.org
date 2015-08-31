
package net.http
{
    //import ansi.*;
    
    //import encoding.ansi.AnsiString; //detected at runtime
    
    import flash.utils.ByteArray;
    
    import net.URI;

    /**
     * HTTP Request message class.
     * 
     * <p>
     * A HTTP Request consist of request line, a collection of header fields,
     * and an optional body.
     * </p>
     */
    public class HttpRequest extends HttpMessage implements Request
    {
        
        private static var _DEFAULT_PORT:int = -1;
        private static var _MAX_PORT:int     = 0xffff; //65535
        
        private static const _CR:String   = "\r";
        private static const _LF:String   = "\n";
        private static const _SP:String   = " ";
        private static const _COL:String  = ":";
        private static const _CRLF:String = _CR + _LF; // CRLF 0x0D 0x0A
        
        /**
         * Builds a GET request.
         */ 
        public static function GET( destination:String ):HttpRequest
        {
            var request:HttpRequest = new HttpRequest();
                request.method = RequestMethod.GET;
                request.set( destination );
            
            return request;
        }
        
        /**
         * Builds a PUT request.
         */ 
        public static function PUT( destination:String ):HttpRequest
        {
            var request:HttpRequest = new HttpRequest();
                request.method = RequestMethod.PUT;
                request.set( destination );
            
            return request;
        }
        
        /**
         * Builds a POST request.
         */ 
        public static function POST( destination:String ):HttpRequest
        {
            var request:HttpRequest = new HttpRequest();
            request.method = RequestMethod.POST;
            request.set( destination );
            
            return request;
        }
        
        /**
         * Builds a DELETE request.
         */ 
        public static function DELETE( destination:String ):HttpRequest
        {
            var request:HttpRequest = new HttpRequest();
                request.method = RequestMethod.DELETE;
                request.set( destination );
            
            return request;
        }
        
        
        private var _host:String;
        private var _protocol:String;
        private var _port:int;
        
        private var _method:String;
        private var _path:String;
        private var _query:String;
        
        protected var _connection:HttpConnection;
        protected var _destination:URI;
        
        public function HttpRequest( destination:String = "" )
        {
            super();
            
            _ctor();
            
            if( destination != "" )
            {
                set( destination );
            }
        }
        
        private function _ctor():void
        {
            _host     = "localhost";
            _protocol = "http";
            _port     = _DEFAULT_PORT;
            
            _method   = RequestMethod.GET;
            _path     = "/";
            _query    = "";
        }
        
        
        public function get connection():HttpConnection { return _connection; }
        public function set connection( value:HttpConnection ):void { _connection = value; }
        
        public function get requestLine():String
        {
            var line:String = "";
            
            if( method != "" )
            {
                line += method;
            }
            else
            {
                line += RequestMethod.GET;
            }
                
                line += _SP;
            
            if( path == "" )
            {
                line += "/";
            }
            else
            {
                line += path;
            }
            
            if( query != "" )
            {
                line += "?" + query;
            }
                line +=  _SP + httpVersion;
            
            return line;
        }
        
        
        /*
            if( uri.scheme != URI.UNKNOWN )
            {
                protocol = uri.scheme;
            }
            
            host = uri.authority;
            
            if( uri.port != "" )
            {
                port = parseInt( uri.port );
            }
            
            path = uri.path;
            query = uri.query;
        */
        
        public function get host():String
        {
            //return _host;
            if( !_destination )
            {
                return "";
            }
            
            return _destination.authority;
        }
        
        public function set host( value:String ):void
        {
            //_host = value;
            if( _destination )
            {
                _destination.authority = value;
            }
        }
        
        public function get protocol():String { return _protocol; }
        public function set protocol( value:String ):void { _protocol = value; }
        
        public function get port():int
        {
            if( _destination && _destination.port )
            {
                if( _destination.port == "" )
                {
                    _port = _DEFAULT_PORT;
                }
                else
                {
                    _port = parseInt( _destination.port );
                }
            }
            
            if( _port == _DEFAULT_PORT )
            {
                switch( protocol )
                {
                    case "https":
                    return 443;
                    
                    case "":
                    case "http":
                    default:
                    return 80;
                }
            }
            
            return _port;
        }
        public function set port( value:int ):void
        {
            if( value < 0 )
            {
                value = _DEFAULT_PORT;
            }
            
            if( value > _MAX_PORT )
            {
                value = _MAX_PORT;
            }
            
            _port = value;
        }
        
        
        public function get method():String { return _method; }
        public function set method( value:String ):void { _method = value; }
        
        public function get path():String
        {
            //return _path;
            if( !_destination )
            {
                return "";
            }
            
            return _destination.path;
        }
        
        public function set path( value:String ):void
        {
            //_path = value;
            if( _destination )
            {
                _destination.path = value;
            }
        }
        
        public function get query():String
        {
            //return _query;
            if( !_destination )
            {
                return "";
            }
            
            return _destination.query;
        }
        
        public function set query( value:String ):void
        {
            //_query = value;
            if( _destination )
            {
                _destination.query = value;
            }
        }
        
        public function get queryMap():Object
        {
            if( !_destination )
            {
                return null;
            }
            
            return _destination.getQueryByMap();
        }
        
        public function set queryMap( value:Object ):void
        {
            if( _destination )
            {
                _destination.setQueryByMap( value );
            }
        }
        
        
        public function get url():String
        {
            if( !_destination )
            {
                return "";
            }
            
            return _destination.toString();
        }
        
        public function get hostUrl():String
        {
            var short:URI = new URI();
                short.copyURI( _destination );

                short.path = "";
                short.query = "";

            return short.toString();
        }
        
        
        public function set( destination:String ):void
        {
            var uri:URI = new URI( destination );
            
            if( uri.isValid() && uri.isHierarchical() )
            {
                _destination = uri;
            }
            
        }
        
        public function setHostHeader():void
        {
            var hostPort:String = "";
                hostPort += host;
            if( _port != _DEFAULT_PORT )
            {
                hostPort += _COL + port;
            }
            
            addHeaderLine( HttpHeader.HOST, hostPort, true );
        }
        
        
        public function open( connection:HttpConnection = null ):void
        {
            if( !connection )
            {
                this.connection = new HttpConnection();
            }
            else
            {
                this.connection = connection;
            }
            
            if( this.port != _DEFAULT_PORT )
            {
                this.connection.open( host, port );    
            }
            else
            {
                this.connection.open( host );
            }
        }
        
        public function send():HttpResponse
        {
            if( (connection == null) || (connection && !connection.connected) )
            {
                open( connection );
            }
            
            if( !connection.connected )
            {
                return null;
            }
            
            var response:HttpResponse;
            
            connection.send( toByteArray() );
            var data:ByteArray = connection.receive();
            if( data.length > 0 )
            {
                response = HttpUtils.parse_http_response( data, true );
            }
            
            if( response && (response.statusCode == "302") )
            {
                // for a redirect we always close the connection
                connection.close();
                var location:String = response.getHeaderValue( "Location" );
                //trace( "location changed = [" + location + "]" );
                set( location );
                setHostHeader();
                response = send();
            }
            
            if( !isConnectionPersistent() )
            {
                connection.close();
            }
            
            if( response )
            {
                response.httpRequest = this;
            }
            
            return response;
        }
        
        protected function toStringInternal( fullRequest:Boolean = false ):String
        {
            var request:String = "";
                request += requestLine + _CRLF;
            
            if( !hasHeader( HttpHeader.HOST ) )
            {
                setHostHeader();
            }
            
            if( !hasHeader( HttpHeader.USER_AGENT ) )
            {
                addHeaderLine( HttpHeader.USER_AGENT, "httplib" );
            }
            
            if( ((method == RequestMethod.POST) || (method == RequestMethod.PUT)) &&
               !hasHeader( HttpHeader.CONTENT_LENGTH ) )
            {
                contentLength = bodyBytes.length;
            }
            
            
            if( !hasHeader( HttpHeader.CONNECTION ) )
            {
                persistence( false );
            }
            
            var i:uint;
            var len:uint = headers.length;
            //var header:Header;
            var header:HttpHeader;
            for( i = 0; i < len; i++ )
            {
                header = _headers[i];
                if( header.value )
                {
                    //request += HttpHeader(header).toString() + _CRLF;
                    request += header.toString() + _CRLF;
                }
            }
            
            
            if( fullRequest )
            {
            
                    request += _CRLF;
                if( _body && (_body.length > 0) )
                {
                    request += body;
                }
            
            }
            
            return request;
        }
        
        // rewrite without ansilib dependency, use ansi notation instead
        /*
        public function toDebugString( useColors:Boolean = false ):String
        {
            var str:String = "";

            if( useColors )
            {
                
                str += colorize( "{", colors.blue );
                str += colorize( "HttpRequest", colors.white );
                str += "\n";
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "requestLine: ", colors.cyan );
                str += colorize( requestLine, colors.yellow );
                str += "\n";
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "headers:", colors.cyan );
                str += "\n";
            var i:uint;
            var len:uint = _headers.length;
            for( i = 0; i < len; i++ )
            {
                str += colorize( "  |   |_ ", colors.blue );
                str += colorize( _headers[i].name, colors.cyan );
                str += colorize( ": ", colors.blue );
                str += colorize( _headers[i].value, colors.yellow );
                str += "\n";
            }
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "body: ", colors.cyan );
                str += colorize( String(_body.length), colors.red );
                str += colorize( " bytes", colors.red );
                str += "\n";
            if( _body && (_body.length > 0) )
            {
                str += colorize( "      |_ ", colors.blue );
                str += colorize( body.substr( 0, 100 ), colors.yellow );
                str += colorize( "...", colors.brightBlack );
                str += "\n";
            }
                str += colorize( "}", colors.blue );
                
            }
            else
            {
                
                str += "{HttpRequest" + "\n";
                str += "  |_ requestLine: " + requestLine + "\n";
                str += "  |_ headers:" + "\n";
            var i:uint;
            var len:uint = headers.length;
            for( i = 0; i < len; i++ )
            {
                str += "  |   |_ " + headers[i] + "\n";
            }
                str += "  |_ body: " + _body.length + " bytes"  + "\n";
            if( _body && (_body.length > 0) )
            {
                str += "      |_ " + body.substr( 0, 100 ) + "..." + "\n";
            }
                str += "}";
                
            }
            
            return str;
        }
        */
        
        public function toDebugString( ansi:Boolean = true, maxBody:int = -1 ):String
        {
            var str:String = "";
            
                str += "{「K」HttpRequest「W」" + "\n";
                str += "  ├─「K 」 requestLine:「C 」 " + requestLine + "「!W 」\n";
                str += "  ├─「K 」 headers:「C 」" + "\n";
            
            var i:uint;
            var len:uint = _headers.length;
            for( i = 0; i < len; i++ )
            {
                if( i == (len-1) )
                {
                    str += "  │   └─「K 」 ";   
                }
                else
                {
                    str += "  │   ├─「K 」 ";    
                }
                
                str += _headers[i].name + "「C 」";
                str += ":「W 」 ";
                str += _headers[i].value + "「Y 」";
                str += "\n";
            }
            str += "  └─「K 」 body:「C 」 " + _body.length + " bytes「R 」"  + "\n";
            
            var pre:String    = "      └─ 「K 」|「W」";
            var prespc:String = "         │「W」";
            
            var lines:Array;
            
            if( maxBody > -1 )
            {
                var tmp:String = body.substr( 0, maxBody );
                lines = tmp.split( "\n" );
            }
            else
            {
                lines = body.split( "\n" );
            }
            
            var j:uint;
            var l:uint = lines.length;
            for( j = 0; j < l; j++ )
            {
                if( j == 0 )
                {
                    str += pre + lines[j] + "「Y 」" + "\n";
                }
                else
                {
                    str += prespc + lines[j] + "「Y 」" + "\n";   
                }
            }
            
            if( maxBody > -1 )
            {
                str +=  prespc + "...「K 」" + "\n";
            }
            
            str += "}「K 」";
            
            return HttpUtils.format_ansi( str, ansi );
        }
        
        /**
         * Returns the full string representation of the request.
         */ 
        public function toString():String
        {
            return toStringInternal( true );
        }
        
        /**
         * Returns the byte array of the request.
         */ 
        public function toByteArray():ByteArray
        {
            var requestBytes:ByteArray = new ByteArray();
                requestBytes.writeUTFBytes( toStringInternal() );
                
                requestBytes.writeUTFBytes( _CRLF );
            if( _body && (_body.length > 0) )
            {
                _body.position = 0;
                requestBytes.writeBytes( _body );
            }
            
            return requestBytes;
        }
        
    }

}
