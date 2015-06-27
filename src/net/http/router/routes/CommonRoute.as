package net.http.router.routes
{
    import net.http.Request;
    import net.http.router.Route;
    
    public class CommonRoute implements Route
    {
        
        private var _method:String;
        private var _value:String;
        private var _request:Request;
        protected var _captures:Array;
        
        public function CommonRoute( value:String,
                                     method:String = "", request:Request = null )
        {
            super();
            
            _value    = value;
            _method   = method;
            _request  = request;
            _captures = [];
        }
        
        /** @inheritDoc */
        public function get value():String { return _value; }
        
        /** @inheritDoc */
        public function get method():String { return _method; }
        
        /** @inheritDoc */
        public function get request():Request { return _request; }
        
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