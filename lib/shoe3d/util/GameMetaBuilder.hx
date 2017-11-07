package shoe3d.util;

import haxe.macro.Context;
import haxe.macro.Expr;

class GameMetaBuilder {

    macro static public function build():Array<Field> {
        var fields = Context.getBuildFields();

        var width = Std.parseInt(Context.definedValue("shoe3d_game_width"));
        var fWidth = {
            name : "width",
            doc: null,
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:Int, macro $v{width}),
            pos: Context.currentPos()
        };
        fields.push(fWidth);

        var height = Std.parseInt(Context.definedValue("shoe3d_game_height"));
        var fHeight = {
            name : "height",
            doc: null,
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:Int, macro $v{height}),
            pos: Context.currentPos()
        };
        fields.push(fHeight);

        var name = Context.definedValue("shoe3d_game_name");
        var fName = {
            name : "name",
            doc: null,
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:String, macro $v{name}),
            pos: Context.currentPos()
        };
        fields.push(fName);

        var version = Context.definedValue("shoe3d_game_version");
        var fVersion = {
            name : "version",
            doc: null,
            meta: [],
            access: [AStatic, APublic],
            kind: FVar(macro:String, macro $v{version}),
            pos: Context.currentPos()
        };
        fields.push(fVersion);

        return fields;
    }
}