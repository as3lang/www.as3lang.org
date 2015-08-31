package net.http.sessions
{
    
    /**
     * The contract of an HTTP Session.
     * 
     * <p>
     * A user session to store user data server side.
     * </p>
     * 
     */
    public interface Session
    {
        
        /**
         * The session identifier
         */
        function get id():String;
        
        /**
         * The session user data.
         */
        function get data():Object;
        
        /**
         * Start the session.
         * 
         * <p>
         * If the session does not already exists
         * a unique identifier is generated
         * and a session storage is created.
         * </p>
         * 
         * <p>
         * If the session already exists
         * the unique identifier is retrieved
         * and the session storage is resumed.
         * </p>
         */
        function start():void;

        /**
         * Clear the data of the session.
         */
        function clear():void;
        
        /**
         * Stop the session.
         * 
         * <p>
         * From that point no more data can be
         * saved into the session storage.
         * </p>
         */
        function stop():void;

        /**
         * Delete the session.
         * 
         * <p>
         * Directly delete the session storage
         * and mark the session to be deleted
         * in the session manager (it will delete
         * the session cookie from the client).
         * </p>
         * 
         */
        function destroy():void;
    }
}