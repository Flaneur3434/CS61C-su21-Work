/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/* * Include the header file.  */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "Specify a dictionary\n");
        return 1;
    }
    /*
   * Allocate a hash table to store the dictionary.
   */
    fprintf(stderr, "Creating hashtable\n");
    dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

    fprintf(stderr, "Loading dictionary %s\n", argv[1]);
    readDictionary(argv[1]);
    fprintf(stderr, "Dictionary loaded\n");

    fprintf(stderr, "Processing stdin\n");
    processInput();

    /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
    return 0;
}

/*
 * This should hash a string to a bucket index.  void *s can be safely cast
 * to a char * (null terminated string)
 */

/*
  * @source https://stackoverflow.com/questions/7666509/hash-function-for-string/7666799#7666799
  */
unsigned int stringHash(void *s)
{
    unsigned int hashnum, i, len;

    len = strlen((char *)s);

    for (hashnum = i = 0; i < len; i++)
    {
        hashnum += *((char *)s + (sizeof(char) * i));
        hashnum += (hashnum << 10);
        hashnum ^= (hashnum >> 6);
    }

    hashnum += (hashnum << 3);
    hashnum ^= (hashnum >> 11);
    hashnum += (hashnum << 15);

    return hashnum % dictionary->size;
}
/* * This should return a nonzero value if the two strings are identical * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2)
{
    int result = strcmp((char *)s1, (char *)s2);

    if (result)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

/*
 * This function should read in every word and replacement from the dictionary
 * and store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final bit of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(61)
 * to cleanly exit the program.
 */
void readDictionary(char *dictName)
{
    char *key, *data;
    int nextChar;
    FILE *dict_file;
    int RESIZE_COUNT_KEY = 60;
    int RESIZE_COUNT_DATA = 60;

    if ((dict_file = fopen(dictName, "r")) == NULL)
    {
        fclose(dict_file);
        fprintf(stderr, "%s not found in directory\n", dictName);
        exit(61);
    }

    key = malloc(sizeof(char) * RESIZE_COUNT_KEY);
    data = malloc(sizeof(char) * RESIZE_COUNT_DATA);

    memset(key, 0, RESIZE_COUNT_KEY * sizeof(char));
    memset(data, 0, RESIZE_COUNT_DATA * sizeof(char));

    /*
    int FINDING_DATA = 0;
    int FINDING_KEY = 1;
    int FINDING_KEY_FIRST_CHAR = 2;
    int FINDING_DATA_FIRST_CHAR = 3;
    int FINDING_TILL_NEW_LINE = 4;
    */

    char buildingKey = 2;
    while (1)
    {
        nextChar = fgetc(dict_file);
        if (feof(dict_file))
        {
            if (strlen(key) && strlen(data))
            {
                insertData(dictionary, key, data);
            }
            break;
        }

        if ((double)strlen(key) > (double)RESIZE_COUNT_KEY * 0.8)
        {
            RESIZE_COUNT_KEY *= 2;
            char *temp = malloc(sizeof(char) * RESIZE_COUNT_KEY);
            memset(temp, 0, RESIZE_COUNT_KEY * sizeof(char));
            strcpy(temp, key);
            free(key);
            key = temp;
        }

        if ((double)strlen(data) > (double)RESIZE_COUNT_DATA * 0.8)
        {
            RESIZE_COUNT_DATA *= 2;
            char *temp = malloc(sizeof(char) * RESIZE_COUNT_DATA);
            memset(temp, 0, RESIZE_COUNT_DATA * sizeof(char));
            strcpy(temp, data);
            free(data);
            data = temp;
        }

        if (buildingKey == 2)
        {
            if (isalnum(nextChar))
            {
                strncat(key, (const char *)&nextChar, sizeof(int));
                buildingKey = 1;
            }
        }
        else if (buildingKey == 1)
        {
            if (isalnum(nextChar)) /* check for space(32) or tab(9) */
            {
                strncat(key, (const char *)&nextChar, sizeof(int));
            }
            else
            {
                buildingKey = 3;
            }
        }
        else if (buildingKey == 3)
        {
            if (!isspace(nextChar))
            {
                buildingKey = 0;
                strncat(data, (const char *)&nextChar, sizeof(int));
            }
        }
        else if (buildingKey == 0)
        {
            if (isspace(nextChar))
            {
                if (nextChar == '\n')
                    buildingKey = 2;
                else
                    buildingKey = 4;
                insertData(dictionary, key, data);
                RESIZE_COUNT_KEY = RESIZE_COUNT_DATA = 60;
                key = malloc(sizeof(char) * RESIZE_COUNT_KEY);
                data = malloc(sizeof(char) * RESIZE_COUNT_DATA);

                memset(key, 0, RESIZE_COUNT_KEY * sizeof(char));
                memset(data, 0, RESIZE_COUNT_DATA * sizeof(char));
            }
            else
            {
                strncat(data, (const char *)&nextChar, sizeof(int));
            }
        }
        else
        {
            if (nextChar == '\n')
            {
                buildingKey = 2;
            }
        }
    }
    fclose(dict_file);
}

void toLowerCaseAllButFirst(char *word)
{
    for (int i = 1; i < strlen(word); i++)
    {
        word[i] = tolower(word[i]);
    }
}

void toLowerCase(char *word)
{
    for (int i = 0; i < strlen(word); i++)
    {
        word[i] = tolower(word[i]);
    }
}

/*
 * This should process standard input (stdin) and perform replacements as 
 * described by the replacement set then print either the original text or 
 * the replacement to standard output (stdout) as specified in the spec (e.g., 
 * if a replacement set of `taest test\n` was used and the string "this is 
 * a taest of  this-proGram" was given to stdin, the output to stdout should be 
 * "this is a test of  this-proGram").  All words should be checked
 * against the replacement set as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the replacement set should 
 * it report the original word.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final bit of your grade, you cannot assume words have a bounded length.
 */
void processInput()
{
    char *word, *data;
    int starting_size = 60;
    int length = 0;
    int nextChar;

    word = malloc(sizeof(char) * starting_size);

    memset(word, 0, sizeof(char) * starting_size);

    while (1)
    {
        nextChar = fgetc(stdin);
        if (feof(stdin))
        {
            if (strlen(word) > 0)
            {
                char lowered[strlen(word)];
                strcpy(lowered, word);
                toLowerCaseAllButFirst(lowered);

                char lowercase[strlen(word)];
                strcpy(lowercase, word);
                toLowerCase(lowercase);

                if ((data = findData(dictionary, word)) != NULL || (data = findData(dictionary, lowered)) != NULL || (data = findData(dictionary, lowercase)) != NULL)
                {
                    fputs(data, stdout);
                }
                else
                {
                    fputs(word, stdout);
                }
            }
            break;
        }

        if (isalnum(nextChar)) /* check for space(32) or tab(9) */
        {
	    if ((double) strlen(word) > (double) starting_size * 0.8) {
		    
            	starting_size *= 2;
            	char *temp = malloc(sizeof(char) * starting_size);
            	memset(temp, 0, starting_size * sizeof(char));
            	strcpy(temp, word);
            	free(word);
            	word = temp;
	    }
            strncat(word, (const char *)&nextChar, sizeof(int));
            length = strlen(word);
        }
        else if (!isalnum(nextChar))
        {
            if (strlen(word) > 0)
            {
                char lowered[strlen(word)];
                strcpy(lowered, word);
                toLowerCaseAllButFirst(lowered);

                char lowercase[strlen(word)];
                strcpy(lowercase, word);
                toLowerCase(lowercase);

                if ((data = findData(dictionary, word)) != NULL || (data = findData(dictionary, lowered)) != NULL || (data = findData(dictionary, lowercase)) != NULL)
                {
                    fputs(data, stdout);
                }
                else
                {
                    fputs(word, stdout);
                }
            }

            fputc(nextChar, stdout);
            // strncat(text, (const char *)&nextChar, sizeof(int));
            // text[walker] = c;
            memset(word, 0, sizeof(char) * length);
            length = 0;
        }
    }

    HashBucket *next_bucket;
    HashBucket *temp_pointer;

    for (unsigned int i = 0; i < dictionary->size; i++)
    {
        next_bucket = dictionary->data[i];

        while (next_bucket != NULL)
        {
            temp_pointer = next_bucket;
            next_bucket = next_bucket->next;
            free(temp_pointer->key);
            free(temp_pointer->data);
            free(temp_pointer);
        }
    }

    free(dictionary->data);
    free(dictionary);
    free(word);
    return;
}
