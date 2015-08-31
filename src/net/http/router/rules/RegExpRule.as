package net.http.router.rules
{
    import net.http.Gateway;
    import net.http.Response;
    import net.http.router.Route;
    import net.http.router.Rule;
    import net.http.router.routes.RegExpRoute;
    
    public class RegExpRule implements Rule
    {
        
        private var _name:String;
        private var _pattern:RegExp;
        private var _callback:Function;
        private var _method:String;
        
        public function RegExpRule( name:String, pattern:RegExp, callback:Function,
                                    method:String = "" )
        {
            super();
            
            _name     = name;
            _pattern  = pattern;
            _callback = callback;
            _method   = method;
        }
        
        private function _parseParams( o:* ):Object
        {
            var obj:Object = {};
            var m:String = null;
            
            for( m in o )
            {
                switch( m )
                {
                case "0":
                case "1":
                case "2":
                case "3":
                case "4":
                case "5":
                case "6":
                case "7":
                case "8":
                case "9":
                case "input":
                case "index":
                    break;
                
                default:
                    obj[ m ] = o[ m ];
                }
            }
            
            return obj;
        }
        
        private function _parseArgs( o:* ):Array
        {
            var args:Array = [];
            var i:uint;
            var len:uint;
            
            if( o )
            {
                len = o.length;
                for( i = 1; i < len; i++ )
                {
                    args.push( o[i] );
                }
            }
            
            return args;
        }
        
        /** @inheritDoc */
        public function get name():String { return _name; }
        
        /** @inheritDoc */
        public function matches( route:String ):Boolean
        {
            return _pattern.test( route );
        }
        
        /** @inheritDoc */
        public function execute( route:String, gateway:Gateway = null ):Route
        {
            var result:*;
            var params:Object = null;
            var args:Array = null;
            var r:Route;
            
            _pattern.lastIndex = 0;
            result = _pattern.exec( route );
            
            if( result )
            {
                params = _parseParams( result );
                args   = _parseArgs( result );
            }
            
            r = new RegExpRoute( route, _method, gateway, args, params );
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