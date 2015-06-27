package net.http.router
{
    import net.http.Request;
    import net.http.Response;
    
    /**
     * The contract of a routing Rule object.
     */
    public interface Rule
    {
        
        /**
         * The name associated with the rule.
         */
        function get name():String;
        
        /**
         * Wether or not this rule matches the given route.
         */
        function matches( route:String ):Boolean;
        
        /**
         * Parses the given route and returns a Route object
         * containing match informations.
         */
        function execute( route:String, request:Request = null ):Route;
        
        /**
         * Update the method information.
         */
        function update( method:String ):void;
        
        /**
         * Delegate the route into a callback which then return a Response object.
         */
        function call( route:Route ):Response;
        
    }
}