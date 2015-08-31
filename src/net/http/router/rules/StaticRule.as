package net.http.router.rules
{
    import net.http.Gateway;
    import net.http.Response;
    import net.http.router.Route;
    import net.http.router.Rule;
    import net.http.router.routes.CommonRoute;
    
    public class StaticRule implements Rule
    {
        
        private var _name:String;
        private var _path:String;
        private var _callback:Function;
        private var _method:String;
        
        public function StaticRule( name:String, path:String, callback:Function,
                                    method:String = "" )
        {
            super();
            
            _name     = name;
            _path     = path;
            _callback = callback;
            _method   = method;
        }
        
        /** @inheritDoc */
        public function get name():String { return _name; }
        
        /** @inheritDoc */
        public function matches( route:String ):Boolean
        {
            return _path == route;
        }
        
        /** @inheritDoc */
        public function execute( route:String, gateway:Gateway = null ):Route
        {
            var r:Route = new CommonRoute( route, _method, gateway );
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