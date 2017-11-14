package shoe3d.util;

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

class GameMetaBuilder
{

    macro static public function build():Array<Field>
    {
        var fields = Context.getBuildFields();

        var width = Std.parseInt(Context.definedValue("shoe3d_game_width"));
        var fWidth = {
            name : "width",
            doc: "Original game width (defined in build.hxml)",
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:Int, macro $v{width}),
            pos: Context.currentPos()
        };
        fields.push(fWidth);

        var height = Std.parseInt(Context.definedValue("shoe3d_game_height"));
        var fHeight = {
            name : "height",
            doc: "Original game height (defined in build.hxml)",
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:Int, macro $v{height}),
            pos: Context.currentPos()
        };
        fields.push(fHeight);

        var name = Context.definedValue("shoe3d_game_name");
        var fName = {
            name : "name",
            doc: "Game name (defined in build.hxml)",
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:String, macro $v{name}),
            pos: Context.currentPos()
        };
        fields.push(fName);

        var version = Context.definedValue("shoe3d_game_version");
        var fVersion = {
            name : "version",
            doc: "Game version (defined in build.hxml)",
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:String, macro $v{version}),
            pos: Context.currentPos()
        };
        fields.push(fVersion);

        var re = ~/[^a-z0-9]+/gi;
        var id =
            ~/(^[_]+|[_]+$)/g.replace(
                ~/[_]+/gi.replace(
                    re.replace(name, "_") + "_ver" + re.replace(version, "_"),
                    "_"
                ),
                ""
            ).toLowerCase();
        var fId = {
            name : "id",
            doc: "String generated from game name and version",
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:String, macro $v{id}),
            pos: Context.currentPos()
        };
        fields.push(fId);

        return fields;
    }
}