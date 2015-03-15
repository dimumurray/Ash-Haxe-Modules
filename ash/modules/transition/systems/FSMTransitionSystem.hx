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
package ash.modules.transition.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.tools.ListIteratingSystem;

import ash.modules.transition.components.*;
import ash.modules.transition.nodes.FSMTransitionNode;

import ash.typedefs.TweenData;

import motion.Actuate;
import motion.easing.*;
import motion.actuators.GenericActuator;

class FSMTransitionSystem extends ListIteratingSystem<FSMTransitionNode> {
    private var nodes:NodeList<FSMTransitionNode>;

    public function new() {
        super(FSMTransitionNode, updateNode);
    }

    override public function addToEngine(engine:Engine):Void {
        super.addToEngine(engine);
        nodes = engine.getNodeList(FSMTransitionNode);

        for (node in nodes) {
            transitionIn(node);
        }

        nodes.nodeAdded.add(transitionIn);
        nodes.nodeRemoved.add(transitionOut);
    }

    private function transitionIn(node:FSMTransitionNode):Void {
        doTransition(node, node.transition.inTweens);
    }

    private function transitionOut(node:FSMTransitionNode):Void {
        doTransition(node, node.transition.outTweens, changeState);
    }

    private function changeState(node:FSMTransitionNode):Void {
        node.info.fsm.changeState(node.info.nextState);
    }

    private function doTransition(node:FSMTransitionNode, tweens:Array<TweenData>, _onComplete:FSMTransitionNode->Void = null):Void {
        var actuator:GenericActuator<Dynamic> = null;
        var ComponentClass:Class<Dynamic>;
        var component:Dynamic;

        for (tween in tweens) {
            ComponentClass = Type.resolveClass(tween.component);
            component = node.entity.get(ComponentClass);

            for (prop in Type.getInstanceFields(ComponentClass)) {

                if (Reflect.hasField(tween.from, prop)) {
                    Reflect.setProperty(component, prop, Reflect.field(tween.from, prop));
                }

            }

            actuator = Actuate
                .tween(component, tween.duration, tween.to)
                .delay(tween.delay)
                .ease(Reflect.getProperty(Type.resolveClass(tween.ease.type), tween.ease.func));

            if (Reflect.hasField(component, "invalidate")) {
                actuator.onUpdate(function(){
                    component.invalidate = true;
                });
            }

        }

        if (_onComplete != null) {

            if (actuator != null) {
                actuator.onComplete(_onComplete, [node]);
            } else {
                _onComplete(node);
            }

        }

    }

    public function updateNode(node:FSMTransitionNode, time:Float):Void {

        if (node.info.invalidate && (node.info.currentState != node.info.nextState)) {
            node.info.invalidate = false;
            node.info.prevState = node.info.currentState;
            node.info.currentState = node.info.nextState;
            node.entity.remove(Transition);
        }
    }
}
