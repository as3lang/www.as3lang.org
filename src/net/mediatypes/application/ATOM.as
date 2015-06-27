package net.mediatypes.application
{
    import net.mediatypes.MediaType;

    public const ATOM:MediaType = new MediaType( "application", "atom", [".atom", ".xml"] );
                 ATOM.name = "Atom Syndication Format";
                 ATOM.suffix = "xml";
    
}