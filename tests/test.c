#include <stdio.h>
#include "memory.h"

int main() {
	if (sum(1, 5) == 6) {
		printf("OK!\n");
		return 0;
	} else {
		printf("FAIL!\n");
		return 1;
	}
}
