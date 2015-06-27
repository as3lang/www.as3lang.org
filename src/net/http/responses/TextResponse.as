package net.http.responses
{
    import net.http.cgi.CommonResponse;
    import net.mediatypes.text.TEXT_UTF8;
    
    public class TextResponse extends CommonResponse
    {
        public function TextResponse( text:String = "", type:String = "" )
        {
            super();
            
            this.body = text;
            
            if( type == "" )
            {
                this.contentType = TEXT_UTF8.toString();
            }
        }
    }
}