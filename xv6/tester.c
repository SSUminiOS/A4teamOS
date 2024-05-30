#include "types.h"
#include "user.h"
#include "stat.h"

int number_of_processes = 10;

//struct process_info {
    //int pid;
    //int start_time;
    //int end_time;
//};

int main(int argc, char *argv[]) {
    int j;
    for (j = 0; j < number_of_processes; j++) {
        int pid = fork();
        if (pid < 0) {
            printf(1, "Fork failed\n");
            continue;
        }
        if (pid == 0) {
            volatile int i;
            for (volatile int k = 0; k < number_of_processes; k++) {  //io time
                if (k <= j) {
                    sleep(200);
                    //getps();
                } else {
                    for (i = 0; i < 200000000; i++) { //cpu time
                        ; }
                }
            }
            
            printf(1, "Process: PID %d :%d Finished\n", getpid(), j);
            //yield();
            //getps();
            exit();
        } 
    }
    for (j = 0; j < number_of_processes; j++) {
        wait();
    }
    getps();
    exit();
}


