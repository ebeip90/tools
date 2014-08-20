#include "common.h"
#include <stdio.h>
int main() {

	unless(false)
		printf("Hello world!\n");

	repeat {
		printf("Hola, mundo!\n");
		break;
	}

	until(true) return 1;

	return 0;
}
