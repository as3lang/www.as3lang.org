package net.http.sessions
{
    
    /**
     * The contract of an HTTP Session Storage.
     * 
     * <p>
     * The <code>Session</code> and the <code>SessionStorage</code>
     * seems similar (same methods name) but don't let that fool you,
     * they have clear differences. 
     * 
     * The <code>Session</code> handle the logic, the state,
     * the life cycle of the session.
     * 
     * The <code>SessionStorage</code> handle the data
     * and can throw errors.
     * 
     * It is the responsibility of the <code>Session</code>
     * to apply logic or check status to know if it can run
     * a <code>SessionStorage</code> method or not,
     * and catch their errors.
     * </p>
     */
    public interface SessionStorage
    {
        
        /**
         * The data root node.
         */
        function get data():Object;
        
        /**
         * The user remote IP address.
         */
        function get ipaddress():String;
        /** @private */
        function set ipaddress( value:String ):void;
        
        /**
         * The creation date of the storage.
         */
        function get created():Date;
        
        /**
         * The last accessed/modified date of the storage.
         */
        function get synchronised():Date;
        
        /**
         * The size of the data in bytes.
         */
        function get size():Number;
        
        /**
         * Returns true if the storage data verify
         * a list of rules, otherwise returns false. 
         */
        function isValid():Boolean;
        
        /**
         * Create the data into the storage
         * or resume the data from the storage.
         */
        function open():void;
        
        /**
         * Reset the data in storage.
         */
        function clear():void;
        
        /**
         * Retrieve the data from storage.
         */
        function load():void;
        
        /**
         * Writes the data into the storage.
         */
        function flush():void;
        
        /**
         * Destroy the storage.
         */
        function destroy():void;
    }
}