#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

extern int sched_trace_enabled;
int sys_enable_sched_trace(void)
{
  if (argint(0, &sched_trace_enabled) < 0)
  {
    cprintf("enable_sched_trace() failed!\n");
  }

  return 0;
}

int setrunningticks(int time_allotment)
{
	//For getting the user level parameter passed
	argint(0, &time_allotment);
	if(time_allotment > 0)
	{
		//Set the value and return success
		RUNNING_THRESHOLD = time_allotment;
		return 0;
	}
	else
		return 1;
}

int setwaitingticks(int waiting_thres)
{
	//For getting the user level parameter passed
	argint(0, &waiting_thres);
	if(waiting_thres > 0)
	{
		//Set the value and return success
		WAITING_THRESHOLD = waiting_thres;
		return 0;
	}
	else
		return 1;
}

int setpriority(int pid, int priority)
{
	//For getting the user level parameter passed
	argint(0, &pid);
	argint(1, &priority);
	//Check if the pid are greater than 0 and priority is greater than or equal to 0
	if(pid > 2 && priority >= 0)
	{
		//If the process is to be pinned to the queue 0
		if(priority == 0)
		{
			int exists = 0;
			for(int i = 0; i < pinIndex; i++)
			{
				if(pinnedProcesses[i] == pid)
				{
					exists = 1;
					break;
				}
			}

			if(exists == 0)
			{
				pinnedProcesses[pinIndex] = pid;
				pinIndex++;
			}
			/*for(int i = 0; i < pinIndex; i++)
			{
				cprintf("\nPINNED PROCESSES %d\n", pinnedProcesses[i]);
			}*/

			return 0;
		}
		//If the process is to be scheduled by the MLFQ policy
		else if(priority > 0)// && pid == pinnedPID)
		{
			int exists = 0;
			int loc = -1;
			for(int i = 0; i < pinIndex; i++)
			{
				if(pinnedProcesses[i] == pid)
				{
					exists = 1;
					loc = i;
					break;
				}
			}

			if(exists == 1)
			{
				for(int i = loc; i < pinIndex - 1; i++)
					pinnedProcesses[i] = pinnedProcesses[i + 1];
				pinnedProcesses[pinIndex] = 0;
				pinIndex--;
				return 0;
			}
			else
				return 1;
		}
	}
	else
		return 1;
	return 1;
}
