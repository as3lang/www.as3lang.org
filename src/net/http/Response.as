package net.http
{
    
    /**
     * The contract of an HTTP Response.
     */
    public interface Response
    {
        /**
         * 
         */ 
        function get httpRequest():Request;
        /** @private */
        function set httpRequest( value:Request ):void;
        
        /**
         * The content value.
         */
        function get body():String;
        /** @private */
        function set body( value:String ):void;
        
        /**
         * The mime type of the content.
         */
        function get contentType():String;
        /** @private */
        function set contentType( value:String ):void
        
        /**
         * The HTTP status of the response.
         */
        function get status():String;
        /** @private */
        function set status( value:String ):void;
        
        /**
         * The associated headers value-pairs.
         */
        function get headers():Array;
        /** @private */
        function set headers( value:Array ):void;
        
    }
}