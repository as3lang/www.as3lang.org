package net.http.web
{
    import net.http.Configuration;
    import net.http.Gateway;
    import net.http.HttpRequest;
    import net.http.HttpResponse;
    import net.http.Request;
    import net.http.Response;
    import net.http.StatusCode;
    import net.http.cgi.CommonGateway;
    import net.http.cgi.CommonRouter;
    import net.http.responses.TextResponse;
    import net.http.router.Route;
    import net.http.router.Router;
    import net.http.router.Rule;
    import net.http.router.rules.NotFoundRule;
    import net.http.sessions.Session;
    import net.http.sessions.SessionManager;
    
    /**
     * Our first advanced Gateway :).
     * 
     * Here we will basically merge the features of
     * a CommonGateway (made to deal with CGI)
     * and a Router (made to deal with different URL paths)
     */
    public class WebGateway extends CommonGateway implements Router
    {
        protected var _apache:ApacheEnvironment;
        private var _notfound:Rule;
        private var _router:Router;
        private var _sessionManager:SessionManager;
        
        public function WebGateway( config:Configuration = null )
        {
            if( !config )
            {
                var webconf:WebConfig = new WebConfig();
                config = webconf;
            }
            
            super( config );
            
            _apache         = new ApacheEnvironment();
            _notfound       = new NotFoundRule( "{404}", onNotFound );
            _router         = new CommonRouter( _notfound );
            _sessionManager = new SessionManager( this );
            
            _destination = buildDestination();
        }
        
        /** @inheritDoc */
        override protected function buildDestination():String
        {
            /* Note:
               With other HTTP server it could change
               eg. nginx, IIS, etc. may have different env vars
            
               Here we decide to took the Apache env
               because we want to operate as one app
               that handle many URLs with a router
            */
            // 3. Apache env POV
            var dest:String = _apache.requestURI;
            
            return dest;
        }
        
        /**
         * Gives access to the <code>SessionManager</code>.
         * 
         * @example Usage
         * <listing>
         * public static function onRoot( r:Route ):Response
         * {
         *     var config:WebConfig = r.gateway.config as WebConfig;
         *     var sessions:SessionManager = WebGateway( r.gateway ).sessions;
         *     var session:Session = sessions.getUserSession();
         *         session.start();
         * 
         *     trace( "user session ID = " + session.id );
         * }
         * </listing>
         */ 
        public function get sessions():SessionManager { return _sessionManager; }
        
        /** @inheritDoc */
        public function map( route:String, callback:Function,
                             method:String = "" ):void
        {
            _router.map( route, callback, method );
        }
        
        /** @inheritDoc */
        public function mapStatic( route:String, callback:Function,
                                   method:String = "" ):void
        {
            _router.mapStatic( route, callback, method );
        }
        
        /** @inheritDoc */
        public function mapPattern( name:String, pattern:RegExp, callback:Function,
                                    method:String = "" ):void
        {
            _router.mapPattern( name, pattern, callback, method );
        }
        
        /** @inheritDoc */
        public function hasRoute(route:String, method:String = "" ):Boolean
        {
            return _router.hasRoute( route, method );
        }
        
        /** @inheritDoc */
        public function route( route:String,
                               method:String = "", gateway:Gateway = null ):Response
        {
            /* Because we are inside a Gateway
               we can automatically inject ourselves
               into the router.
            */
            return _router.route( route, method, this );
        }
        
        /** @inheritDoc */
        public function list( method:String = "" ):Array
        {
            return _router.list( method );
        }
        
        /**
         * Allows to check out all the requests received to the gateway
         * 
         * example:
         * you want to check if the user has a Google Analytics ID
         * 
         * <listing>
         * public override function onEveryRequest( request:Request ):Request
         * {
         *     var cr:CommonRequest = request as CommonRequest;
         *     if( cr.hasHeader( "Cookie" ) )
         *     {
         *         var cookie:Header = cr.getHeader( "Cookie" );
         *         if( cookie.value.indexOf( "_ga" ) > -1 )
         *         {
         *             // retrieve the Google Analytics ClientID
         *         }
         *     }
         * }
         * </listing>
         */
        public function onEveryRequest( request:Request ):Request
        {
            // by default we leave the request untouched
            return request;
        }

        /**
         * Allows to update all the reponses sent from the gateway
         * 
         * example:
         * you want to add a header to all outgoing responses
         * 
         * <listing>
         * public override function onEveryResponse( response:Response ):Response
         * {
         *     var header:Header = new HttpHeader( "X-Powered-By", "redtamarin/" + Runtime.redtamarin );
         *     CommonResponse(response).addHeader( header, true );
         *     return response;
         * }
         * </listing>
         */
        public function onEveryResponse( response:Response ):Response
        {
            // by default we leave the response untouched
            return response;
        }
        
        /**
         * Allows to customise the "not authorized" response.
         */
        public function onNotAuthorized( r:Route ):Response
        {
            var page:Response = new TextResponse();
                page.status = StatusCode.UNAUTHORIZED.toString();
                page.body   = "you are not authorized to access this page";
            
            return page;
        }
        
        /**
         * Allows to customise the "not found" response.
         */
        public function onNotFound( r:Route ):Response
        {
            var method:String = r.method;
            if( method == "" ) { method = "ANY"; }
            
            var page:TextResponse = new TextResponse();
                page.status = StatusCode.fromCode( "404" ).toString();
                page.body += "page not found:\n";
                page.body += method + " \"" + r.value + "\" does not exists.";
            
            return page;
        }
        
        /** @inheritDoc */
        //public override function apply( request:Request ):Response
        public function apply2( request:Request ):Response
        {
            if( !authorized() )
            {
                return onNotAuthorized( null );
            }
            
            request = onEveryRequest( request );
            var response:Response = route( destination, request.method );
            return onEveryResponse( response );
        }
        
        //public function apply2( request:Request ):Response
        public override function apply( request:Request ):Response
        {
            var webconfig:WebConfig = config as WebConfig; 
            var sess:Session;
            
            if( !authorized() )
            {
                return onNotAuthorized( null );
            }
            
            request = onEveryRequest( request );
            
            if( webconfig.sessionEnabled &&
                webconfig.sessionAutoStart )
            {
                //auto start the session
                var uuid:String = _sessionManager.findToken( request as HttpRequest );
                sess = _sessionManager.getUserSession();
                sess.start();
            }
            
            var response:Response = route( destination, request.method );
            
            if( webconfig.sessionEnabled )
            {
                //auto stop the session
                sess = _sessionManager.getUserSession();
                if( sess )
                {
                    sess.stop();
                }
                
                //if new we create the client cookie
                if( _sessionManager.isNew )
                {
                    _sessionManager.applyTo( response as HttpResponse );
                }
                
                //if destroyed we override the client cookie expires
                if( _sessionManager.needCleanUp )
                {
                    _sessionManager.cleanUp( response as HttpResponse );
                }
            }
            
            return onEveryResponse( response );
        }
    }
}