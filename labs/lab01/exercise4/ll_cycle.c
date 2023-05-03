#include <stddef.h>
#include <string.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head)
{
    node *fast_ptr, *slow_ptr;

    if (head == NULL)
        return 0;

    fast_ptr = head->next->next;
    slow_ptr = head->next;

    while(fast_ptr != slow_ptr)
    {
       if (fast_ptr == NULL || fast_ptr->next == NULL || fast_ptr->next->next == NULL)
            return 0;

       fast_ptr = fast_ptr->next->next;
       slow_ptr = slow_ptr->next;
    }

    return 1;
}
