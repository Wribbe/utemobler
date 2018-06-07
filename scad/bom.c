#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define error(fmt, ...) fprintf(stderr, "[!]: "fmt, ##__VA_ARGS__)

struct token_list {
  size_t len;
  const char ** tokens;
};

struct token_list
tokenize(const char * string)
{
  struct token_list token_list = {0};
  return token_list;
}

int
main(void)
{
  const char * filename = "sofa.scad";
  FILE * handle_f = fopen(filename, "r");
  if (handle_f == NULL) {
    error("Could not find %s.\n", filename);
    return EXIT_FAILURE;
  }
  fseek(handle_f, 0L, SEEK_END);
  size_t size_file = ftell(handle_f);
  rewind(handle_f);

  char * mem_block = malloc(size_file+1);
  if (mem_block == NULL) {
    error("Could not allocate memory with malloc.\n");
  }

  fread(mem_block, size_file, 1, handle_f);
  mem_block[size_file] = '\0';

  fclose(handle_f);

  struct token_list tokens = tokenize(mem_block);
}
