/*
 * Seeing Through Obfuscated Code
 * Canonical showcase program - draft v0.1
 *
 * Design goals:
 *   - Simple, visually recognisable source logic.
 *   - Memorable constants that are easy to find in IR/assembly.
 *   - Distinct functions for major obfuscation techniques.
 *   - Runtime inputs to prevent trivial constant folding.
 *   - Deterministic output and built-in semantic checks.
 *   - C only: intended to work with MSVC, Clang, GCC/MinGW,
 *     OLLVM-family compilers, Tigress, and binary rewriters.
 *
 * Tool-specific obfuscation annotations should NOT be hardcoded here.
 * Build wrappers may define the OBF_* macros before compiling.
 */

#include <stdint.h>
#include <stdio.h>


/* -------------------------------------------------------------------------
 * Portability / analysis helpers
 * ------------------------------------------------------------------------- */

#if defined(_WIN32)
#define DEMO_EXPORT __declspec(dllexport)
#else
#define DEMO_EXPORT __attribute__((visibility("default")))
#endif

#if defined(_MSC_VER)
#define DEMO_NOINLINE __declspec(noinline)
#elif defined(__GNUC__) || defined(__clang__)
#define DEMO_NOINLINE __attribute__((noinline))
#else
#define DEMO_NOINLINE
#endif


/*
 * Tool-specific wrappers may redefine these, for example:
 *
 *   OBF_SUB
 *   OBF_BCF
 *   OBF_FLA
 *   OBF_CALL
 *   OBF_DATA
 *   OBF_COMBINED
 *
 * The canonical source itself remains obfuscator-independent.
 */

#ifndef OBF_SUB
#define OBF_SUB
#endif

#ifndef OBF_BCF
#define OBF_BCF
#endif

#ifndef OBF_FLA
#define OBF_FLA
#endif

#ifndef OBF_CALL
#define OBF_CALL
#endif

#ifndef OBF_DATA
#define OBF_DATA
#endif

#ifndef OBF_COMBINED
#define OBF_COMBINED
#endif


/* Runtime-visible inputs. */
volatile uint32_t g_input_a = 0x00001337u;
volatile uint32_t g_input_b = 0x12345678u;


/* -------------------------------------------------------------------------
 * Recognisable data for string/global encryption experiments
 * ------------------------------------------------------------------------- */

static const char g_message_alpha[] =
    "OBFUSCATION-DEMO-ALPHA-1337";

static const char g_message_bravo[] =
    "OBFUSCATION-DEMO-BRAVO-12345678";

static const uint32_t g_magic_table[] = {
    0x00001337u,
    0x12345678u,
    0x11111111u,
    0x22222222u
};


/* -------------------------------------------------------------------------
 * Small helper functions for direct/indirect call experiments
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t step_add_1337(uint32_t value)
{
    return value + 0x1337u;
}


DEMO_EXPORT DEMO_NOINLINE
uint32_t step_xor_12345678(uint32_t value)
{
    return value ^ 0x12345678u;
}


DEMO_EXPORT DEMO_NOINLINE
uint32_t step_sub_1111(uint32_t value)
{
    return value - 0x1111u;
}


/* -------------------------------------------------------------------------
 * 1. Instruction substitution
 *
 * Eight STATIC occurrences of the same XOR, ADD, and SUB operations.
 *
 * This is deliberately not a loop: we want the obfuscator to encounter
 * eight independent instruction sites so we can examine template diversity.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_substitution(uint32_t input) OBF_SUB
{
    volatile uint32_t value[8];

    value[0] = input + 0x01010101u;
    value[1] = input + 0x02020202u;
    value[2] = input + 0x03030303u;
    value[3] = input + 0x04040404u;
    value[4] = input + 0x05050505u;
    value[5] = input + 0x06060606u;
    value[6] = input + 0x07070707u;
    value[7] = input + 0x08080808u;

    /* Eight identical XOR sites. */
    value[0] ^= 0x12345678u;
    value[1] ^= 0x12345678u;
    value[2] ^= 0x12345678u;
    value[3] ^= 0x12345678u;
    value[4] ^= 0x12345678u;
    value[5] ^= 0x12345678u;
    value[6] ^= 0x12345678u;
    value[7] ^= 0x12345678u;

    /* Eight identical ADD sites. */
    value[0] += 0x1337u;
    value[1] += 0x1337u;
    value[2] += 0x1337u;
    value[3] += 0x1337u;
    value[4] += 0x1337u;
    value[5] += 0x1337u;
    value[6] += 0x1337u;
    value[7] += 0x1337u;

    /* Eight identical SUB sites. */
    value[0] -= 0x1111u;
    value[1] -= 0x1111u;
    value[2] -= 0x1111u;
    value[3] -= 0x1111u;
    value[4] -= 0x1111u;
    value[5] -= 0x1111u;
    value[6] -= 0x1111u;
    value[7] -= 0x1111u;

    return value[0] ^
           value[1] ^
           value[2] ^
           value[3] ^
           value[4] ^
           value[5] ^
           value[6] ^
           value[7];
}


/* -------------------------------------------------------------------------
 * 2. Bogus control flow / opaque predicate target
 *
 * The legitimate conditions use deliberately obvious constants so they can
 * be distinguished from opaque predicates introduced by an obfuscator.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_bogus_control_flow(uint32_t x, uint32_t y) OBF_BCF
{
    uint32_t result = 0x11111111u;

    if (x == 0x1337u) {
        result ^= 0x22222222u;
    } else {
        result += 0x3333u;
    }

    if (y > 0x12340000u) {
        result += 0x4444u;
    }

    if ((x & 0xFFu) == 0x37u) {
        result ^= 0x55555555u;
    }

    if ((y & 1u) == 0u) {
        result -= 0x6666u;
    } else {
        result += 0x7777u;
    }

    return result;
}


/* -------------------------------------------------------------------------
 * 3. Control-flow flattening target
 *
 * Contains:
 *   - if/else
 *   - loop
 *   - conditional inside loop
 *   - switch
 *   - reconverging control flow
 *
 * The clean CFG should be easy to understand before flattening.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_flattening(uint32_t input) OBF_FLA
{
    uint32_t value = input;
    uint32_t i;

    if ((value & 1u) != 0u) {
        value += 0x1111u;
    } else {
        value ^= 0x2222u;
    }

    for (i = 0; i < 4u; ++i) {
        if ((value & 0x100u) != 0u) {
            value ^= (0x1000u + i);
        } else {
            value += (0x0100u + i);
        }
    }

    switch (value & 3u) {
        case 0u:
            value += 0x11111111u;
            break;

        case 1u:
            value ^= 0x22222222u;
            break;

        case 2u:
            value -= 0x3333u;
            break;

        default:
            value += 0x4444u;
            break;
    }

    return value ^ 0xCAFEBABEu;
}


/* -------------------------------------------------------------------------
 * 4. Direct call / indirect call target
 *
 * Clean code should contain three very obvious direct calls.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_calls(uint32_t input) OBF_CALL
{
    uint32_t value;

    value = step_add_1337(input);
    value = step_xor_12345678(value);
    value = step_sub_1111(value);

    return value;
}


/* -------------------------------------------------------------------------
 * 5. Data / string encryption target
 *
 * The clean executable should contain obvious searchable plaintext and a
 * recognisable integer table.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_data(void) OBF_DATA
{
    uint32_t result = 0u;
    uint32_t i;

    for (i = 0; i < (uint32_t)(sizeof(g_message_alpha) - 1u); ++i) {
        result += (uint32_t)(unsigned char)g_message_alpha[i];
    }

    result ^= 0x11111111u;

    for (i = 0; i < (uint32_t)(sizeof(g_message_bravo) - 1u); ++i) {
        result += (uint32_t)(unsigned char)g_message_bravo[i];
    }

    for (i = 0; i < 4u; ++i) {
        result = (result + g_magic_table[i]) ^ g_magic_table[i];
    }

    return result;
}


/* -------------------------------------------------------------------------
 * 6. Combined / realistic stress target
 *
 * Used later for combinations of transformations.
 *
 * This is intentionally still small enough to understand manually.
 * ------------------------------------------------------------------------- */

DEMO_EXPORT DEMO_NOINLINE
uint32_t demo_combined(uint32_t x, uint32_t y) OBF_COMBINED
{
    uint32_t value;
    uint32_t i;

    value = step_add_1337(x);

    if ((y & 0xFFu) == 0x78u) {
        value ^= 0x22222222u;
    } else {
        value += 0x3333u;
    }

    for (i = 0; i < 3u; ++i) {
        value += 0x100u * (i + 1u);

        if ((value & 0x10u) != 0u) {
            value ^= (0x1000u + i);
        } else {
            value += (0x10u + i);
        }
    }

    if ((value & 1u) != 0u) {
        value = step_xor_12345678(value);
    } else {
        value = step_sub_1111(value);
    }

    switch (value & 3u) {
        case 0u:
            value += 0x4444u;
            break;

        case 1u:
            value ^= 0x55555555u;
            break;

        case 2u:
            value -= 0x6666u;
            break;

        default:
            value += 0x7777u;
            break;
    }

    return value ^ 0xDEADBEEFu;
}


/* -------------------------------------------------------------------------
 * Expected results for the canonical runtime inputs.
 *
 * These should be independently verified by the corpus-generation scripts.
 * ------------------------------------------------------------------------- */

#define EXPECT_SUB       0x08080000u
#define EXPECT_BCF       0x6665BBBCu
#define EXPECT_FLA       0xDBEFFCE7u
#define EXPECT_CALLS     0x12345F05u
#define EXPECT_DATA      0x57977293u
#define EXPECT_COMBINED  0xEEBB6D71u


/* -------------------------------------------------------------------------
 * Master showcase
 * ------------------------------------------------------------------------- */

int main(void)
{
    uint32_t input_a = g_input_a;
    uint32_t input_b = g_input_b;

    uint32_t result_sub;
    uint32_t result_bcf;
    uint32_t result_fla;
    uint32_t result_calls;
    uint32_t result_data;
    uint32_t result_combined;

    int failures = 0;

    result_sub =
        demo_substitution(input_a);

    result_bcf =
        demo_bogus_control_flow(input_a, input_b);

    result_fla =
        demo_flattening(input_a);

    result_calls =
        demo_calls(input_a);

    result_data =
        demo_data();

    result_combined =
        demo_combined(input_a, input_b);

    printf(
        "SUB      = %08X\n"
        "BCF      = %08X\n"
        "FLA      = %08X\n"
        "CALLS    = %08X\n"
        "DATA     = %08X\n"
        "COMBINED = %08X\n",
        (unsigned)result_sub,
        (unsigned)result_bcf,
        (unsigned)result_fla,
        (unsigned)result_calls,
        (unsigned)result_data,
        (unsigned)result_combined
    );

    if (result_sub != EXPECT_SUB)
        ++failures;

    if (result_bcf != EXPECT_BCF)
        ++failures;

    if (result_fla != EXPECT_FLA)
        ++failures;

    if (result_calls != EXPECT_CALLS)
        ++failures;

    if (result_data != EXPECT_DATA)
        ++failures;

    if (result_combined != EXPECT_COMBINED)
        ++failures;

    if (failures != 0) {
        printf("SHOWCASE FAIL: %d mismatches\n", failures);
        return 1;
    }

    puts("SHOWCASE PASS");

    return 0;
}