package net.http.cgi
{
    import net.http.Request;
    import net.http.RequestMethod;
    import net.http.Response;
    import net.http.router.Route;
    import net.http.router.Router;
    import net.http.router.Rule;
    import net.http.router.rules.RegExpRule;
    import net.http.router.rules.StaticRule;
    
    public class CommonRouter implements Router
    {
        
        private var _options:Array;
        private var _get:Array;
        private var _head:Array;
        private var _post:Array;
        private var _put:Array;
        private var _delete:Array;
        private var _trace:Array;
        
        private var _notfound:Rule;
        
        public function CommonRouter( notfound:Rule )
        {
            super();
            
            _options = [];
            _get     = [];
            _head    = [];
            _post    = [];
            _put     = [];
            _delete  = [];
            _trace   = [];
            
            _notfound = notfound;
        }
        
        private function _bookend( str:String ):String
        {
            return "^" + str + "$";
        }
        
        private function _capture( name:String ):String
        {
            return name.replace( /\*+/g, "(.*)" ).replace( /:([\w\-]+)/g, "(?P<$1>[\\w\\-]+)" );
        }
        
        private function _add( rule:Rule, method:String = "" ):void
        {
            switch( method )
            {
                case RequestMethod.OPTIONS:
                _options.push( rule );
                break;
            
                case RequestMethod.HEAD:
                _head.push( rule );
                break;
                
                case RequestMethod.POST:
                _post.push( rule );
                break;
            
                case RequestMethod.PUT:
                _put.push( rule );
                break;
            
                case RequestMethod.DELETE:
                _delete.push( rule );
                break;
                
                case RequestMethod.TRACE:
                _trace.push( rule );
                break;
            
                case RequestMethod.GET:
                case "":
                default:
                _get.push( rule );
            }
        }
        
        private function _hasRoute( route:String, data:Array ):Boolean
        {
            var rule:Rule;
            for each( rule in data )
            {
                if( rule.matches( route ) )
                {
                    return true;
                }
            }
            
            return false;
        }
        
        private function _route( route:String, data:Array, request:Request ):Response
        {
            var r:Route;
            var rule:Rule;
            
            for each( rule in data )
            {
                if( rule.matches( route ) )
                {
                    r = rule.execute( route, request );
                    return rule.call( r );
                }
            }
            
            r = _notfound.execute( route, request );
            return _notfound.call( r );
        }
        
        private function _list( method:String, data:Array ):Array
        {
            var routes:Array = [];
            var len:uint = data.length;
            var i:uint;
            
            for( i = 0; i < len; i++ )
            {
                routes.push( method + " " + data[i].name );
            }
            
            return routes;
        }
        
        /** @inheritDoc */
        public function map( route:String, callback:Function,
                             method:String=  "" ):void
        {
            var pattern:String;
            
            if( (route == "") || (route == "/") )
            {
                pattern = _bookend( "/?" );
            }
            else
            {
                pattern = _bookend( _capture( route ) );
            }
            
            mapPattern( route, new RegExp( pattern ), callback, method );
        }
        
        /** @inheritDoc */
        public function mapStatic( route:String, callback:Function,
                                   method:String = "" ):void
        {
            _add( new StaticRule( route, route, callback, method), method );
        }
        
        /** @inheritDoc */
        public function mapPattern( name:String, pattern:RegExp, callback:Function,
                                    method:String = "" ):void
        {
            _add( new RegExpRule( name, pattern, callback, method), method );
        }
        
        /** @inheritDoc */
        public function hasRoute( route:String, method:String = "" ):Boolean
        {
            switch( method )
            {
            
                case RequestMethod.OPTIONS:
                return _hasRoute( route, _options );
                break;
           
                case RequestMethod.HEAD:
                return _hasRoute( route, _head );
                break;
            
                case RequestMethod.POST:
                return _hasRoute( route, _post );
                break;
            
                case RequestMethod.PUT:
                return _hasRoute( route, _put );
                break;
            
                case RequestMethod.DELETE:
                return _hasRoute( route, _delete );
                break;
                       
                case RequestMethod.TRACE:
                return _hasRoute( route, _trace );
                break;
            
                case RequestMethod.GET:
                case "":
                default:
                return _hasRoute( route, _get );
            }
        }
        
        /** @inheritDoc */
        public function route( route:String,
                               method:String = "", request:Request = null ):Response
        {
            /* Note:
               each time we recevie a route the method can be different
               and so we have to update "notfound" accordingly
            */
            _notfound.update( method );
            
            switch( method )
            {
            
                case RequestMethod.OPTIONS:
                return _route( route, _options, request );
                break;
            
                case RequestMethod.HEAD:
                return _route( route, _head, request );
                break;
            
                case RequestMethod.POST:
                return _route( route, _post, request );
                break;
            
                case RequestMethod.PUT:
                return _route( route, _put, request );
                break;
            
                case RequestMethod.DELETE:
                return _route( route, _delete, request );
                break;
                
                case RequestMethod.TRACE:
                return _route( route, _trace, request );
                break;
            
                case RequestMethod.GET:
                case "":
                default:
                _notfound.update( RequestMethod.GET );
                return _route( route, _get, request );
            }
        }
        
        /** @inheritDoc */
        public function list( method:String = "" ):Array
        {
            var routes:Array = [];
            
            /* "not found" is a special case as it
               supports ANY request methods
            */
            routes.push( "ANY " + _notfound.name );
            
            if( (method == RequestMethod.OPTIONS) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.OPTIONS, _options ) );
            }
            
            if( (method == RequestMethod.GET) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.GET, _get ) );
            }
            
            if( (method == RequestMethod.HEAD) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.HEAD, _head ) );
            }
            
            if( (method == RequestMethod.POST) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.POST, _post ) );
            }
            
            if( (method == RequestMethod.PUT) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.PUT, _put ) );
            }
            
            if( (method == RequestMethod.DELETE) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.DELETE, _delete ) );
            }
            
            if( (method == RequestMethod.TRACE) || (method == "") )
            {
                routes = routes.concat( _list( RequestMethod.TRACE, _trace ) );
            }
            
            return routes;
        }
    }
}