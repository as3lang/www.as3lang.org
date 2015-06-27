package net.http.router
{
    import net.http.Request;
    
    /**
     * The contract of a Route object.
     */
    public interface Route
    {
        
        /**
         * The string value that triggered this route.
         */
        function get value():String;
        
        /**
         * A collection of all keywords captured in the route.
         */
        function get captures():Array;
        
        /**
         * The HTTP Request method associated with this route.
         */
        function get method():String;
        
        /**
         * The query string object map associated with this route.
         */
        function get rawparams():Object;
        
        /**
         * The Request object that triggered this route.
         */
        function get request():Request;
        
        /**
         * Returns a value for a named capture (eg. keyword) in a route.
         * 
         * @param key the name of the keyword.
         * 
         * @return the value of the keyword.
         */
        function params( key:String ):String;
        
    }
}