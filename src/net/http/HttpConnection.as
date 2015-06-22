
package net.http
{

    import C.arpa.inet.*;
    import C.errno.*;
    import C.netdb.*;
    import C.netinet.*;
    import C.sys.socket.*;
    import C.unistd.*;
    
    import flash.utils.ByteArray;
    
    /**
     * The HTTP Connection class.
     * 
     * <p>
     * We use sockets to make the connection,
     * everything is direct, no PROXY or SOCKS.
     * </p>
     * 
     * <p>
     * IP addresses can be IPv4 or IPv6, we support both.
     * </p>
     * 
     * <p>
     * By default, the class does not throw any errors
     * so if a problem occurs nothing will happen,
     * you need to <code>enableErrorChecking = true</code>
     * to see those errors.
     * </p>
     */
    public class HttpConnection
    {

        /**
         * The default <b>HTTP</b> port (<code>80</code>).
         */ 
        public static const DEFAULT_PORT:int = 80;
        
        
        private var _enableErrorChecking:Boolean;
        
        private var _connected:Boolean;
        
        private var _addrlist:Array;
        private var _sockfd:int;
        private var _info:addrinfo;
        
        
        private var _localAddress:String;
        private var _localPort:int;
        
        private var _remoteAddress:String;
        private var _remotePort:int;
        
        private var _remoteAddresses:Array;
        
        /**
         * Function hook for the "connect" event.
         */ 
        public var onConnect:Function;/* = function():void
        {
            trace( "onConnect()" );
        }*/
        
        /**
         * Function hook for the "disconnect" event.
         */ 
        public var onDisconnect:Function;/* = function():void
        {
            trace( "onDisconnect()" );
        }*/
        
        /**
         * Function hook for the "send" event.
         */ 
        public var onSend:Function;/* = function():void
        {
            trace( "onSend( bytes:ByteArray, total:int )" );
        }*/
        
        /**
         * Function hook for the "receive" event.
         */ 
        public var onReceive:Function;/* = function():void
        {
            trace( "onReceive( bytes:ByteArray, total:int )" );
        }*/
        

        /**
         * Creates an HTTP connection.
         * 
         * @param enableErrorChecking Enable error checking if set to <code>true</code>.
         */
        public function HttpConnection( enableErrorChecking:Boolean = false )
        {
            super();
            //trace( "HttpConnection.ctor()" );
            
            _enableErrorChecking = enableErrorChecking;
            _reset();
        }
        
        private function _reset():void
        {
            //trace( "HttpConnection._reset()" );

            _connected = false;
            
            _addrlist = null;
            _sockfd   = -1;
            _info     = null;
            
            _localAddress  = "";
            _localPort     = -1;
            _remoteAddress = "";
            _remotePort    = -1;
            
            _remoteAddresses = null;
        }

        private function _open( hostname:String, port:String ):int
        {
            //trace( "HttpConnection._open()" );

            var hints:addrinfo = new addrinfo();
                hints.ai_socktype = SOCK_STREAM;
                hints.ai_family   = AF_UNSPEC;

            var eaierr:CEAIrror = new CEAIrror();
            var addrlist:Array  = getaddrinfo( hostname, port, hints, eaierr );
            
            if( !addrlist )
            {
                if( enableErrorChecking ) { throw eaierr; }
                
                return -1;
            }

            _addrlist = addrlist;
            
            var i:uint;
            var info:addrinfo;
            var sockfd:int;
            var result:int;
            
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
                
                result = connect( sockfd, info.ai_addr );
                if( result < 0 )
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
                _remoteAddress = a;
            }
            
            _remotePort = ntohs( _info.ai_addr.sin_port );
            
            return sockfd;
        }

        private function _findLocalAddressAndPort():void
        {
            //trace( "HttpConnection._findLocalAddressAndPort()" );
            
            var addr:sockaddr_in = new sockaddr_in();
            
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
                    _localAddress = a;    
                }
                
                _localPort = ntohs( addr.sin_port );
            }
        }
        
        private function _listRemoteAddresses():Array
        {
            //trace( "HttpConnection._listRemoteAddresses()" );
            
            var addresses:Array = [];
            
            if( !_addrlist ) { return addresses; }
            
            var i:uint;
            var info:addrinfo;
            
            for( i = 0; i < _addrlist.length; i++ )
            {
                info = _addrlist[i];
                addresses.push( inet_ntop( info.ai_family, info.ai_addr ) );
            }
            
            return addresses;
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
        
        /**
         * Indicates if we are connected to the host. 
         */
        public function get connected():Boolean { return _connected; }
        
        /**
         * The local IP address.
         */
        public function get localAddress():String { return _localAddress; }
        
        /**
         * The local port.
         */
        public function get localPort():int { return _localPort; }

        /**
         * The remote IP address.
         */
        public function get remoteAddress():String { return _remoteAddress; }

        /**
         * The remote port.
         */
        public function get remotePort():int { return _remotePort; }
        
        /**
         * A list of remote IP addresses if the target host has more than one
         * (load balancing, DNS round robin, etc.).
         */
        public function get remoteAddresses():Array
        {
            if( !_remoteAddresses )
            {
                _remoteAddresses = _listRemoteAddresses();
            }
            
            return _remoteAddresses;
        }
         
        /**
         * Open a connection to a <code>host</code> on a specific <code>port</code>.
         * 
         * <p>
         * Will call the <code>onConnect()</code> function if defined.
         * </p>
         * 
         * @param host The remote host to connect to.
         * @param port The port to connect to (optional, default to <code>80</code>).
         * 
         * Errors
         * "CEAIrror: EAI_NONAME #8: nodename nor servname provided, or not known"
         * the host provided was not found
         * 
         * "CError: ETIMEDOUT #60: Operation timed out"
         * most likely the port provided is not opne on this particular host
         * (for ex: try to connect on www.comain.com on port 8080 when only port 80 is open)
         * 
         */
        public function open( host:String, port:int = -1 ):void
        {
            //trace( "HttpConnection.open()" );
            
            if( port == -1 )
            {
                port = DEFAULT_PORT;
            }
            
            var sockfd:int = _open( host, String( port ) );
            
            if( sockfd == -1 )
            {
                //trace( "Could not connect" );
                if( enableErrorChecking )
                {
                    throw new Error( "Could not connect to " + host + ":" + port );
                }
            }
            else
            {
                _sockfd = sockfd;
                _connected = true;
                _findLocalAddressAndPort();
                
                if( onConnect ) { this.onConnect(); }
            }
        }

        /**
         * Close the connection.
         * 
         * <p>
         * Will call the <code>onDisconnect()</code> function if defined.
         * </p>
         */
        public function close():void
        {
            //trace( "HttpConnection.close()" );
            
            if( !_connected )
            {
                /* NOTE
                   never connected
                   or already disconnected
                */
                return;
            }
            
            var result:int = C.unistd.close( _sockfd );
            if( result == -1 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onDisconnect ) { this.onDisconnect(); }
            _reset();
        }

        public function send( bytes:ByteArray ):void
        {
            var sent:int = sendall( _sockfd, bytes );
            if( sent < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onSend ) { this.onSend( bytes, sent ); }
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
        
        public function receive():ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            var received:int = _receiveAll( _sockfd, bytes );
            if( received < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onReceive ) { this.onReceive( bytes, received ); }
            return bytes;
        }
        
        
        /**
         *
         */
        public function toString():String
        {
            //trace( "HttpConnection.toString()" );

            var str:String = "";
                str += "{HttpConnection";

            if( connected )
            {
                str += " connected:";
                str += " " + localAddress;
                str += ":" + localPort;
                str += " =>";
                str += " " + remoteAddress;
                str += ":" + remotePort;
            }
            else
            {
                str += " disconnected";
            }
            
                str += " ";
                str += "}";

            return str;
        }
    }

}
