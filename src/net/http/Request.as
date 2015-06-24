package net.http
{
    
    /**
     * The contract of an HTTP Request.
     */
    public interface Request
    {
        
        /**
         * The HTTP method of the request.
         */
        function get method():String;
        
        /**
         * The content type of the request.
         */
        function get contentType():String;
        
        /**
         * The associated headers value-pairs.
         */
        function get headers():Array;
        
    }
}