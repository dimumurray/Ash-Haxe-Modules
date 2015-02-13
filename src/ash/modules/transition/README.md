#TRANSITION MODULES

* [FSM Transition Module]()

---
### **FSM Transition Module**

The `FSM Transition` module leverges Ash's finite state machine mechanism and the [Actuate](https://github.com/openfl/actuate#actuate) tween library to provide tween-based transitions on components of an entity within each `EntityState`. Transitions into and away-from a given `EntityState` are handled distinctly via callbacks `transitionIn` and `transitionOut` callbacks whenever a `FSMTransitionNode` is added and removed from the `FSMTransitionSystem`.

#####Module Composition

| Components  | Nodes  | Systems |
| :------------: |:---------------:| :-----:|
| `FSMInfo` `Transition`     | `FSMTransitionNode` | `FSMTransitionSystem` |

#####External Dependencies
* [Ash FSM](https://github.com/nadako/Ash-HaXe/tree/master/src/ash/fsm#finite-state-machine)
* [Actuate](https://github.com/openfl/actuate#actuate)

#####Sample Usage 
```javascript
```
