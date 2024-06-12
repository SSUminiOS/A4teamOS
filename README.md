# OS 4조
**팀장** : 20211555 최서영  
**팀원** : 20212973 박주은 , 20192596 백현우, 20192562 강성욱


# 실행방법

**FCFS** : `make qemu-nox SCHEDULER=FCFS`  
**RR** : `make qemu-nox SCHEDULER=RR`  
**MLFQ** : `make qemu-nox SCHEDULER=MLFQ`  

## test code

|file|cmd|description|
|:---:|:-:|:---:|
|tester.c|tester|scheduler 검증 코드|
|test.c|test|thread 검증 코드|
