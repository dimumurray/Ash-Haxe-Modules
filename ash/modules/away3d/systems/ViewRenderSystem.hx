package

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
    }

    override public function update(time:Float):Void {

        for (node in nodes) {
            node.view.container.render();
        }

    }

}
