package

import ash.fsm.EntityStateMachine;

class FSMInfo {
    public var fsm:EntityStateMachine;
    public var currentState:String;
    public var prevState:String;
    public var nextState:String;

    public var invalidate:Bool = false;

    public function new() {}
}
