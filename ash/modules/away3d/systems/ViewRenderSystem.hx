package ash.modules.away3d.systems;

import openfl.events.Event;
import ash.core.Engine;
import ash.core.System;
import ash.core.NodeList;

import ash.modules.away3d.nodes.ViewRenderNode;

class ViewRenderSystem extends System {
    private var nodes:NodeList<ViewRenderNode>;

    public function new() {
        super();
    }

    override public function addToEngine(engine:Engine):Void {
        super.addToEngine(engine);

        nodes = engine.getNodeList(ViewRenderNode);

        for (node in nodes) {
            onNodeAdded(node);
        }

        nodes.nodeAdded.add(onNodeAdded);
        nodes.nodeRemoved.add(onNodeRemoved);
    }

    private function onNodeAdded(node:ViewRenderNode):Void {
        node.view.container.setRenderCallback(
            function(e:Event):Void {
                node.view.container.render();
            }
        );
    }

    private function onNodeRemoved(node:ViewRenderNode):Void {
        node.view.container.setRenderCallback(null);
    }
}
