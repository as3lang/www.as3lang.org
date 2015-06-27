package net.http.router
{
    import net.http.Request;
    import net.http.Response;
    
    /**
     * The contract of a Router object.
     * 
     * By default, routes are associated with the HTTP method <code>GET</code>
     * but can be associated with one of: OPTIONS, GET, HEAD, POST, PUT, DELETE,
     * TRACE.
     * 
     * The <code>GET</code> or empty string are considered as the generic
     * <code>ANY</code> method, but if a route and/or method are not defined
     * will resolve to the special "not found" route.
     * 
     * Each mapping is connected to a function callback that can be any type of
     * functions (anonymous, method, static method, etc.), by extension such
     * function could call an event dispatch.
     * 
     * The Router support 3 types of mapping
     * <ul>
     *   <li>routes that may or may not contain keywords</li>
     *   <li>routes that are static (must be the exact path)</li>
     *   <li>routes matching custom regular expressions</li>
     * </ul>
     */
    public interface Router
    {
        
        /**
         * Map a route to a function callback.
         * 
         * <p>
         * The route can contain one or more keywords <code>/path/:keyword</code>
         * and <code>/path/:keyword1/:keyword2</code> etc. 
         * </p>
         * 
         * @param route the route path (that may or may not contains keywords).
         * @param callback the callback function.
         * @param method the specialised HTTP method.
         */
        function map( route:String, callback:Function, method:String = "" ):void;
        
        /**
         * Map a static route to a function callback.
         * 
         * @param route the strict route path.
         * @param callback the callback function.
         * @param method the specialised HTTP method.
         */
        function mapStatic( route:String, callback:Function, method:String = "" ):void;
        
        /**
         * Map a regular expression route to a function callback.
         * 
         * @param name the name of the route.
         * @param pattern the regular expression to match.
         * @param callback the callback function.
         * @param method the specialised HTTP method.
         */
        function mapPattern( name:String, pattern:RegExp, callback:Function, method:String = "" ):void;
        
        /**
         * Checks to see if a route has been mapped.
         * 
         * @param route the route path.
         * @param method the specialised HTTP method.
         * 
         * @return if found returns <code>true</code>, otherwise <code>false</code>.
         */
        function hasRoute( route:String, method:String = "" ):Boolean;
        
        /**
         * Accepts a route path and attempts to dispatch the associated Response object,
         * otherwise will dispatch the "not found" default Response.
         * 
         * @param route the route path.
         * @param method the specialised HTTP method.
         * @param request the original request that triggered the route.
         * 
         * @return a Response object.
         */
        function route( route:String, method:String = "", request:Request = null ):Response;
        
        /**
         * Returns a list of all the routes defined in this Router.
         * 
         * @param method only selected HTTP method.
         * 
         * @return an Array of methods of the format <code>METHOD /route/path</code>.
         */
        function list( method:String = "" ):Array;
        
    }
}