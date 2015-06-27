package net.http.router.routes
{
    import net.http.Request;
    
    public class RegExpRoute extends CommonRoute
    {
        
        private var _params:Object;
        
        public function RegExpRoute( value:String,
                                     method:String = "", request:Request = null,
                                     captures:Array = null, params:Object = null )
        {
            super( value, method, request );
            
            _params = {};
            
            if( captures )
            {
                _captures = captures;
            }
            
            if( params )
            {
                _params = params;
            }
        }
        
        override public function get rawparams():Object { return _params; }
        
        override public function params( key:String ):String
        {
            return _params[ key ];
        }
    }
}