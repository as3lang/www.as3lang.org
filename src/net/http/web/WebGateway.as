package net.http.web
{
    import net.URI;
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
    
    /**
     * Our first advanced Gateway :).
     * 
     * Here we will basically merge the features of
     * a CommonGateway (made to deal with CGI)
     * and a Router (made to deal with different URL paths)
     */
    public class WebGateway extends CommonGateway implements Router
    {
        
        private var _apache:ApacheEnvironment;
        private var _uri:URI;
        private var _notfound:Rule;
        private var _router:Router;
        
        public function WebGateway()
        {
            super();
            
            _apache   = new ApacheEnvironment();
            _uri      = null;
            _notfound = new NotFoundRule( "{404}", onNotFound );
            _router   = new CommonRouter( _notfound );
            
            _destination = buildDestination();
        }
        
        override protected function buildDestination():String
        {
            var dest:String = "";
                dest += _apache.requestScheme + "://"; // ex: http://
                dest += _apache.httpHost;              // ex: www.as3lang.org
                dest += _apache.requestURI;            // ex: /some/path
            
            /* If the env vars are not available
               we default to the empty string
            */
            if( dest == "://" )
            {
                dest = "";
            }
            
            return dest;
        }
        
        /**
         * 
         */
        public function get uri():URI
        {
            if( !_uri )
            {
                _uri = new URI( destination );
            }
            
            return _uri;
        }
        
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
                               method:String = "", request:Request = null ):Response
        {
            /* Because we are inside a Gateway
               we already have a request object
               so we can automatically inject it
               into the router.
            
               eg. this.request
            */
            return _router.route( route, method, this.request );
        }
        
        /** @inheritDoc */
        public function list( method:String = "" ):Array
        {
            return _router.list( method );
        }
        
        
        public function onEveryRequest( request:Request ):Request
        {
            return request;
        }
        
        public function onEveryResponse( response:Response ):Response
        {
            return response;
        }
        
        public function onNotAuthorized( r:Route ):Response
        {
            var page:Response = new TextResponse();
                page.status = StatusCode.UNAUTHORIZED.toString();
                page.body   = "you are not authorized to access this page";
            
            return page;
        }
        
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
        
        
        public override function apply( request:Request ):Response
        {
            if( !authorized() )
            {
                return onNotAuthorized( null );
            }
            
            request = onEveryRequest( request );
            var response:Response = route( this.uri.path, request.method );
            return onEveryResponse( response );
        }
    }
}