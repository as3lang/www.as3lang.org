package net.http.router.rules
{
    import net.http.Request;
    import net.http.Response;
    import net.http.router.Route;
    import net.http.router.Rule;
    import net.http.router.routes.CommonRoute;
    
    /**
     * Rule that apply when a route is not a found.
     */
    public class NotFoundRule implements Rule
    {
        
        private var _name:String;
        private var _callback:Function;
        private var _method:String;
        
        public function NotFoundRule( name:String, callback:Function,
                                      method:String = "" )
        {
            super();
            
            _name     = name;
            _callback = callback;
            _method   = method;
        }
        
        /** @inheritDoc */
        public function get name():String { return _name; }
        
        /** @inheritDoc */
        public function matches(route:String):Boolean
        {
            return true;
        }
        
        /** @inheritDoc */
        public function execute( route:String, request:Request = null ):Route
        {
            var r:Route = new CommonRoute( route, _method, request );
            return r;
        }
        
        /** @inheritDoc */
        public function update( method:String ):void
        {
            _method = method;
        }
        
        /** @inheritDoc */
        public function call( route:Route ):Response
        {
            return _callback( route );
        }
    }
}