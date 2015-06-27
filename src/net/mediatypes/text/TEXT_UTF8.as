package net.mediatypes.text
{
    import net.mediatypes.MediaType;
    
    public const TEXT_UTF8:MediaType = new MediaType( "text", "plain", [".txt"] );
                 TEXT_UTF8.name = "Text File";
                 TEXT_UTF8.parameters = "charset=utf-8";
    
}