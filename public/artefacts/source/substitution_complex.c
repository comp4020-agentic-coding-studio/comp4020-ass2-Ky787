/* COMPLEX ARITHMETIC PROBE VERSION 1.0
 * Four small interacting expression trees. All arithmetic wraps modulo 2^32.
 * Tool-specific annotations belong in generated wrappers, not this source.
 */
#include <stdint.h>
#include <stdio.h>

#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default")))
#endif
#if defined(_MSC_VER)
#define NOINLINE __declspec(noinline)
#elif defined(__GNUC__) || defined(__clang__)
#define NOINLINE __attribute__((noinline))
#else
#define NOINLINE
#endif
#ifndef OBF_SUB
#define OBF_SUB
#endif
#ifndef OBF_MBA
#define OBF_MBA
#endif

/* Four operations; each intermediate feeds the next. */
EXPORT NOINLINE OBF_SUB OBF_MBA uint32_t complex_constants(uint32_t x)
{
    uint32_t a = x ^ 0x12345678u;
    uint32_t b = a + 0x1337u;
    uint32_t c = b - 0x1111u;
    uint32_t d = c ^ 0x22222222u;
    return d;
}

/* Five operations; intersect two branches, then combine with subtraction. */
EXPORT NOINLINE OBF_SUB OBF_MBA uint32_t complex_variables(uint32_t x, uint32_t y)
{
    uint32_t a = x + y;
    uint32_t b = x ^ y;
    uint32_t c = a & b;
    uint32_t d = x - y;
    return c ^ d;
}

/* Six operations; variable-variable arithmetic meets memorable constants. */
EXPORT NOINLINE OBF_SUB OBF_MBA uint32_t complex_mixed(uint32_t x, uint32_t y)
{
    uint32_t a = x + y;
    uint32_t b = a ^ 0x12345678u;
    uint32_t c = b - 0x1337u;
    uint32_t d = x ^ y;
    uint32_t e = c + d;
    return e ^ 0x22222222u;
}

/* Ten operations in a pure, branchless tree; no multiplication or division. */
EXPORT NOINLINE OBF_SUB OBF_MBA uint32_t expression_tree(uint32_t x, uint32_t y)
{
    uint32_t left = (x + 0x1337u) ^ (y - 0x1111u);
    uint32_t right = ((x ^ y) & 0x12345678u)
                   + ((x & 0x22222222u) | (y ^ 0x11111111u));
    return left + right;
}

int main(void)
{
    volatile uint32_t x = 0x00001337u;
    volatile uint32_t y = 0x12345678u;
    uint32_t a = complex_constants(x);
    uint32_t b = complex_variables(x, y);
    uint32_t c = complex_mixed(x, y);
    uint32_t d = expression_tree(x, y);

    printf("complex_constants = 0x%08X\n", (unsigned)a);
    printf("complex_variables = 0x%08X\n", (unsigned)b);
    printf("complex_mixed     = 0x%08X\n", (unsigned)c);
    printf("expression_tree   = 0x%08X\n", (unsigned)d);
    if (a != 0x30166557u || b != 0xFFFFFDB0u ||
        c != 0x301653CDu || d != 0x278DEEBCu) {
        puts("COMPLEX ARITHMETIC FAIL: unexpected result");
        return 1;
    }
    puts("COMPLEX ARITHMETIC PASS");
    return 0;
}
