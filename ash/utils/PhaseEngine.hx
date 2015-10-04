package ash.utils;

import haxe.ds.StringMap;
import ash.utils.SystemNodeList.SystemNode;
import ash.core.System;
import ash.core.Engine;

typedef SysInfo = {
    var name:String;
    var priority:Int;
}

@:access(ash.core.Engine)
class PhaseEngine extends Engine {
    private var pool:StringMap<System>;
    private var phases:StringMap<SystemNodeList>;

    private var invalidatePhaseChange:Bool;
    private var nextPhase:String;

    public var systems(get_pool, never):Iterable<System>;

    public function new() {
        super();

        invalidatePhaseChange = false;
        nextPhase = "";

        pool = new StringMap<System>();
        phases = new StringMap<SystemNodeList>();
    }

    private inline function get_pool():Iterable<System> {
        return pool;
    }

    override public function addSystem(system:System, priority:Int):Void {
        var path:String = Type.getClassName(Type.getClass(system));
        var key:String = path.substr(path.lastIndexOf('.') + 1);

        if (!pool.exists(key)) {
            pool.set(key, system);
        }

        system.priority = priority;
        system.addToEngine(this);
    }

    override public function removeSystem(system:System):Void {
        var nodeList:SystemNodeList;
        var className:String = Type.getClassName(type);
        className = className.substr(className.lastIndexOf('.') + 1);

        if (pool.exists(className)) {

            for (phase in phases) {
                nodeList = cast(phase, SystemNodeList);
                nodeList.remove(system);
            }

            pool.remove(className);
        }
    }

    override public function removeAllSystems():Void {

    }

    override public function getSystem<TSystem:System>(type:Class<TSystem>):TSystem {
        var className:String = Type.getClassName(type);
        className = className.substr(className.lastIndexOf('.') + 1);

        var system:System = pool.get(className);

        return (system == null)?null:cast system;
    }

    public function addPhase(phaseID:String, systemInfoList:Array<SysInfo>):Void {
        var sysNodeList:SystemNodeList = new SystemNodeList();
        var system:System;

        for (info in systemInfoList) {

            system = pool.get(info.name);

            if (system != null) {
                system.priority = info.priority;
                sysNodeList.add(system);
            }

        }

        phases.set(phaseID, sysNodeList);
    }

    public function setPhase(phase:String):Void {

        if (phases.exists(phase)) {
            nextPhase = phase;
            invalidatePhaseChange = true;
            updateComplete.addOnce(switchPhase);
        }

    }

    private function switchPhase():Void {

        if (invalidatePhaseChange) {
            systemList = phases.get(nextPhase);
            invalidatePhaseChange = false;
        }

    }
}
