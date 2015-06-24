
package net.http
{
    import flash.utils.ByteArray;

    /**
     * The HTTP Message class is the base class for <code>HttpRequest</code>
     * and <code>HttpResponse</code>.
     * 
     * <p>
     * A HTTP Message consist of a collection of header fields and an optional body.
     * </p>
     * 
     * <p>
     * All HTTP messages must include the protocol version.
     * </p>
     * 
     * @see https://hc.apache.org/httpcomponents-core-ga/tutorial/html/fundamentals.html HTTP message fundamentals
     */
    public class HttpMessage
    {
        public static const HTTP_1_0:String = "HTTP/1.0";
        public static const HTTP_1_1:String = "HTTP/1.1";
        
        protected var _httpVersion:String;
        
        /* NOTE:
           structures to work with http headers
        
           _headers[0] = new HttpHeader( "test", "hello world" );
           _headers[1] = new HttpHeader( "foobar", "a test" );
           _headers[2] = new HttpHeader( "foobar", "a test" );
           _headers[3] = new HttpHeader( "hello", "world" );
        
           _headersMap[ "test"   ] = [ 0 ];
           _headersMap[ "foobar" ] = [ 1 , 2 ];
           _headersMap[ "hello"  ] = [ 3 ];
        */
        protected var _headers:Array;
        protected var _headersMap:Object;
        
        protected var _body:ByteArray;
        
        /**
         * Creates a HTTP message.
         */
        public function HttpMessage()
        {
            super();
            
            _httpVersion = HTTP_1_1;
            
            _headers    = [];
            _headersMap = {};
            
            _body       = new ByteArray();
            
        }
        
        /* ---- headers ---- */
        
        /** 
         * Search for an HTTP header <code>name</code>.
         * 
         * @param name the header <code>name</code> to find.
         * @return returns <code>true</code> if header <code>name</code> exists,
         * otherwise returns <code>false</code>.
         */ 
        public function hasHeader( name:String ):Boolean
        {
            return _headersMap.hasOwnProperty( name );
        }
        
        /**
         * Add an <code>Httpheader</code>.
         * 
         * @param header the <code>Httpheader</code> to add.
         * @param overwrite overwrite an already existing
         * header if set to <code>true</true>, otherwise add a duplicate.
         */ 
        public function addHeader( header:Header, overwrite:Boolean = false ):void
        {
            var index:uint;
            
            if( !hasHeader( header.name ) )
            {
                _headers.push( header );
                index = _headers.length - 1;
                
                _headersMap[ header.name ] = [];
                _headersMap[ header.name ].push( index );
            }
            else
            {
                if( overwrite )
                {
                    var existing:Header = getHeader( header.name );
                        existing.value = header.value;
                }
                else
                {
                    _headers.push( header );
                    index = _headers.length - 1;
                    
                    _headersMap[ header.name ].push( index );
                }
            }
            
        }
        
        /**
         * Add a <code>name</code> and <code>value</code> as an
         * <code>httpHeader</code>.
         * 
         * @param name The name of the HTTP header.
         * @param value The value of the HTTP header.
         * @param overwrite Overwrite the <code>value</code> of an already
         * existing HTTP header of the same <code>name</code>.
         * 
         * @see addheader
         */ 
        public function addHeaderLine( name:String, value:String = "",
                                       overwrite:Boolean = false ):void
        {
            var header:Header = new HttpHeader( name, value );
            addHeader( header, overwrite );
        }
        
        /**
         * Remove an <code>Httpheader</code>.
         * 
         * <p>
         * If more than one header matches the <cod>name</code>,
         * they are all removed.
         * </p>
         * 
         * @param name the header <code>name</code> to remove.
         */ 
        public function removeHeader( name:String ):void
        {
            if( hasHeader( name ) )
            {
                var indexes:Array = _headersMap[ name ];
                var i:uint;
                var len:uint = indexes.length;
                for( i = 0; i < len; i++ )
                {
                    delete _headers[ indexes[i] ];
                }
                delete _headersMap[ name ];
            }
        }
        
        /**
         * Returns an <code>HttpHeader</code> matching the <code>name</code>,
         * otherwise returns <code>null</code>.
         * 
         * @param name the header <code>name</code> to find.
         */
        public function getHeader( name:String ):Header
        {
            if( hasHeader( name ) )
            {
                return _headers[ _headersMap[ name ][0] ];
            }
            
            return null;
        }
        
        /**
         * Returns the header string matching the <code>name</code>,
         * otherwise returns an empty string.
         * 
         * @param name the header <code>name</code> to find.
         */ 
        public function getHeaderLine( name:String ):String
        {
            if( hasHeader( name ) )
            {
                return _headers[ _headersMap[ name ][0] ].toString();
            }
            
            return "";
        }
        
        /**
         * Returns the header value matching the <code>name</code>,
         * otherwise returns an empty string.
         * 
         * @param name the header <code>name</code> to find.
         */ 
        public function getHeaderValue( name:String ):String
        {
            if( hasHeader( name ) )
            {
                return (_headers[ _headersMap[ name ][0] ] as Header).value;
            }
            
            return "";
        }
        
        /**
         * Returns an <code>Array</code> of <code>httpheader</code> matching
         * the <code>name</code>, otherwise returns an empty <code>Array</code>.
         * 
         * @param name the headers <code>name</code> to find.
         */
        public function getHeaders( name:String ):Array
        {
            var headers:Array = [];
            
            if( hasHeader( name ) )
            {
                var indexes:Array = _headersMap[ name ];
                var i:uint;
                var len:uint = indexes.length;
                for( i = 0; i < len; i++ )
                {
                    headers.push( _headers[ _headersMap[ name ][i] ] );
                }
            }
            
            return headers;
        }
        
        /**
         * The HTTP version of the protocol.
         */
        public function get httpVersion():String { return _httpVersion; }
        /** @private */
        public function set httpVersion( value:String ):void { _httpVersion = value; }
        
        /**
         * Returns a string formated list of all the headers contained
         * in this HTTP Message.
         */
        public function get headers():Array
        {
            var list:Array = [];
            
            var i:uint;
            var len:uint = _headers.length;
            for( i = 0; i < len; i++ )
            {
                if( _headers[i] )
                {
                    list.push( _headers[i].toString() );
                }
            }
            
            return list;
        }
        
        /* Note:
           Allow to add headers in batch
           either
           this.headers = [ new HttpHeader( "hello", "world" ),
                            new HttpHeader( "foobar", "a test" ),
                            new HttpHeader( "another", "test" ) ];
           or
           this.headers = [ ["hello", "world"],
                            ["foobar", "a test"],
                            ["another", "test"] ];
           or even mixed
           this.headers = [ new HttpHeader( "hello", "world" ),
                            ["foobar", "a test"],
                            new HttpHeader( "another", "test" ) ];
        */
        /** @private */
        public function set headers( value:Array ):void
        {
            var i:uint;
            var len:uint = value.length;
            var h:*;
            for( i = 0; i < len; i++ )
            {
                h = value[i];
                if( h is Header )
                {
                    addHeader( h );
                }
                else if( (h is Array) && (h.length == 2) )
                {
                    addHeaderLine( h[0], h[1] );
                }
            }
        }
        
        /**
         * The HTTP header "Content-Type".
         */
        public function get contentType():String
        {
            var header:Header = getHeader( HttpHeader.CONTENT_TYPE );
            if( header )
            {
                return String( header.value );
            }
            
            return "";
        }
        /** @private */
        public function set contentType( value:String ):void
        {
            var header:Header = new HttpHeader( HttpHeader.CONTENT_TYPE, value );
            addHeader( header, true );
        }
        
        /**
         * The HTTP header "Content-Length".
         */
        public function get contentLength():uint
        {
            var header:Header = getHeader( HttpHeader.CONTENT_LENGTH );
            if( header )
            {
                return uint( header.value );
            }
            
            return 0;
        }
        /** @private */
        public function set contentLength( value:uint ):void
        {
            var header:Header = new HttpHeader( HttpHeader.CONTENT_LENGTH, String(value) );
            addHeader( header, true );
        }
        
        /**
         * The HTTP header "Content-Encoding".
         */
        public function get contentEncoding():String
        {
            var header:Header = getHeader( HttpHeader.CONTENT_ENCODING );
            if( header )
            {
                return String( header.value );
            }
            
            return "";
        }
        /** @private */
        public function set contentEncoding( value:String ):void
        {
            var header:Header = new HttpHeader( HttpHeader.CONTENT_ENCODING, value );
            addHeader( header, true );
        }
        
        /**
         * The HTTP header "Accept".
         */
        public function get accept():String
        {
            var header:Header = getHeader( HttpHeader.ACCEPT );
            if( header )
            {
                String( header.value );
            }
            
            return "";
        }
        /** @private */
        public function set accept( value:String ):void
        {
            var header:Header = new HttpHeader( HttpHeader.ACCEPT, value );
            addHeader( header, true );
        }
        
        /**
         * The HTTP header "Accept-Encoding".
         */
        public function get acceptEncoding():String
        {
            var header:Header = getHeader( HttpHeader.ACCEPT_ENCODING );
            if( header )
            {
                String( header.value );
            }
            
            return "";
        }
        /** @private */
        public function set acceptEncoding( value:String ):void
        {
            var header:Header = new HttpHeader( HttpHeader.ACCEPT_ENCODING, value );
            addHeader( header, true );
        }
        
        
        /**
         * Defines "Connection" header as "Keep-Alive" or "Close".
         * <p>
         * Existing value is overwritten.
         * </p>
         */ 
        public function persistence( keepAlive:Boolean = true ):void
        {
            if( keepAlive )
            {
                addHeaderLine( HttpHeader.CONNECTION, HttpHeader.KEEP_ALIVE, true );
            }
            else
            {
                addHeaderLine( HttpHeader.CONNECTION, HttpHeader.CLOSE, true );
            }
        }
        
        /**
         * Returns <code>true</code> if connection is persistent,
         * otherwise returns <code>false</code>.
         * 
         * <p>
         * If "Connection" header does not exist,
         * returns <code>true</code> for HTTP 1.1
         * and <code>false</code> for HTTP 1.0.
         * </p>
         * 
         * <p>
         * If "Connection" header exist, checks if it is equal to "Close".
         * </p>
         * 
         * <p>
         * In HTTP 1.1, all connections are considered persistent unless declared otherwise.
         * Under HTTP 1.0, there is no official specification for how keepalive operates.
         * </p>
         */ 
        public function isConnectionPersistent():Boolean
        {
            var header:Header = getHeader( HttpHeader.CONNECTION );
            
            if( !header )
            {
                return (httpVersion != HTTP_1_0);
            }
            
            return (header.value != HttpHeader.CLOSE);
        }
        
        
        
        /* ---- body ---- */
        
        /**
         * Returns the body content as text.
         */ 
        public function get body():String
        {
            _body.position = 0;
            return _body.readUTFBytes( _body.length );
        }
        /** @private */
        public function set body( value:String ):void
        {
            _body.clear();
            _body.writeUTFBytes( value );
        }
        
        /**
         * Returns the body content as bytes.
         */ 
        public function get bodyBytes():ByteArray
        {
            return _body;
        }
        /** @private */
        public function set bodyBytes( value:ByteArray ):void
        {
            _body.clear();
            _body.writeBytes( value );
        }
        
        public function getBytes():ByteArray
        {
            _body.position = 0;
            return _body;
        }
        
    }

}
