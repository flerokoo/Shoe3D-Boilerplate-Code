package shoe3d.util;
import js.Three;
import js.three.Object3D;
import js.three.Texture;
import js.three.TextureFilter;

/**
 * ...
 * @author asd
 */
class ThreeTools 
{

    public static function disposeObject3DRecursive(v:Object3D)
    {
        if ( untyped v.geometry != null ) 
        {
            untyped v.geometry.dispose();
        }
        
        if ( untyped v.material != null ) 
        {
            untyped v.material.dispose();
        }
        
        for ( i in v.children )
        {
            disposeObject3DRecursive( i );
        }
    }
    
    public static function findChildInObject3D ( object:Object3D, name:String )
    {
        name = name.toLowerCase();    
        
        for ( i in object.children )
        {
            if ( i.name.toLowerCase() == name ) 
            {
                    return i;
            }
        }
        
        return null;
    }
    
    public static function setTextureFilters( tex:Texture, min:TextureFilter, ?mag:TextureFilter )
    {
        if ( mag == null ) mag = min;
        
        tex.minFilter = min;
        tex.magFilter = mag;
    }
    
    
}