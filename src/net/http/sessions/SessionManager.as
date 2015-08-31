package net.http.sessions
{
    import crypto.generateUUID;
    
    import net.http.web.WebConfig;
    
    import shell.Domain;
    import net.http.Cookie;
    import net.http.Gateway;
    import net.http.Header;
    import net.http.HttpHeader;
    import net.http.HttpRequest;
    import net.http.HttpResponse;

    /**
     * The SessionManager role is to manage the users sessions.
     * 
     * <p>
     * There are many ways to deal with user sessions:
     * </p>
     * <ul>
     *   <li>Creating a client cookie and saving the data on the client</li>
     *   <li>using a Unique ID, saving the data server side, using the UUID in the URL</li>
     *   <li>using a Unique ID, saving the data server side, creating a client cookie containing the UUID</li>
     *   <li>etc.</li>
     * </ul>
     * 
     * <p>
     * We are very opiniated so we decided to go with what is simple and secure,
     * and so we will not deal with all the different way to do it but one.
     * </p>
     * <ul>
     *   <li>Generate a secure Unique ID</li>
     *   <li>Create a client cookie of the form <code>token=UUID</code></li>
     *   <li>Save the user data server side</li>
     *   <li>etc.</li>
     * </ul>
     * 
     * <p>
     * By default we will use a simple <code>SessionStorage</code> implementation
     * based on the FileSystem (to store the data) and JSON (for the format of the data).
     * 
     * But allow to have different implementations of the <code>SessionStorage</code>
     * to store data as <code>ByteArray</code>, store the data in a database, etc.
     * </p>
     * 
     * <p>
     * The session manager is responsible for accessing the current user session,
     * remembering its state, creating/deleting client cookies.
     * </p>
     * 
     * @see https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP_session_state
     * @see https://en.wikipedia.org/wiki/Session_(computer_science)
     * @see https://en.wikipedia.org/wiki/HTTP_cookie
     */
    public class SessionManager
    {
        
        private var _gateway:Gateway;
        
        private var _status:SessionStatus;
        private var _current:String;
        private var _isNew:Boolean;
        private var _needCleanUp:Boolean;
        private var _todestroy:Array;
        
        private var _session:Session;
        
        public function SessionManager( gateway:Gateway )
        {
            super();
            
            _gateway       = gateway;
            
            var config:WebConfig = _gateway.config as WebConfig;
            
            if( config.sessionEnabled )
            {
                _status    = SessionStatus.none;
            }
            else
            {
                _status    = SessionStatus.disabled;
            }
            
            _current       = "";
            _isNew         = false;
            _needCleanUp   = false;
            _todestroy     = [];
            _session       = null;
        }

        /**
         * The sessions status.
         * 
         * If the sessions are enabled they can have those different states
         *   - none: sessions are enabled but none exists
         *   - active: sessions are enabled and one exists
         *   - stopped: sessions were enabled, existed and are now stopped
         * 
         * A stopped session means
         *   - the data have been saved to the storage
         *   - we should not use this session anymore (at the end of the cycle)
         *   - but if needed we could start the session again
         */
        public function get status():SessionStatus { return _status; }
        /** @private */
        public function set status( value:SessionStatus ):void { _status = value; }
        
        /**
         * The current user session id or the empty string.
         */
        public function get current():String { return _current; }
        /** @private */
        public function set current( value:String ):void { _current = value; }
        
        /**
         * Indicates that the current session is a new created session.
         * 
         * The Gateway need to write a cookie to the client for those new sessions. 
         */
        public function get isNew():Boolean { return _isNew; }
        /** @private */
        public function set isNew( value:Boolean ):void { _isNew = value; }
        
        /**
         * Indicates that the sessions need to be cleaned up.
         * 
         * The Gateway need to destroy one or more sessions.
         */
        public function get needCleanUp():Boolean { return _needCleanUp; }
        /** @private */
        public function set needCleanUp( value:Boolean ):void { _needCleanUp = value; }
        
        /**
         * Obtains a unique identifier.
         * 
         * We use a UUID v4 which is a 16-octet (128-bit) number.
         */
        public function createUUID():String
        {
            return generateUUID();
        }
        
        /**
         * Obtains the user session.
         * 
         * Two things can happen:
         * either the session does not exists and is created
         * or the session already exists and is resumed
         * 
         * Also note that the session object is cached
         */
        public function getUserSession():Session
        {
            if( _session )
            {
                //retrieve from cache
                return _session;
            }
            
            /* Note:
               here we want to dynamically instantiate the class
               so we can build any type of sessions
               
               var session = new FileSession();
               var session = new ByteArraySession();
               var session = new AMFSession();
               var session = new CouchDBSession();
               etc.
            
               this should allow to implement custom sessions
               provided by third party and others
               var session = new MySQLiteSession();
               var session = new InMemorySession();
               etc.
            */
            var config:WebConfig = _gateway.config as WebConfig;
            
            var S:Class = Domain.currentDomain.getClass( config.sessionType );
            var sess:Session = new S( _gateway );
            
            //save into cache
            _session = sess;
            return sess;
        }
        
        /**
         * Try to find the session token name inside an HTTP request.
         * 
         * If found, returns the UUID associated with the token,
         * otherwise returns the empty string.
         */
        public function findToken( request:HttpRequest ):String
        {
            var config:WebConfig = _gateway.config as WebConfig;
            var uuid:String = "";
            
            if( request.hasHeader( HttpHeader.COOKIE ) )
            {
                var header:String = request.getHeaderValue( HttpHeader.COOKIE );
                var cookies:Array = Cookie.parse( header );
                for( var i:uint = 0; i < cookies.length; i++ )
                {
                    var c:Cookie = cookies[i];
                    if( c.name == config.sessionTokenName )
                    {
                        uuid = c.value;
                        return uuid;
                    }
                }
            }
            
            _current = uuid;
            return uuid;
        }
        
        /**
         * Creates a Cookie for the token/UUID value pair.
         */
        public function createToken( uuid:String ):Cookie
        {
            var config:WebConfig = _gateway.config as WebConfig;
            var cookie:Cookie = new Cookie( config.sessionTokenName, uuid );
                cookie.expires  = config.sessionCookieExpires;
                cookie.domain   = config.sessionCookieDomain;
                cookie.path     = config.sessionCookiePath;
                cookie.secure   = config.sessionCookieSecure;
                cookie.httpOnly = config.sessionCookieHttpOnly;
            
            return cookie;
        }
        
        /**
         * Add the current session UUID into the HTTP response header.
         */
        public function applyTo( response:HttpResponse ):void
        {
            if( _isNew && (_current != "") )
            {
                var uuid:String = _current;
                var cookie:Cookie = createToken( uuid );
                var header:Header = new HttpHeader( HttpHeader.SET_COOKIE, cookie.toString() );
                
                //response.addHeaderLine( HttpHeader.SET_COOKIE, cookie.toString() );
                response.addHeader( header );
            }
        }
        
        /**
         * Marks a UUID for deletion.
         */
        public function destroy( uuid:String ):void
        {
            _todestroy.push( uuid );
        }
        
        /* Note:
           The way we delete a cookie is to set its experation date
           to an "older than now" date.
        */
        private function _clean( uuid:String, response:HttpResponse ):void
        {
            var cookie:Cookie = createToken( uuid );
                cookie.expires = -1;
            
            var header:Header = new HttpHeader( HttpHeader.SET_COOKIE, cookie.toString() );
            
            response.addHeader( header );
        }
        
        /**
         * Delete one or more UUID cookies in the HTTP response.
         */
        public function cleanUp( response:HttpResponse ):void
        {
            var len:uint = _todestroy.length; 
            if( len > 0 )
            {
                var i:uint;
                var uuid:String;
                for( i = 0; i < len; i++ )
                {
                    uuid = _todestroy[i];
                    if( uuid != "" )
                    {
                        _clean( uuid, response );
                    }
                }
            }
        }
        
    }
}