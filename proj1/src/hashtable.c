#include "hashtable.h"
#include <stdlib.h>
#include <stdio.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *))
{
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable)
  {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->data = malloc(sizeof(HashBucket *) * size);
  if (NULL == newTable->data)
  {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++)
  {
    newTable->data[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/*
 * This inserts a key/data pair into a hash table.  To use this
 * to store strings, simply cast the char * to a void * (e.g., to store
 * the string referred to by the declaration char *string, you would
 * call insertData(someHashTable, (void *) string, (void *) string).
 */
void insertData(HashTable *table, void *key, void *data)
{
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket location with table->hashFunction.
  // 2. Allocate a new hash bucket struct.
  // 3. Append to the linked list or create it if it does not yet exist.
  unsigned int hashbuck_row;
  HashBucket *new_hashbuck, *next_bucket;

  hashbuck_row = table->hashFunction(key);
  new_hashbuck = malloc(sizeof(HashBucket));

  if (new_hashbuck == NULL)
  {
    fprintf(stderr, "malloc failed\n");
    exit(1);
  }

  if (table->data[hashbuck_row] == NULL)
  {

    table->data[hashbuck_row] = new_hashbuck;
    table->data[hashbuck_row]->data = data;
    table->data[hashbuck_row]->key = key;
    table->data[hashbuck_row]->next = NULL;
  }

  else
  {
    for (next_bucket = table->data[hashbuck_row]; next_bucket->next != NULL; next_bucket = next_bucket->next)
      ;

    next_bucket->next = new_hashbuck;
    next_bucket->data = data;
    next_bucket->key = key;
    next_bucket->next = NULL;
  }
}

/*
 * This returns the corresponding data for a given key.
 * It returns NULL if the key is not found. 
 */
void *findData(HashTable *table, void *key)
{
  // -- TODO --
  // HINT:
  // 1. Find the right hash bucket with table->hashFunction.
  // 2. Walk the linked list and check for equality with table->equalFunction.
  unsigned int hashbuck_row;
  HashBucket *next_bucket;

  hashbuck_row = table->hashFunction(key);

  for (next_bucket = table->data[hashbuck_row]; next_bucket != NULL && next_bucket->key != NULL; next_bucket = next_bucket->next)
  {
    if (table->equalFunction(next_bucket->key, key))
      return next_bucket->data;
  }

  return NULL;
}
