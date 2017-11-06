package com.component;

import shoe3d.core.Time;
import shoe3d.core.game.Component;

class ComponentExample extends Component {
    public function new() {
        super();
    }

    override public function onUpdate() {
        if( owner != null )
            owner.transform.rotateY( Time.dt * Math.PI );
    }
}