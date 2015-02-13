/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Damion Murray
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **/
package ash.modules.temporal.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;
import ash.modules.temporal.components.Transient;
import ash.modules.temporal.nodes.TransientNode;

class TransientSystem extends ListIteratingSystem<TransientNode> {
    private var engine:Engine;

    public function new() {
        super(TransientNode, updateNode);
    }

    override public function addToEngine(engine:Engine):Void {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public function updateNode(node:TransientNode, time:Float):Void {
        node.transient.duration -= time;

        if (node.transient.duration <= 0) {

            if (node.transient.components == null || node.transient.components.length == 0) {
                engine.removeEntity(node.entity);
            } else {

                for (componentClass in node.transient.components) {

                    if (node.entity.has(componentClass)) {
                        node.entity.remove(componentClass);
                    }

                }

                node.entity.remove(Transient);
            }

        }

    }

}
