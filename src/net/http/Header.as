package net.http
{
    
    /**
     * The contract of an HTTP Header.
     */
    public interface Header
    {
        
        /**
         * The name of the HTTP header.
         */
        function get name():String;
        
        /**
         * The value of the HTTP header.
         */
        function get value():String;
        /** @private */
        function set value( val:String ):void;
        
    }
}