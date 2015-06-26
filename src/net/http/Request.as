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
        /** @private */
        function set method( value:String ):void;
        
        /**
         * The content type of the request.
         */
        function get contentType():String;
        /** @private */
        function set contentType( value:String ):void
        
        /**
         * The associated headers value-pairs.
         */
        function get headers():Array;
        /** @private */
        function set headers( value:Array ):void;
        
    }
}