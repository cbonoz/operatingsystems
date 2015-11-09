#include "mpos-app.h"
#include "lib.h"

/*****************************************************************************
 * mpos-app2
 *
 *   This application as 1024 new processes and then waits for them to
 *   exit.  All processes print messages to the screen.
 *
 *****************************************************************************/

volatile int counter;
static const int CMAX=1025;

/*
typedef enum exercise {
	ORIG,
	P_5,
	P_6,
} exercise_t;
*/

void run_child(void);

void testfunc() {
	app_printf("Process %d ran testfunc\n", sys_getpid());
}
void
start(void)
{

	pid_t p;
	int status;
	int run_ec=0;


	if (run_ec) {
		int x = 0;  /* note that local variable x lives on the stack */
		/* YOUR CODE HERE */
		app_printf("Ex5 program:\n");
		volatile int* y;
		int* volatile z;
		//point both to x in parent thread
		y=&x; 
        z=&x;
        pid_t p = sys_fork();
        if (p == 0) {
        	//resassign x pointers
        	y=&x;
        	z=&x;
        	*y=1;
        	*z=1;
        /* YOUR CODE HERE */
        	
        	//run_child();
		} else if (p > 0) {
		    sys_wait(p); // assume blocking implementation
		}

		//app_printf("pid %d: %d",sys_getpid(),x);
		app_printf("%d",x);
		//sys_exit(0);
		
	}
	app_printf("\n");

	if (run_ec) {
		app_printf("Ex6 program:\n");
		testfunc();
		pid_t p=sys_newthread(testfunc);
		//child jumps to testfunc before exiting, in a fork() child would simply exit
		//testfunc();
	}

	//if running ec code, exit before reg program
	if (run_ec) sys_exit(0);

	counter = 0;

	while (counter < CMAX) {
		int n_started = 0;

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < CMAX) {
			p = sys_fork();
			if (p == 0)
				run_child();

			else if (p > 0) {
				n_started++;
				//app_printf("child pid created: %d\n",p);
			} else
				break;
		}

		// If we could not start any new processes, give up!
		if (n_started == 0) {
			app_printf("could not start any new processes for app2\n");
			break;
		}

		// We started at least one process, but then could not start
		// any more.
		// That means we ran out of room to start processes.
		// Retrieve old processes' exit status with sys_wait(),
		// to make room for new processes.
		for (p = 2; p < NPROCS; p++)
			sys_wait(p);
	}
	//app_printf("child %d exited\n",p);
	sys_exit(1000);
}

void
run_child(void)
{
	int input_counter = counter;
	int i;

	counter++;		/* Note that all "processes" share an address
				   space, so this change to 'counter' will be
				   visible to all processes. */
	pid_t p=sys_getpid();

	if (p%2==0 && p>1)
	{
		//app_printf("\nkilling:");
		for (i=3; i<NPROCS; i+=2)
		{
			sys_kill(i);
			//app_printf("%d ",i);
		}
		//app_printf("\n");
	}
	/*
	if (p%2==0) {
		app_printf("current p=%d\nkilled:",p);
		for (i=3;i<NPROCS;i+=2) {
			sys_kill(i);
			app_printf("%d ",i);
		}
	}*/

	app_printf("\nProcess %d lives, counter %d!",
		   sys_getpid(), input_counter);
	sys_exit(input_counter);
}
