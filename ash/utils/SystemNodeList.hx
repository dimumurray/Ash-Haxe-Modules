package ash.utils;

import ash.core.System;
import ash.core.Engine;
import ash.core.SystemList;

class SystemNodeList extends SystemList {

    public function new() {
    }

    override public function add(system:System):Void {
        var node:SystemNode = new SystemNode(system);

        node.priority = system.priority;

        super(node);
    }

    override public function remove(system:System):Void {
        var node:SystemNode = cast(head, SystemNode);
        var next:SystemNode;

        while (node != null) {
            next = cast(node.next, SystemNode);

            if (node.system == system) {
                node.system = null;
                super.remove(node);
            }

            node = next;
        }
    }

    // Note: This will only return the first occurance of the specified class type
    // TODO create a method to return all instances
    override public function get<TSystem:System>(type:Class<TSystem>):TSystem {
        //var system:System = head;
        var node:SystemNode = cast(head, SystemNode);

        while (node != null) {

            if (Std.is(node.system, type))
                return cast node.system;
            node = cast(node.next, SystemNode);
        }

        return null;
    }

}

private class SystemNode extends System {
    private var system:System;

    public function new(_system:System) {
        system = (_system != null)?_system:new System();
    }

    override public function addToEngine(engine:Engine):Void {
        system.addToEngine(engine);
    }

    override public function removeFromEngine(engine:Engine):Void {
        system.addToEngine(engine);
    }

    override public function update(time:Float):Void {
        system.update(time);
    }

}
