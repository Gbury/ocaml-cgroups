# ocaml-cgroups

This is still a BETA version

OCaml interface to the control groups. Control groups are a way
of grouping together processes (into cgroups) in order to be able to
compute and/or restrict the behavior of said groups of processes.
As such, cgroups allow to keep track of processes memory allocation,
cpu time, input/output, etc ...

For further documentation, a good ressource is:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/ch01.html

Since cgroups interaction is done via the filesystem, some permissions
are needed to perform certain actions, such as creating a cgroup, attaching
a process to a cgroup, or setting values for parameters.

## Basics about cgroups

Hierarchies are trees of cgroups, hierarchies are completely independent from one another,
except for some limitations concerning subsystems. Subsystems (or controllers) are mechanisms for gathering
statistics about process and/or restricting their behavior. Each subsystem is typically
attached to only one hierarchy. A cgroup is a node in a hierarchy. Each cgroup has a list
of processes attached to the cgroup. In a hierarchy, every process belongs to exactly one cgroup.

Spawned processes are automatically attached to the same cgroups as their parents, but
nothing prevents to move them to other cgroups afterward.

Standard subsystems include:

- memory: a subsystem to gather information about memory ressources used by a program;
  can also set soft and hard limits to the memory consumption of programs
- cpu: a subsystem to control scheduling of cpus among cgroups
- cpuacct: a subsystem that gathers information about cpu ressources used by processes
- cpuset: a subsystem to assign individual cpus and memory nodes to process in cgroups

## Examples

Let's say you want to limit the ressources used by a program `P` and its children.
You may want to prevent the memory used, as well as keep track of the cpu ressources
used, so that you may send a signal to the process if it exceeds a certain amount.

For that, we need to use two subsystems which are the 'memory' and 'cpuacct' subsystems.
We then need to find the hierarchies to which they are attached (which will most likely
be distinct), and within each hierarchy, find a cgroup to which attach the process we want
to observe. For this example, we will suppose such a group already exists, and is named
foobar (see following section on the creation of cgroups).

Now that we have our cgroups, we will need to attach `P` to them, this is done
wia tha `Hierarchy.add_process` function. Please note that it is only `P` that we
add to the cgroup, so if at that moment, `P` has already spawned children, they
will NOT be added to the cgroup; however, once `P` is in the cgroup, the children
it spawns will automatically belongs to the same cgroup as `P`.

Once `P` belongs to the cgroup, subsystems will start to gather information about
its execution (such as cpu time used, memory used, etc..). It can be accessed
using the predefined subsystem parameters in the `Subsystem.Memory` and
`Subsystem.Cpuacct` modules.

```ocaml
open Cgroups

(* This call tries and find the hierachy attached to a subsystem, and then
   go down the hierarchy to find the specified cgroup. Is the specified
   cgroup does not exists, it will raises Invalid_argument *)
let memory_cgroup = Hierarchy.find_exn "memory:/foobar" in
let cpuacct_cgroup = Hierarchy.find_exn "cpuacct:/foobar" in

(* Replace this by whatever pid you want *)
let pid = Unix.getpid () in

(* We add a process to the cgroups *)
Hierarchy.add_process memory_cgroup pid;
Hierarchy.add_process cpuacct_cgroup pid;

(* We can get the total cpu time (in nanoseconds) used by all processes in
   a cgroup (and processes in the children of the cgroups, etc..) *)
let _totat_cpu_time = Subsystem.Parameters.get Subsystem.Cpuacct.usage cpuacct_cgroup in

(* We can also get the memory used by tasks in the cgroup (strictly, i.e includes tasks
   in the cgroup but not tasks in children of the cgroup), etc ... *)
let _memory_used = Subsystem.Parameters.get Subsystem.Memory.usage_in_bytes memory_cgroup in

(* We can set also limit memory usage to 1G *)
Subsystem.Parameters.set Subsystem.Memory.limit_in_bytes memory_cgroup 1_000_000_000;
(* This line limits RAM + Swap usage to 2G *)
Subsystem.Parameters.set Subsystem.Memory.memsw_limit_in_bytes memory_cgroup 2_000_000_000;

```

## Creation of cgroups

As mentionned previously, all interactions with cgroups is done via the filesystem,
which may bring some annoying problems about permission sometimes. For instance,
most hierarchies and groups are only writable by `root` by default, which
prevent users from creating new cgroups, editing limits, or movind tasks to cgroups.

### Using libcg

The `libcg` (or `libcgroup`) package provides some tools to manipulate cgroups a bit more easily.
In order to create the memory cgroups used in the example above, you may do:

```
cgcreate -a user:group -t user:group -g memory:foobar
```

### Manually

Or alternatively, you can do it by hand, though it requires a bit more work. First you have
to identify the mountpoint of the hierarchy associated to the memory controller. You
can do it by looking at mount points (i.e `mount` or `cat /proc/mounts`), and look for a line
like :

```
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
```

You can then create the appropriate directory and set the owner and permissions as desired:

```
mkdir /sys/fs/cgroup/memory/foobar
chown -R user:group /sys/fs/cgroup/memory/foobar
```

## Other ressources

You can also take a lookt at the following link for some interesting
explanation about cgroups:
https://www.kernel.org/doc/Documentation/cgroups/cgroups.txt
