#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;

int sched_trace_enabled = 1; // for CS550 CPU/process project

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

//Global variables
int sched_policy = 1;
int RUNNING_THRESHOLD = 2;
int WAITING_THRESHOLD = 4;
int pinnedProcesses[NPROC];
int pinIndex = 0;

//MLFQ Queues
struct proc* queue0[NPROC];
struct proc* queue1[NPROC];

//MLFQ Queue counters
int q0Counter = 0;
int q1Counter = 0;

//Function for checking if the process is pinned
int processPinned(int pid)
{
	for(int i = 0; i < pinIndex; i++)
	{
		if(pinnedProcesses[i] == pid)
		{
			return 0;
		}
	}
	return 1;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  //Placing the new process at the end of queue0, if the sched_policy flag is set to MLFQ
  if(sched_policy == 1)
  {
     p->running_tick = 0;
     p->waiting_tick = 0;
     queue0[q0Counter] = p;
     //Increment the counter position
     q0Counter++;
  }

  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
	struct proc *p;
	int ran = 0; // CS550: to solve the 100%-CPU-utilization-when-idling problem

	for(;;)
	{
		// Enable interrupts on this processor.
		sti();

		// Loop over process table looking for process to run.
		acquire(&ptable.lock);
		ran = 0;
		//Execute the default scheduler if the MLFQ flag is not set
		if(sched_policy == 0)
		{
			for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
			{
				if(p->state != RUNNABLE)
					continue;

				ran = 1;
      
				// Switch to chosen process.  It is the process's job
				// to release ptable.lock and then reacquire it
				// before jumping back to us.
				proc = p;
				switchuvm(p);
				p->state = RUNNING;
				swtch(&cpu->scheduler, proc->context);
				switchkvm();

				// Process is done running for now.
				// It should have changed its p->state before coming back.
				proc = 0;
			}
		}//Execute the process as per MLFQ policy
		else if(sched_policy == 1)
		{
			int i;

			//For executing processes from queue 0 before executing processes from queue 1
			loopQueue0:
			//Code for executing processes in queue 0
			for(i = 0; i < q0Counter; i++)
			{
				if(queue0[i]->state != RUNNABLE)
					continue;

				ran = 1;
				//Incrementing the running tick for the process choosen to executed
				queue0[i]->running_tick++;
				p = queue0[i];
				proc = queue0[i];
				switchuvm(p);
				p->state = RUNNING;
				swtch(&cpu->scheduler, proc->context);
				switchkvm();

				//Check if the value of running ticks is greater than threshold and the process is not pinned
				if(queue0[i]->running_tick >= RUNNING_THRESHOLD && queue0[i]->pid != 1 && queue0[i]->pid != 2 && processPinned(queue0[i]->pid) != 0 )
				{
					//Set the running_tick & waiting_tick to 0
					queue0[i]->running_tick = 0;
					queue0[i]->waiting_tick = 0;

					//Assign the process to queue 1
					queue1[q1Counter] = queue0[i];

					//Increment the counter
					q1Counter++;

					//Remove the process from the queue 0
					for(int j = i; j < q0Counter - 1; j++)
						queue0[j] = queue0[j + 1];

					queue0[q0Counter] = 0;
					q0Counter--;
				}

				//For incrementing the waiting ticks of the processes in queue 1 and promoting the processes to queue 0 if the waiting ticks exceeds the waiting threshold
				for(int j = 0; j < q1Counter; j++)
				{
					queue1[j]->waiting_tick++;

					if(queue1[j]->waiting_tick >= WAITING_THRESHOLD)
					{
						//Set the running_tick & waiting_tick to 0
						queue1[j]->running_tick = 0;
						queue1[j]->waiting_tick = 0;

						//Assign the process to queue 0
						queue0[q0Counter] = queue1[j];

						//Increment the counter
						q0Counter++;

						//Remove the process from the queue 1
						for(int k = j; k < q1Counter - 1; k++)
							queue1[k] = queue1[k + 1];

						queue1[q1Counter] = 0;
						q1Counter--;
					}
				}

				proc = 0;
			}

			//Check if there are further runnable processes in queue 0
			for(i = 0; i < q0Counter; i++)
			{
				if(queue0[i]->state == RUNNABLE && queue0[i]->pid != 1 && queue0[i]->pid != 2)
					goto loopQueue0;
			}

			//Code for executing processes in queue 1
			for(i = 0; i < q1Counter; i++)
			{
				int priority = -1;
				int index = -1;

				//For getting processes with maximum priority
				for(int j = 0; j < q1Counter; j++)
				{
					if(queue1[j]->state == RUNNABLE && queue1[j]->waiting_tick > priority)
					{
						priority = queue1[j]->waiting_tick;
						index = j;
					}
				}

				//Check if there is a process which is runnable
				if(index < 0)
					continue;

				//Check if the process to be executed in queue 1 is to be pinned to queue 0
				if(processPinned(queue1[index]->pid) == 0)
				{
					//Set the running_tick & waiting_tick to 0
					queue1[index]->running_tick = 0;
					queue1[index]->waiting_tick = 0;

					//Assign the process to queue 0
					queue0[q0Counter] = queue1[index];

					//Increment the counter
					q0Counter++;

					//Remove the process from the queue 1
					for(int k = index; k < q1Counter - 1; k++)
						queue1[k] = queue1[k + 1];

					queue1[q1Counter] = 0;
					q1Counter--;
					continue;
				}

				int temp = i;
				//Assign the value of index to i
				i = index;

				ran = 1;
				p = queue1[i];
				proc = queue1[i];
				switchuvm(p);
				p->state = RUNNING;
				swtch(&cpu->scheduler, proc->context);
				switchkvm();

				//For incrementing the waiting_tick and moving processes with waiting_tick greater than the threshold to queue 0
				for(int j = 0; j < q1Counter; j++)
				{
					if(i != j)
					{
						queue1[j]->waiting_tick++;

						if(queue1[j]->waiting_tick >= WAITING_THRESHOLD)
						{
							//Set the running_tick & waiting_tick to 0
							queue1[j]->running_tick = 0;
							queue1[j]->waiting_tick = 0;

							//Assign the process to queue 0
							queue0[q0Counter] = queue1[j];

							//Increment the counter
							q0Counter++;

							//Remove the process from the queue 1
							for(int k = j; k < q1Counter - 1; k++)
							{
								queue1[k] = queue1[k + 1];
							}

							queue1[q1Counter] = 0;
							q1Counter--;
						}
					}
				}
				i = temp;
				proc = 0;
			}
		}
		release(&ptable.lock);

		if (ran == 0)
		{
			halt();
		}
	}
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

  // CS550: print previously running process
  // We skip process 1 (init) and 2 (shell)
  if ( sched_trace_enabled &&
	proc && proc->pid != 1 && proc->pid != 2)
        cprintf("[%d]", proc->pid);

  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
