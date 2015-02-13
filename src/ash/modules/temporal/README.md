#TEMPORAL MODULES

* [Transient Module]()

### Transient Module
Description

The `Transient` module provides a uniform way to remove components from an entity after a specified duration.

Collection

| Components  | Nodes  | Systems |
| :------------: |:---------------:| :-----:|
| `Transient`     | `TransientNode` | `TransientSystem` |


Dependencies

Usage

```javascript
// Create a Transient Component with a set duration

var entity:Entity = new Entity();
var duration:Float = 4.0;

entity.add(new Transient(duration));
```
