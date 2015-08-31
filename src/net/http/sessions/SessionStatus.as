package net.http.sessions
{
    public class SessionStatus
    {
        
        /**
         * Sessions are disabled.
         */
        public static const disabled:SessionStatus = new SessionStatus( -1, "disabled" );
        
        /**
         * Sessions are enabled, but none exists.
         */
        public static const none:SessionStatus     = new SessionStatus(  0, "none" );
        
        /**
         * Sessions are enabled, and one exists.
         */
        public static const active:SessionStatus   = new SessionStatus(  1, "active" );
        
        /**
         * Sessions were enabled, existed and are now stopped.
         */
        public static const stopped:SessionStatus  = new SessionStatus(  2, "stopped" );
        
        private var _value:int;
        private var _name:String;
        
        public function SessionStatus( value:int = 0, name:String = "" )
        {
            super();
            _value = value;
            _name  = name;
        }
        
        public function toString():String { return _name; }
        
        public function valueOf():int { return _value; }
    }
}