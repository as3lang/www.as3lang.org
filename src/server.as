
include "includes.as";

import net.http.HttpServer;

var server:HttpServer;

try
{
    server = new HttpServer( true );
    server.listen( 8080 );
    server.start();
}
catch( e:Error )
{
    //trace( "Content-Type: text/plain; charset=utf-8" );
    //trace( "" );
    trace( e.getStackTrace() );
}
