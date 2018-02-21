package shoe3d.core;
import haxe.macro.Context;
import haxe.macro.Type.ClassType;
import haxe.macro.Type;
import shoe3d.util.Macros;
import haxe.macro.Expr;

/**
 * ...
 * @author as
 */

using Lambda;

class ComponentBuilder
{

    public static function build()
    {
        var pos = Context.currentPos();
        var cl = Context.getLocalClass().get();

        var name = Context.makeExpr( getComponentName(cl), pos );
        var type = TPath({pack: cl.pack, name: cl.name, params: []});
        //trace( Context.getLocalClass().get().pack );
        var fields = Macros.buildFields( macro
        {
            #if doc @:noDoc #end
            var public__static__inline__NAME = $name;
        });
        if ( extendsComponentBase(cl) )
        {
            fields = fields.concat( Macros.buildFields( macro
            {
                function override__private__get_name():String {
                    return $name;
                }
            }));
        }

        return fields.concat( Context.getBuildFields() );
    }

    private static function getComponentName (cl :ClassType) :String
    {
        while (true)
        {
            if (extendsComponentBase(cl))
            {
                break;
            }
            cl = cl.superClass.t.get();
        }

        var fullName = cl.pack.concat([cl.name]).join(".");
        var name = _nameCache.get(fullName);
        if (name == null)
        {
            name = cl.name + "_" + _nextId;
            _nameCache.set(fullName, name);
            ++_nextId;
            //trace(fullName, name);
        }

        return name;
    }

    private static function extendsComponentBase (cl :ClassType)
    {
        var superClass = cl.superClass.t.get();
        return superClass.meta.has(":componentBase");
    }

    private static var _nameCache = new Map<String,String>();
    private static var _nextId = 0;

}