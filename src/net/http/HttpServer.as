package net.http
{
    import C.arpa.inet.*;
    import C.errno.*;
    import C.netdb.*;
    import C.netinet.sockaddr_in;
    import C.stdlib.setenv;
    import C.sys.socket.*;
    
    import crypto.generateUUID;
    
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import net.http.cgi.MetaVariables;
    
    import shell.Program;

    public class HttpServer
    {
        
        private var _enableErrorChecking:Boolean;
        
        private var _addrlist:Array;
        private var _sockfd:int;
        private var _info:addrinfo;
        
        private var _localAddress:String;
        private var _localPort:int;
        
        private var _remoteAddress:String;
        private var _remotePort:int;
        
        
        public function HttpServer( enableErrorChecking:Boolean = false )
        {
            super();
            
            _enableErrorChecking = enableErrorChecking;
        }
        
        private function _init( port:String, backlog:int = 1 ):int
        {
            var hints:addrinfo = new addrinfo();
                hints.ai_family   = AF_UNSPEC;
                hints.ai_socktype = SOCK_STREAM;
                hints.ai_flags    = AI_PASSIVE;
            
            var eaierr:CEAIrror = new CEAIrror();
            var addrlist:Array  = getaddrinfo( null, port, hints, eaierr );
            
            if( !addrlist )
            {
                if( enableErrorChecking ) { throw eaierr; }
                
                return -1;
            }
            
            _addrlist = addrlist;
            
            var i:uint;
            var info:addrinfo;
            var sockfd:int;
            var option:int;
            var bound:int;
            var listening:int;
            
            for( i = 0; i < addrlist.length; i++ )
            {
                info = addrlist[i];
                
                sockfd = socket( info.ai_family, info.ai_socktype, info.ai_protocol );
                if( sockfd < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                
                option = setsockopt( sockfd, SOL_SOCKET, SO_REUSEADDR, 1 );
                if( option < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                
                bound = bind( sockfd, info.ai_addr );
                if( bound < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                
                listening = C.sys.socket.listen( sockfd, backlog );
                if( listening < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                
                break;    
                
            }
            
            _info = info;
            
            var a:String = inet_ntop( _info.ai_family, _info.ai_addr );
            if( !a )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            else
            {
                _localAddress = a;
            }
            
            _localPort = ntohs( _info.ai_addr.sin_port );
            
            return sockfd;
        }
        
        private function _findClientAddressAndPort( addr:sockaddr_in ):void
        {
            
            var result:int = getsockname( _sockfd, addr );
            if( result == -1 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            else
            {
                var a:String = inet_ntop( addr.sin_family, addr );
                if( !a )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                }
                else
                {
                    _remoteAddress = a;    
                }
                
                _remotePort = ntohs( addr.sin_port );
            }
        }
        
        private function _receiveAll( socket:int, bytes:ByteArray, len:int = 8192, flags:int = 0 ):int
        {
            var total:uint = 0; // how many bytes we received
            var n:int;
            var b:ByteArray = new ByteArray();
            
            var run:Boolean = true;            
            while( run )
            {
                b.clear();
                n = recv( socket, b, len, flags );
                
                if( n == -1 ) { run = false; break; }
                bytes.writeBytes( b );
                total += n;
                if( n == 0 ) { run = false; break; }
            }
            
            b.clear();
            
            if( n < 0 )
            {
                return -1; //failure
            }
            
            return total; // number of bytes actually received
        }
        
        /**
         * Specifies whether errors encountered by the sockets are reported
         * to the application.
         * 
         * <p>
         * When enableErrorChecking is <code>true</code> methods are synchronous
         * and can throw errors. When enableErrorChecking is <code>false</code>,
         * the default, the methods are asynchronous and errors are not reported.
         * </p>
         */ 
        public function get enableErrorChecking():Boolean { return _enableErrorChecking; }
        /** @private */
        public function set enableErrorChecking( value:Boolean ):void { _enableErrorChecking = value; }
        
        public function listen( port:int = -1, backlog:int = 1 ):void
        {
            if( port == -1 )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "You need to provide a valid port, " + port + " is not valid." );
                }
            }
            
            var sockfd:int = _init( String( port ), backlog );
            
            trace( "HTTP server listening | " + _localAddress + ":" + _localPort );
            _sockfd = sockfd;
        }
        
        public function start():void
        {
            trace( "========================================================================" );
            var t1:uint = getTimer();
            var clientfd:int;
            var client_addr:sockaddr_in = new sockaddr_in();
            
                clientfd = accept( _sockfd, client_addr );
                if( clientfd < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                }
            
            _findClientAddressAndPort( client_addr );
            trace( "client connected | " + _remoteAddress + ":" + _remotePort );
            
            //var bytes:ByteArray = generateRandomBytes( 2 );
            //trace( "bytes = " + bytesToHex( bytes ) );
            trace( "uuid = xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx" );
            trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            //trace( "uuid = " + generateUUID() );
            
            var bytes:ByteArray = new ByteArray();
            //var received:int = _receiveAll( clientfd, bytes );
            var received:int = recv( clientfd, bytes, 8192 );
            
            if( received < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            trace( "received " + received + " bytes" );
            trace( "--------" );
            bytes.position = 0;
            //trace( bytes.readUTFBytes( bytes.length ) );
            var request:HttpRequest = HttpUtils.parse_http_request( bytes );
            //trace( request.toString() );
            trace( request.toDebugString() );
            trace( "--------" );
            if( request.hasHeader( "Cookie" ) )
            {
                trace( "found cookies" );
                var cookies:Array = Cookie.parse( request.getHeaderValue( "Cookie" ) );
                for( var i:uint = 0; i < cookies.length; i++ )
                {
                    var c:Cookie = cookies[i];
                    trace( "[" + i + "]: " + c.toString() );
                }
            }
            else
            {
                trace( "no cookies found" );
            }
            trace( "--------" );
            
            /* Note:
               important here
               we parsed the request at the server level
               but when we will call open( "redshell index.abc" );
               we will lose the headers
               because those headers are read from the env vars
            
               so basically we need to loop trough the request headers
               and for each one
               setenv( "HTTP_" + name, value )
            */
            
            var j:uint;
            var header:Header;
            for( j = 0; j < request.headersList.length; j++ )
            {
                header = request.headersList[j];
                setenv( HttpHeader.formatEnvName( header.name ) , header.value );
            }
            
            
            setenv( MetaVariables.REQUEST_METHOD, request.method );
            setenv( MetaVariables.CONTENT_TYPE, "" );
            setenv( MetaVariables.CONTENT_LENGTH, "" );
            setenv( MetaVariables.QUERY_STRING, request.query );
            
            setenv( MetaVariables.PATH_INFO, request.path );
            setenv( "REQUEST_URI", request.path );
            
            setenv( MetaVariables.GATEWAY_INTERFACE, "CGI/1.1" );
            setenv( MetaVariables.SERVER_PROTOCOL, request.httpVersion );
            setenv( MetaVariables.SERVER_SOFTWARE, "MockApache" );
            
            //setenv( MetaVariables.SERVER_NAME, "" );
            setenv( MetaVariables.SERVER_PORT, String(_localPort) );
            
            setenv( MetaVariables.REMOTE_ADDR, _remoteAddress );
            //setenv( REMOTE_PORT ? );
            
            //var cgipipe:FILE = popen( "redshell index.abc", "r" );
            var output:String = Program.open( "/sdk/redtamarin/runtimes/redshell/macintosh/64/redshell index.abc" );
            //trace( "--------" );
            //trace( output );
            //trace( "--------" );
            var responseBytes:ByteArray = new ByteArray();
                responseBytes.writeUTFBytes( "HTTP/1.1 " + StatusCode.OK.toString() + "\r\n" );
                responseBytes.writeUTFBytes( output );
            
            var response:HttpResponse = HttpUtils.parse_http_response( responseBytes );
            
            if( response.hasHeader( "Status" ) )
            {
                response.status = response.getHeaderValue( "Status" );
            }
            
            var now:String = HttpUtils.date_rfc1123();
            response.addHeaderLine( "Date", now );
            response.addHeaderLine( "Server", "MockApache" );
            
            var t2:uint = getTimer();
            response.addHeaderLine( "X-ProcessingTime", "D=" + (t2-t1) );
            
            //create cookie
            /*
            var c1:Cookie = new Cookie( "test1", "hello" );
            var c2:Cookie = new Cookie( "test2", "bonjour" );
            response.addHeaderLine( "Set-Cookie", c1.toString() );
            response.addHeaderLine( "Set-Cookie", c2.toString() );
            */
            
            //delete cookie
            /*
            var c1:Cookie = new Cookie( "test1", "hello" );
                c1.expires = -1;
            response.addHeaderLine( "Set-Cookie", c1.toString() );
            */
            
            trace( "--------" );
            trace( response.status );
            trace( "--------" );
            //trace( response.toString() );
            //trace( response.toDebugString( true, 40 ) );
            trace( response.toDebugString() );
            trace( "--------" );
                
            var sent:int = sendall( clientfd, response.toByteArray() );
            if( sent < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            trace( "sent " + sent + " bytes" );
        }
        
    }
}