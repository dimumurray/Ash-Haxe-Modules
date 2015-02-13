#TEMPORAL MODULES

* [Transient Module](https://github.com/dimumurray/Ash-Haxe-Modules/blob/master/src/ash/modules/temporal/README.md#transient-module)

---
### **Transient Module**

The `Transient` module provides a uniform way to remove components from an entity after a specified duration. Optionally set the `removeAll` flag on a Transient component to effectively destroy an entity.

#####Module Composition

| Components  | Nodes  | Systems |
| :------------: |:---------------:| :-----:|
| `Transient`     | `TransientNode` | `TransientSystem` |

#####External Dependencies
* None

#####Sample Usage 
```javascript
/**
 * Description:
 *    Remove components of types ComponentClassA and ComponentClassB
 *    from an entity after 4 seconds.
 */

// Caveat: Always add the TransientSystem to 
//         the very end of the system chain.
engine.addSystem(SystemA);
engine.addSystem(SystemB);
...
engine.addSystem(TransientSystem);

// Create an instance of the Transient component 
// setting duration and the list of component types.
var transient:Transient = new Transient();
transient.duration = 4.0;
transient.components = [ComponentClassA, ComponentClassB];

// Add the component to the entity
var entity:Entity = new Entity();
entity.add(new Transient(durationInSeconds));
```

```javascript
/**
 * Description:
 *    Destroys an entity at the end of the update cycle (assumes
 *    that the TransientSystem has the lowest priority ie. last
 *    added to the system chain).
 */
var transient:Transient = new Transient();
transient.removeAll = true;

var entity:Entity = new Entity();
entity.add(new Transient());
```
