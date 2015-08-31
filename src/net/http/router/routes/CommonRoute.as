package net.http.router.routes
{
    import net.http.Gateway;
    import net.http.Request;
    import net.http.router.Route;
    
    public class CommonRoute implements Route
    {
        
        private var _method:String;
        private var _value:String;
        private var _gateway:Gateway;
        protected var _captures:Array;
        
        public function CommonRoute( value:String,
                                     method:String = "", gateway:Gateway = null )
        {
            super();
            
            _value    = value;
            _method   = method;
            _gateway  = gateway;
            _captures = [];
        }
        
        /** @inheritDoc */
        public function get value():String { return _value; }
        
        /** @inheritDoc */
        public function get method():String { return _method; }
        
        /** @inheritDoc */
        public function get request():Request { return _gateway.request; }
        
        /** @inheritDoc */
        public function get gateway():Gateway { return _gateway; }
        
        /** @inheritDoc */
        public function get captures():Array { return _captures; }
        
        /** @inheritDoc */
        public function get rawparams():Object { return null; }
        
        /** @inheritDoc */
        public function params( key:String ):String
        {
            return null;
        }
    }
}