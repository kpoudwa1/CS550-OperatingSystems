#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "sys/types.h"

int
getcmd(char *buf, int nbuf)
{
  printf(2, "xvsh> ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

//For separating the contents of the command on the basis of whitspace
void  separateText(char *buf, char **argv)
{
	while(*buf != '\0')
	{
		//This marks the start of a new line
		*argv++ = buf;
		//Ignore the text contents until a whitespace character is found
		while(*buf != '\0' && *buf != ' ' && *buf != '\t' && *buf != '\n')
			buf++;
		//Process the whitespace character
		while(*buf == ' ' || *buf == '\t' || *buf == '\n')
			*buf++ = '\0';
	}
	*argv = '\0';
}


int
main(void)
{
	//This is the size as per the original shell file
	static char buf[100];
	char  *argv[64];
	//Counter for background processes
	int bgrndProcess = 0;

	//Execute the user commands
	while(getcmd(buf, sizeof(buf)) >= 0)
	{
		int andFlag = 0;
		//Change directory request can be done within the parent
		if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
		{
			buf[strlen(buf)-1] = 0;
			if(chdir(buf + 3) < 0)
			printf(1, "Cannot change the directory to %s\n", buf + 3);
			//Continue the execution of the loop
			continue;
		}

		//For handling empty command line
		if(strlen(buf) == 1)
		{
			continue;
		}

		//Check if the command input is for exit, then exit through the parent process (a child should not be created, so as to exit from the parent)
		if(buf[0] == 'e' && buf[1] == 'x' && buf[2] == 'i' && buf[3] == 't' && buf[4] == '\n')
		{
			//Call wait() for all background process, this avoids zombie processes
			for(int i = 0; i <= bgrndProcess; i++)
				wait();
			exit();
		}

		//if(strcmp(argv[0], "exit") == 0)

		//For every other command create a child process using fork() system call
		pid_t pid = fork();

		//Check if the process is a parent
		if(pid > 0)
		{
			//Check if the command is to be executed in background
			if(buf[strlen(buf) - 2] == '&')
			{
				printf(1, "[pid %d] runs as a background process\n", pid);
				andFlag = 1;
				bgrndProcess++;
			}
			else
				andFlag = 0;
		}//The process is the child process, execute the child
		else if(pid == 0)
		{
			//Check if the command is to be executed in background
			if(buf[strlen(buf) - 2] == '&')
			{
				//Remove the '&' and execute the command
				buf[strlen(buf) - 2] = '\0';
			}
				//Get the command and parameter separated
				separateText(buf, argv);
				//Execute the command
				exec(argv[0], argv);
				//Execute if the command fails
				printf(1, "Cannot run this command %s\n", argv[0]);
				exit();
		}
		else if(pid == -1)
		{
			printf(1, "Some error occurred, child process cannot be created\n");
		}
	//Call wait() for the child if the process is not a background process
	if(andFlag != 1)
		wait();
	}
	//exit() from the parent
	exit();
}
