#ifndef _TEST_FWX_H
#define _TEST_FWX_H

#define assert_(typ,expr,op,cmp)        do { \
    typ rst = (typ)expr;\
    if (rst op (typ)cmp) {\
        printf("...PASSED\n");\
    }\
    else {\
        printf("expected %d, get %d : ", cmp, rst);\
        printf("...FAILED\n");\
    }\
} while(0);

#define assert_eq(expr, cmp)    assert_(int, expr, ==, cmp)
#define assert_gq(expr, cmp)    assert_(int, expr, >=, cmp)
#define assert_lq(expr, cmp)    assert_(int, expr, <=, cmp)
#define assert_nq(expr, cmp)    assert_(int, expr, !=, cmp)
#define assert_gt(expr, cmp)    assert_(int, expr, > , cmp)
#define assert_lt(expr, cmp)    assert_(int, expr, < , cmp)
    
#define assert_mem(expr,cmp,len)    do { \
    char *memcnt = expr;\
    int m_iterator;\
    if (memcmp(memcnt,cmp,len) == 0) {\
        printf("...PASSED\n");\
    }\
    else {\
        printf("expected : ");\
        for (m_iterator = 0; m_iterator < len; m_iterator++)\
            printf("%02X ", cmp[m_iterator]);\
        printf("\nget      : ");\
        for (m_iterator = 0; m_iterator < len; m_iterator++)\
            printf("%02X ", memcnt[m_iterator]);\
        printf("\n...FAILED\n");\
    }\
} while (0);

#endif
