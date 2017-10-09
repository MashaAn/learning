import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.*

@DisplayName("roman to arabic conversion")
class RomanToArabicTest {
    @Nested
    @DisplayName("addition rules should")
    inner class AdditionRules
    {
        @Test
        fun `return I's as 1`() {
            assertThat(Roman("I").toArabic()).isEqualTo(1)
            assertThat(Roman("II").toArabic()).isEqualTo(2)
            assertThat(Roman("III").toArabic()).isEqualTo(3)
        }

        @Test
        fun `return V's as 5`() {
            assertThat(Roman("V").toArabic()).isEqualTo(5)
            assertThat(Roman("VIII").toArabic()).isEqualTo(8)
        }

        @Test
        fun `return X's as 10`() {
            assertThat(Roman("X").toArabic()).isEqualTo(10)
            assertThat(Roman("XXVIII").toArabic()).isEqualTo(28)
        }

        @Test
        fun `return L's as 50`() {
            assertThat(Roman("L").toArabic()).isEqualTo(50)
            assertThat(Roman("LXXXVII").toArabic()).isEqualTo(87)
        }

        @Test
        fun `return C's as 100`() {
            assertThat(Roman("C").toArabic()).isEqualTo(100)
            assertThat(Roman("CLXXVIII").toArabic()).isEqualTo(178)
        }

        @Test
        fun `return D's as 500`() {
            assertThat(Roman("D").toArabic()).isEqualTo(500)
            assertThat(Roman("DCCLXI").toArabic()).isEqualTo(761)
        }
    }
    
    @Nested
    @DisplayName("subtraction rules should")
    inner class SubtractionRules {
        @Test
        fun `return IV as 4`() {
            assertThat(Roman("IV").toArabic()).isEqualTo(4)
        }

        @Test
        fun `return IX as 9`() {
            assertThat(Roman("IX").toArabic()).isEqualTo(9)
        }
    }
}