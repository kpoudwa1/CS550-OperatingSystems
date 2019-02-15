#include"types.h"
#include"stat.h"
#include"user.h"
int main(int argc, char *argv[])
{
	sleep(500);
	//printf(1, "CS550 proj0 print in user space: ");
	for(int i = 1; i < argc; i++)
	{
		argv++;
		printf(1, "%s ", *argv);
	}
	printf(1, "\n");
	exit();
}
